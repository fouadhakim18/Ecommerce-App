import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../const/colors.dart';
import '../../const/lists.dart';
import '../../const/styles.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../services/firestore_services.dart';
import '../../widgets/button.dart';
import '../../widgets/input_fields.dart';
import '../../widgets/utils.dart';
import '../auth_screen/login_screen.dart';
import '../chat_screen/messaging_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return WillPopScope(
      onWillPop: () async {
        return await Utils.showExitDialog();
      },
      child: SafeArea(
        child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () async {
                      await Get.put(AuthController()).singOut(context);
                      Get.offAll(() => const LoginScreen());
                    },
                    icon: Icon(
                      Icons.logout,
                      color: AppColors.redColor,
                      size: 28,
                    ))
              ],
            ),
            backgroundColor: AppColors.lightGrey,
            body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirestoreService.getUser().asStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else if (snapshot.hasData) {
                  final data = snapshot.data;
                  controller.nameController.text = data!["Name"];
                  controller.shopNameController.text = data["shop_name"];
                  controller.shopAdressController.text = data["shop_adress"];
                  controller.shopMobileController.text = data["shop_mobile"];
                  controller.shopDescController.text = data["shop_desc"];

                  return Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Obx(
                          () => Expanded(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () => controller.changeImage(context),
                                  child: Stack(children: [
                                    data["ImageUrl"] == "" &&
                                            controller
                                                .profileImgPath.value.isEmpty
                                        ? const CircleAvatar(
                                            backgroundColor:
                                                AppColors.mainColor,
                                            radius: 55,
                                            backgroundImage: AssetImage(
                                                "assets/images/anonyme.png"))
                                        : data["ImageUrl"] != "" &&
                                                controller.profileImgPath.value
                                                    .isEmpty
                                            ? ClipOval(
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  width: 110,
                                                  height: 110,
                                                  imageUrl: data["ImageUrl"],
                                                  placeholder: (context, url) =>
                                                      const CircularProgressIndicator(),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                ),
                                              )
                                            : CircleAvatar(
                                                backgroundColor:
                                                    AppColors.mainColor,
                                                radius: 55,
                                                backgroundImage: FileImage(File(
                                                    controller
                                                        .profileImgPath.value)),
                                              ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(80)),
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
                                  height: 10,
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          top: 10,
                                          right: 12,
                                          left: 12,
                                          bottom: 12),
                                      child: Center(
                                        child: Column(children: [
                                          inputField(
                                              controller:
                                                  controller.nameController,
                                              title: "Name",
                                              icon: Icons.person,
                                              isFilled: true),
                                          inputField(
                                            controller:
                                                controller.shopNameController,
                                            title: "Shop Name",
                                            icon: Icons.shop,
                                            isFilled: true,
                                          ),
                                          inputField(
                                            controller:
                                                controller.shopAdressController,
                                            title: "Shop Adress",
                                            icon: Icons.location_city,
                                            isFilled: true,
                                          ),
                                          inputField(
                                            controller:
                                                controller.shopMobileController,
                                            title: "Shop Mobile",
                                            icon: Icons.phone,
                                            isFilled: true,
                                          ),
                                          inputField(
                                              controller:
                                                  controller.shopDescController,
                                              title: "Shop Description",
                                              icon: Icons.description,
                                              isFilled: true,
                                              maxLines: 4),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          controller.isLoading.value
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: AppColors.mainColor,
                                                  ),
                                                )
                                              : Button(
                                                  text: "Update",
                                                  clicked: () async {
                                                    controller.isLoading(true);
                                                    // await controller.uploadProfileImg();

                                                    await controller
                                                        .updateProfile(
                                                      name: controller
                                                          .nameController.text,
                                                    );
                                                    Utils.showToast(
                                                        "data updated");

                                                    controller.isLoading(false);
                                                  },
                                                ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Button(
                                            text: "Change Password",
                                            clicked: () async {
                                              showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                                useSafeArea: true,
                                                isDismissible: true,
                                                builder:
                                                    (BuildContext context) {
                                                  return SingleChildScrollView(
                                                    padding: EdgeInsets.only(
                                                      bottom:
                                                          MediaQuery.of(context)
                                                              .viewInsets
                                                              .bottom,
                                                    ),
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10,
                                                          vertical: 10),
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .lightGrey,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10))),
                                                      child: Obx(
                                                        () => Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              inputField(
                                                                  controller:
                                                                      controller
                                                                          .oldPassController,
                                                                  title:
                                                                      "Old Password",
                                                                  icon: Icons
                                                                      .password,
                                                                  isFilled:
                                                                      true,
                                                                  isPassword:
                                                                      true),
                                                              inputField(
                                                                  controller:
                                                                      controller
                                                                          .newPassController,
                                                                  title:
                                                                      "New Password",
                                                                  icon: Icons
                                                                      .password,
                                                                  isFilled:
                                                                      true,
                                                                  isPassword:
                                                                      true),
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              controller
                                                                      .isLoading
                                                                      .value
                                                                  ? const Center(
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        color: AppColors
                                                                            .mainColor,
                                                                      ),
                                                                    )
                                                                  : Button(
                                                                      text:
                                                                          "Update Password",
                                                                      clicked:
                                                                          () async {
                                                                        controller
                                                                            .isLoading(true);
                                                                        if (controller.oldPassController.text ==
                                                                            data["Password"]) {
                                                                          await controller.changeAuthPassword(
                                                                              email: data["Email"],
                                                                              password: controller.oldPassController.text,
                                                                              newpassword: controller.newPassController.text,
                                                                              context: context);
                                                                        } else {
                                                                          Utils.showToast(
                                                                              "wrong old password");
                                                                        }

                                                                        controller
                                                                            .isLoading(false);
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
                                            color: Colors.white,
                                            textColor: AppColors.purpleColor,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.mainColor,
                  ),
                );
              },
            )),
      ),
    );
  }
}
