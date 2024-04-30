import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../const/firebase_consts.dart';

class HomeController extends GetxController {
  final navIndex = 0.obs;
  String username = "";
  String? token;

  getUsername() async {
    final userDoc =
        await firestore.collection("sellers").doc(currentUser!.uid).get();
    if (userDoc.exists) {
      username = userDoc['Name'];
    }
  }

  Future<void> updateToken(String? token) async {
    try {
      await FirebaseFirestore.instance
          .collection('sellers')
          .doc(currentUser!.uid)
          .update({"UserToken": token});
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void onInit() async {
    await getUsername();
    token = await fbm.getToken();
    await updateToken(token);
    FirebaseMessaging.onMessage.listen((event) {});
    super.onInit();
  }
}
