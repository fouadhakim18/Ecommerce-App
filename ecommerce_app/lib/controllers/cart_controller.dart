import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/firebase_consts.dart';
import 'package:ecommerce_app/controllers/home_controller.dart';
import 'package:ecommerce_app/services/firebase_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/utils.dart';

class CartController extends GetxController {
  final formKey = GlobalKey<FormState>();

  RxInt totalPrice = 0.obs;

// Text controllers for shipping details
  final adressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pCodeController = TextEditingController();
  final phoneController = TextEditingController();

  // Payment

  final paymentIndex = 0.obs;

  // cart products
  dynamic productSnapshot;
  final products = [];
  List<String> vendorsIds = [];
  List<String> vendorsTokens = [];
  final placingOrder = false.obs;

  calculatePrice(data) {
    totalPrice.value = 0;
    for (var i = 0; i < data.length; i++) {
      totalPrice += int.parse(data[i]['total_price'].toString());
    }
  }

  updateQuantity(
      {required docId,
      required qty,
      required itemPrice,
      required context}) async {
    final cartItemRef = firestore.collection('cart').doc(docId);

    try {
      await cartItemRef
          .update({'quantity': qty, 'total_price': int.parse(itemPrice) * qty});
      Utils.showToast("quantity updated");
    } catch (e) {
      Utils.showToast(e.toString());
    }
  }

  changePaymentIndex(index) {
    paymentIndex.value = index;
  }

  placeMyOrder({required orderPaymentMethod, required totalAmount}) async {
    placingOrder(true);
    await getProductDetails();
    await getUniqueVendorIds();

    await firestore.collection("orders").doc().set({
      'order_token': Get.find<HomeController>().token,
      'order_code': "233498584",
      'order_date': FieldValue.serverTimestamp(),
      'order_by': currentUser!.uid,
      'order_by_name': Get.find<HomeController>().username,
      'order_by_email': currentUser!.email,
      'order_by_adress': adressController.text,
      'order_by_state': stateController.text,
      'order_by_city': cityController.text,
      'order_by_phone': phoneController.text,
      'order_by_postalcode': pCodeController.text,
      'shipping_method': "Home Delivery",
      'payment_method': orderPaymentMethod,
      'total_amount': totalAmount,
      'orders': FieldValue.arrayUnion(products),
      'vendors': FieldValue.arrayUnion(vendorsIds)
    });

    placingOrder(false);
    for (var vendorTkn in vendorsTokens) {
      print(vendorTkn);
      sendNotif(
          "New Order Received",
          'You have a new order from ${Get.find<HomeController>().username}',
          vendorTkn);
      print("sent");
    }
  }

  getProductDetails() {
    products.clear();
    for (var i = 0; i < productSnapshot.length; i++) {
      products.add({
        'color': productSnapshot[i]["color"],
        'img': productSnapshot[i]["img"],
        'quantity': productSnapshot[i]["quantity"],
        'vendor_id': productSnapshot[i]['vendor_id'],
        'vendor_token': productSnapshot[i]['vendor_token'],
        'total_price': productSnapshot[i]['total_price'],
        'title': productSnapshot[i]["title"],
        'order_placed': true,
        'order_confirmed': false,
        'order_delivered': false,
        'order_on_delivery': false,
      });
    }
  }

  getUniqueVendorIds() {
    Set<String> uniqueIds = <String>{};

    for (var product in products) {
      uniqueIds.add(product["vendor_id"]);
      vendorsTokens.add(product['vendor_token']);
    }

    vendorsIds = uniqueIds.toList();
  }

  clearCart() async {
    for (var i = 0; i < productSnapshot.length; i++) {
      firestore.collection('cart').doc(productSnapshot[i].id).delete();
    }
  }
}
