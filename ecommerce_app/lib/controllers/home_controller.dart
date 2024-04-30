import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/firebase_consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../models/category_model.dart';

class HomeController extends GetxController {
  var currentNavIndex = 0.obs;
  String username = "";
  final searchController = TextEditingController();
  String? token;

  getUsername() async {
    final userDoc =
        await firestore.collection("users").doc(currentUser!.uid).get();
    if (userDoc.exists) {
      username = userDoc['Name'];
    }
  }

  Future<void> updateToken(String? token) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update({"UserToken": token});
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void onReady() async {
    await getUsername();
    token = await fbm.getToken();
    await updateToken(token);
    FirebaseMessaging.onMessage.listen((event) {});
    super.onInit();
  }
}
