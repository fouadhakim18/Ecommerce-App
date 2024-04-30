import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/controllers/product_controller.dart';
import 'package:get/get.dart';

import '../services/firestore_services.dart';

class CatDetailsController extends GetxController {
  Rx<Stream<QuerySnapshot>>? productMethod;
  final subCatIndex = 0.obs;
  switchCategory(title) {
    if (Get.find<ProductController>().subCat.contains(title)) {
      productMethod!.value = FirestoreService.getSubCatProducts(title);
    } else {
      productMethod!.value = FirestoreService.getProducts(title);
    }
  }

  @override
  void onInit() {
    productMethod = Stream<QuerySnapshot>.empty().obs;
    switchCategory(Get.arguments);
    super.onInit();
  }
}
