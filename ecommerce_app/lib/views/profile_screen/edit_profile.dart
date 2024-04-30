import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/controllers/profile_controller.dart';
import 'package:ecommerce_app/views/home_screen/home.dart';
import 'package:ecommerce_app/widgets/button.dart';
import 'package:ecommerce_app/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../consts/colors.dart';
import '../../consts/images.dart';
import '../../widgets/utils.dart';

class EditProfile extends StatelessWidget {
  final dynamic data;
  const EditProfile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.lightGrey,
        extendBodyBehindAppBar: true,
        appBar: AppBar(),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding:
                const EdgeInsets.only(top: 60, right: 12, left: 12, bottom: 12),
            child: Center(
              child: Obx(
                () => Column(children: [
                  GestureDetector(
                    onTap: () => controller.changeImage(context),
                    child: Stack(children: [
                      data["ImageUrl"] == "" &&
                              controller.profileImgPath.value.isEmpty
                          ? const CircleAvatar(
                              backgroundColor: AppColors.mainColor,
                              radius: 65,
                              backgroundImage:
                                  AssetImage("assets/images/anonyme.png"))
                          : data["ImageUrl"] != "" &&
                                  controller.profileImgPath.value.isEmpty
                              ? ClipOval(
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    width: 120,
                                    height: 120,
                                    imageUrl: data?["ImageUrl"],
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(
                                      color: AppColors.mainColor,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundColor: AppColors.mainColor,
                                  radius: 65,
                                  backgroundImage: FileImage(
                                      File(controller.profileImgPath.value)),
                                ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(80)),
                            child: const Center(
                              child: Icon(
                                Icons.edit,
                                color: AppColors.mainColor,
                                size: 16,
                              ),
                            )),
                      )
                    ]),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  inputField(
                      controller: controller.nameController,
                      title: "Name",
                      icon: Icons.person,
                      textColor: AppColors.darkFontGrey,
                      addTitle: true,
                      isFilled: true),
                  inputField(
                      controller: controller.emailController,
                      title: "Email",
                      icon: Icons.email,
                      textColor: AppColors.darkFontGrey,
                      addTitle: true,
                      isFilled: true),
                  const SizedBox(
                    height: 30,
                  ),
                  Obx(
                    () => controller.isLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.mainColor,
                            ),
                          )
                        : Button(
                            text: "Update",
                            clicked: () async {
                              controller.isLoading(true);

                              await controller.updateProfile(
                                name: controller.nameController.text,
                                email: controller.emailController.text,
                              );
                              Utils.showToast("data updated");

                              controller.isLoading(false);
                            },
                            color: AppColors.mainColor,
                          ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Button(
                    text: "Change Password",
                    clicked: () async {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        useSafeArea: true,
                        isDismissible: true,
                        builder: (BuildContext context) {
                          return SingleChildScrollView(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                  color: AppColors.lightGrey,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))),
                              child: Obx(
                                () => Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      inputField(
                                          controller:
                                              controller.oldPassController,
                                          title: "Old Password",
                                          icon: Icons.lock,
                                          isFilled: true,
                                          isPassword: true),
                                      inputField(
                                          controller:
                                              controller.newPassController,
                                          title: "New Password",
                                          icon: Icons.lock,
                                          isFilled: true,
                                          isPassword: true),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      controller.isLoading.value
                                          ? const Center(
                                              child: CircularProgressIndicator(
                                                color: AppColors.mainColor,
                                              ),
                                            )
                                          : Button(
                                              text: "Update Password",
                                              clicked: () async {
                                                controller.isLoading(true);
                                                if (controller.oldPassController
                                                        .text ==
                                                    data["Password"]) {
                                                  await controller
                                                      .changeAuthPassword(
                                                          context: context,
                                                          email: data["Email"],
                                                          password: controller
                                                              .oldPassController
                                                              .text,
                                                          newpassword: controller
                                                              .newPassController
                                                              .text);
                                                } else {
                                                  Utils.showToast(
                                                      "wrong old password");
                                                }

                                                controller.isLoading(false);
                                              },
                                            ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ]),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    color: AppColors.whiteColor,
                    textColor: AppColors.redColor,
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
