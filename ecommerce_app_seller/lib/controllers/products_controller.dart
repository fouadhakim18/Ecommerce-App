import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_seller/controllers/home_controller.dart';
import 'package:ecommerce_app_seller/models/category_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../const/firebase_consts.dart';
import '../views/home_screen/home.dart';
import '../widgets/utils.dart';

class ProductsController extends GetxController {
  @override
  void onInit() async {
    final arg = Get.arguments;
    await getCategories();
    populateCategoryList();
    if (arg != null) {
      pnameController.text = arg['p_name'];
      pdescController.text = arg['p_desc'];
      ppriceController.text = arg['p_price'];
      pquantityController.text = arg['p_quantity'];
      categoryValue.value = arg['p_category'];
      populateSubCategoryList(categoryValue.value);
      subcategoryValue.value = arg['p_subcategory'];
      for (var i = 0; i < arg['p_imgs'].length; i++) {
        pImgsEdit[i] = arg['p_imgs'][i];
      }

      for (var color in arg['p_colors']) {
        availableColors.add(color);
      }
    }

    super.onInit();
  }

  final pnameController = TextEditingController();
  final pdescController = TextEditingController();
  final ppriceController = TextEditingController();
  final pquantityController = TextEditingController();
  final categoryList = <String>[].obs;
  final subcategoryList = <String>[].obs;
  List<Category> category = [];
  final pImagesLinks = [];
  final pImagesList = RxList<dynamic>.generate(3, (index) => null);

  final pImgsEdit = RxList<dynamic>.generate(3, (index) => null);
  final categoryValue = "".obs;
  final subcategoryValue = "".obs;

  final isLoading = false.obs;
  final formKey = GlobalKey<FormState>();

  final availableColors = <int>[].obs;
  Color selectedColor = Colors.red;

  getCategories() async {
    final data = await rootBundle.loadString("assets/files/category.json");
    final cat = categoryModelFromJson(data);
    category = cat.categories;
  }

  populateCategoryList() {
    categoryList.clear();

    for (var element in category) {
      categoryList.add(element.name);
    }
  }

  populateSubCategoryList(cat) {
    subcategoryList.clear();
    final data = category.where((element) => element.name == cat).toList();
    for (var i = 0; i < data.first.subcategory.length; i++) {
      subcategoryList.add(data.first.subcategory[i]);
    }
  }

  pickImage(index, context) async {
    try {
      final img = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (img == null) return;
      pImagesList[index] = File(img.path);
    } catch (e) {
      Utils.showToast(e.toString());
    }
  }

  uploadImages() async {
    if (pImagesList.isNotEmpty) {
      pImagesLinks.clear();

      for (var img in pImagesList) {
        if (img != null) {
          final filename = basename(img.path);
          final destination = "images/vendors/${currentUser!.uid}/$filename";
          Reference ref = FirebaseStorage.instance.ref().child(destination);
          await ref.putFile(img);
          final n = await ref.getDownloadURL();
          pImagesLinks.add(n);
        }
      }
    }
  }

  uploadProduct(context) async {
    final store = Get.arguments != null
        ? firestore.collection("products").doc(Get.arguments.id)
        : firestore.collection("products").doc();
    await store.set({
      'p_category': categoryValue.value,
      'p_subcategory': subcategoryValue.value,
      'p_colors': FieldValue.arrayUnion(availableColors),
      'p_imgs':
          FieldValue.arrayUnion(pImagesLinks.isNotEmpty ? pImagesLinks : []),
      'p_wishlist': FieldValue.arrayUnion([]),
      'p_desc': pdescController.text,
      'p_name': pnameController.text,
      'p_price': ppriceController.text,
      'p_quantity': pquantityController.text,
      'p_seller': Get.find<HomeController>().username,
      'vendor_id': currentUser!.uid,
      'vendor_token': Get.find<HomeController>().token,
    }, SetOptions(merge: true));

    Utils.showToast("product uploaded");
    Get.offAll(() => const Home());
  }

  validateProductForm(context) async {
    if (formKey.currentState!.validate()) {
      if (categoryValue.value == "") {
        Utils.showToast("select category");
      } else if (subcategoryValue.value == "") {
        Utils.showToast("select subcategory");
      } else {
        bool containsNonNullElement =
            pImagesList.any((element) => element != null);
        if (containsNonNullElement || Get.arguments != null) {
          if (availableColors.isEmpty) {
            Utils.showToast("add a color");
          } else {
            isLoading(true);
            await uploadImages();
            await uploadProduct(context);
            isLoading(false);
          }
        } else {
          Utils.showToast("select image");
        }
      }
    }
  }
}
