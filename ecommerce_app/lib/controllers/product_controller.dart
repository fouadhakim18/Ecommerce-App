import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/firebase_consts.dart';
import 'package:ecommerce_app/models/category_model.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


import '../consts/colors.dart';
import '../widgets/utils.dart';

class ProductController extends GetxController {
  @override
  final quantity = 0.obs;
  final colorIndex = 0.obs;
  final totalPrice = 0.obs;

  RxBool isLoading = false.obs;
  final isFav = false.obs;

  List<dynamic> subCat = [];

  getSubCategories(title) async {
    subCat.clear();
    final data = await rootBundle.loadString("assets/files/category.json");
    final decoded = categoryModelFromJson(data);
    final s = decoded.categories.where((element) {
      return element.name == title;
    }).toList();

    for (var e in s[0].subcategory) {
      subCat.add(e);
    }
  }

  increaseQuantity(total, price) {
    if (quantity.value < total) {
      quantity.value++;
      totalPrice.value = price * quantity.value;
    }
  }

  decreaseQuantity(price) {
    if (quantity.value > 0) {
      quantity.value--;
      totalPrice.value = price * quantity.value;
    }
  }

  changeColorIndex(index) {
    colorIndex.value = index;
  }

  addToCart(
      {required title,
      required img,
      required sellerName,
      required color,
      required quantity,
      required itemPrice,
      required vendorId,
      required context, required vendorToken}) async {
    isLoading(true);
    try {
      await firestore.collection("cart").doc().set({
        'title': title,
        'img': img,
        'seller_name': sellerName,
        'color': color,
        'quantity': quantity,
        "item_price": itemPrice,
        'total_price': totalPrice.value,
        'vendor_id': vendorId,
        'added_by': currentUser!.uid,
        'vendor_token': vendorToken,
      });
       Utils.showToast("item added to cart");
      isLoading(false);
    } catch (e) {
      isLoading(false);
    Utils.showToast(e.toString());
    }
  }

  resetValues() {
    totalPrice.value = 0;
    quantity.value = 0;
    colorIndex.value = 0;
  }

  addToWishlist(docId, context) async {
    await firestore.collection("products").doc(docId).update({
      "p_wishlist": FieldValue.arrayUnion([currentUser!.uid])
    });
    isFav(true);
    Utils.showToast("added to wishlist");
  }

  removeFromWishlist(docId, context) async {
    await firestore.collection("products").doc(docId).update({
      "p_wishlist": FieldValue.arrayRemove([currentUser!.uid])
    });
    isFav(false);
     Utils.showToast("item removed");
  }

  checkIsFav(data) {
    isFav.value = data["p_wishlist"].contains(currentUser!.uid);
  }
}
