import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_seller/services/firebase_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../const/firebase_consts.dart';
import 'home_controller.dart';

class ChatController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getChatId();
  }

  final chats = firestore.collection("chats");
  final senderName = Get.arguments[0];
  final senderId = Get.arguments[1];

  final friendName = Get.find<HomeController>().username;
  final friendId = currentUser!.uid; // user who sent the msg not seller
  final messageController = TextEditingController();
  dynamic chatDocId;

  final isLoading = false.obs;
  getChatId() async {
    isLoading(true);
    final snapshot = await chats
        .where('users', isEqualTo: {friendId: null, senderId: null})
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      chatDocId = snapshot.docs.single.id;
    } else {
      final docRef = await chats.add({
        'created_on': null,
        'last_msg': '',
        'users': {friendId: null, senderId: null},
        'toId': '',
        'fromId': '',
        'friend_name': friendName,
        'sender_name': senderName
      });

      chatDocId = docRef.id;
    }
    isLoading(false);
  }

  sendMsg(String msg) async {
    if (msg.trim().isNotEmpty) {
      final chatDoc = chats.doc(chatDocId);
      chatDoc.update({
        'created_on': FieldValue.serverTimestamp(),
        'last_msg': msg,
      });

      chatDoc.collection("messages").doc().set({
        'created_on': FieldValue.serverTimestamp(),
        'msg': msg,
        'uid': friendId,
      });

      final chatDocum = await chatDoc.get();
      sendNotif(
          Get.find<HomeController>().username, msg, chatDocum["sender_token"]);
    }
  }
}
