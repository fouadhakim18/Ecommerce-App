import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/colors.dart';
import 'package:ecommerce_app/consts/images.dart';
import 'package:ecommerce_app/consts/lists.dart';
import 'package:ecommerce_app/consts/styles.dart';
import 'package:ecommerce_app/controllers/profile_controller.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:ecommerce_app/views/auth_screen/login_screen.dart';
import 'package:ecommerce_app/views/chat_screen/messaging_screen.dart';
import 'package:ecommerce_app/views/orders_screen/orders_screen.dart';
import 'package:ecommerce_app/views/profile_screen/edit_profile.dart';
import 'package:ecommerce_app/views/wishlist_screen/wishlist_screen.dart';
import 'package:ecommerce_app/widgets/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:skeletons/skeletons.dart';
import '../../consts/firebase_consts.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/profile_skeleton.dart';
import '../../widgets/utils.dart';

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

                  return Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 35,
                        ),
                        Row(
                          children: [
                            data?["ImageUrl"] == ""
                                ? const CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        AssetImage("assets/images/anonyme.png"),
                                  )
                                : ClipOval(
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      width: 60,
                                      height: 60,
                                      imageUrl: data?["ImageUrl"],
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  )
                            // : CircleAvatar(
                            //     radius: 30,
                            //     backgroundImage:
                            //         NetworkImage(data?["ImageUrl"]),
                            //   ),
                            ,
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data!["Name"],
                                  style: const TextStyle(
                                      // color: Colors.white,
                                      fontSize: 13,
                                      fontFamily: AppStyles.semibold),
                                ),
                                Text(currentUser!.email!,
                                    style: TextStyle(
                                        // color: Colors.white,
                                        fontSize: 13))
                              ],
                            )),
                            OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.white),
                                    backgroundColor: AppColors.redColor),
                                onPressed: () async {
                                  await Get.put(AuthController())
                                      .singOut(context);
                                  Get.offAll(() => const LoginScreen());
                                },
                                child: const Text(
                                  "Log Out",
                                  style: TextStyle(color: Colors.white),
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StreamBuilder(
                                  stream: FirestoreService.getCartCounts(),
                                  builder: (context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                      return CircularProgressIndicator();
                                    }
                                    return profileCard(
                                        width: Get.width / 3.2,
                                        number: snapshot.data!.docs.length,
                                        text: "In your cart");
                                  }),
                              StreamBuilder(
                                  stream: FirestoreService.getWishlist(),
                                  builder: (context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                      return CircularProgressIndicator();
                                    }
                                    return profileCard(
                                        width: Get.width / 3.2,
                                        number: snapshot.data!.docs.length,
                                        text: "In your wishlist");
                                  }),
                              StreamBuilder(
                                  stream: FirestoreService.getOrdersCounts(),
                                  builder: (context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                      return CircularProgressIndicator();
                                    }
                                    return profileCard(
                                        width: Get.width / 3.2,
                                        number: snapshot.data!.docs.length,
                                        text: "Your orders");
                                  }),
                            ]),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemBuilder: (_, index) => ListTile(
                                  onTap: () {
                                    switch (index) {
                                      case 0:
                                        controller.nameController.text =
                                            data["Name"];
                                        controller.emailController.text =
                                            data['Email'];
                                        Get.to(() => EditProfile(data: data),
                                            transition: Transition.downToUp);
                                        break;
                                      case 1:
                                        Get.to(() => const OrdersScreen(),
                                            transition: Transition.fadeIn);
                                        break;
                                      case 2:
                                        Get.to(() => const WishlistScreen(),
                                            transition: Transition.fadeIn);
                                        break;
                                      case 3:
                                        Get.to(
                                          () => const MessagingScreen(),
                                          transition: Transition.downToUp,
                                        );
                                        break;

                                      default:
                                    }
                                  },
                                  title: Text(
                                    profileButtonsList[index],
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: AppStyles.semibold,
                                        color: AppColors.darkFontGrey),
                                  ),
                                  leading: Icon(
                                    profileButtonsIcons[index],
                                  )),
                              separatorBuilder: (_, index) => const Divider(
                                    color: AppColors.lightGrey,
                                  ),
                              itemCount: profileButtonsList.length),
                        )
                      ],
                    ),
                  );
                }
                return profileSkeleton();
              },
            )),
      ),
    );
  }
}
