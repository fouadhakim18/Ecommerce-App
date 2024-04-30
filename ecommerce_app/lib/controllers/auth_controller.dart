import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/controllers/home_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../consts/firebase_consts.dart';
import '../views/home_screen/home.dart';
import '../widgets/utils.dart';

class AuthController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool isLoading = false.obs;

  final homeController = Get.put(HomeController());
  // Login Method

  Future<UserCredential?> login(context, formKey) async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      UserCredential? userCredential;
      try {
        userCredential = await auth.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim());
        currentUser = userCredential.user;

        Utils.showToast("logged in");
        Get.offAll(() => const Home());
        isLoading.value = false;
      } on FirebaseAuthException catch (e) {
        Utils.showToast(e.message.toString());

        isLoading.value = false;
      }
      homeController.currentNavIndex.value = 0;

      return userCredential;
    }
  }

// Signup Method

  Future<UserCredential?> signUp(
      {required name,
      required email,
      required password,
      required context,
      required formKey}) async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      UserCredential? userCredential;
      try {
        userCredential = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        currentUser = userCredential.user;
        await storeUserData(name: name, password: password, email: email);
        Get.offAll(() => const Home());
        Utils.showToast("signed up");

        isLoading.value = false;
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        Utils.showToast(e.message.toString());
      }
      homeController.currentNavIndex.value = 0;
      Get.to(() => Home());
      return userCredential;
    }
  }

  // Storing Data Method

  storeUserData({required name, required password, required email}) async {
    DocumentReference store =
        firestore.collection("users").doc(currentUser!.uid);
    store.set({
      "Id": currentUser!.uid,
      "Name": name,
      "Password": password,
      "Email": email,
      "ImageUrl": "",
    });
  }

  // Signout Method
  singOut(context) async {
    try {
      await auth.signOut();
    } catch (e) {
      Utils.showToast(e.toString());
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
