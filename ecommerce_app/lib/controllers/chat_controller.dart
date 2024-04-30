import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/firebase_consts.dart';
import 'package:ecommerce_app/controllers/home_controller.dart';
import 'package:ecommerce_app/services/firebase_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getChatId();
  }

  final chats = firestore.collection("chats");
  final friendName = Get.arguments[0];
  final friendId = Get.arguments[1];
  final friendToken = Get.arguments[2];

  final senderName = Get.find<HomeController>().username;
  final senderId = currentUser!.uid;
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
        'sender_name': senderName,
        'friend_token': friendToken,
        'sender_token': Get.find<HomeController>().token,
      });

      chatDocId = docRef.id;
    }
    isLoading(false);
  }

  sendMsg(String msg) {
    if (msg.trim().isNotEmpty) {
      chats.doc(chatDocId).update({
        'created_on': FieldValue.serverTimestamp(),
        'last_msg': msg,
        'toId': friendId,
        'fromId': senderId,
      });

      chats.doc(chatDocId).collection("messages").doc().set({
        'created_on': FieldValue.serverTimestamp(),
        'msg': msg,
        'uid': senderId,
      });

      sendNotif(Get.find<HomeController>().username, msg, friendToken);
    }
  }
}
