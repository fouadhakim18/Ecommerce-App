import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../const/firebase_consts.dart';
import '../widgets/utils.dart';

class ProfileController extends GetxController {
  final profileImgPath = "".obs;
  String profileImgLink = "";
  RxBool isLoading = false.obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController oldPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();

  TextEditingController shopNameController = TextEditingController();
  TextEditingController shopAdressController = TextEditingController();
  TextEditingController shopWebsiteController = TextEditingController();
  TextEditingController shopMobileController = TextEditingController();
  TextEditingController shopDescController = TextEditingController();

  changeImage(context) async {
    isLoading(true);

    try {
      final img = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (img == null) return;
      profileImgPath.value = img.path;
      await uploadProfileImg();
      final store = firestore.collection("sellers").doc(currentUser!.uid);
      await store.update({"ImageUrl": profileImgLink});
      Utils.showToast("profile picture updated");
    } on PlatformException catch (e) {
      Utils.showToast(e.message.toString());
    }
    isLoading(false);
  }

  uploadProfileImg() async {
    final filename = basename(profileImgPath.value);
    final destination = "images/${currentUser!.uid}/$filename";
    Reference ref = FirebaseStorage.instance.ref().child(destination);
    await ref.putFile(File(profileImgPath.value));
    profileImgLink = await ref.getDownloadURL();
  }

  updateProfile({required name}) async {
    final store = firestore.collection("sellers").doc(currentUser!.uid);
    await store.update({
      "Name": name,
      "shop_name": shopNameController.text,
      "shop_adress": shopAdressController.text,
      "shop_mobile": shopMobileController.text,
      "shop_desc": shopDescController.text,
    });
  }

  changeAuthPassword(
      {required email,
      required password,
      required newpassword,
      required context}) async {
    final cred = EmailAuthProvider.credential(email: email, password: password);
    try {
      await currentUser!.reauthenticateWithCredential(cred);
      await currentUser!.updatePassword(newpassword);
      final store = firestore.collection("sellers").doc(currentUser!.uid);
      await store.update({"Password": newpassword});
      Get.back();

      Utils.showToast("password updated");
    } catch (e) {
      Utils.showToast(e.toString());
    }
  }
}
