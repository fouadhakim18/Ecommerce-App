import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_seller/views/orders_screen/orders_screen.dart';
import 'package:get/get.dart';

import '../const/firebase_consts.dart';

class FirestoreService {
  static Future<DocumentSnapshot<Map<String, dynamic>>> getUser() async {
    final doc =
        await firestore.collection("sellers").doc(currentUser!.uid).get();
    return doc;
  }

  static getChatMessages(docId) {
    return firestore
        .collection("chats")
        .doc(docId)
        .collection("messages")
        .orderBy("created_on", descending: true)
        .snapshots();
  }

  static getAllMessages() {
    return firestore
        .collection("chats")
        .where("toId", isEqualTo: currentUser!.uid)
        .orderBy("created_on", descending: true)
        .snapshots();
  }

  static getOrders() {
    return firestore
        .collection('orders')
        .where('vendors', arrayContains: currentUser!.uid)
        .snapshots();
  }

  static getProducts() {
    return firestore
        .collection("products")
        .where("vendor_id", isEqualTo: currentUser!.uid)
        .snapshots();
  }

  static deleteProduct(docId) async {
    await firestore.collection("products").doc(docId).delete();
  }
}
