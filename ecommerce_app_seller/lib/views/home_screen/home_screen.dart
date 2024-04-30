import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_seller/const/colors.dart';
import 'package:ecommerce_app_seller/const/num_curr.dart';
import 'package:ecommerce_app_seller/views/products_screen/product_details.dart';
import 'package:ecommerce_app_seller/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../../const/styles.dart';
import '../../services/firestore_services.dart';
import '../../widgets/dashboard_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar("Dashboard"),
        body: StreamBuilder(
          stream: FirestoreService.getProducts(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (snapshot.hasData) {
              if (snapshot.data!.docs.isEmpty) {
                return Container(
                  height: 50,
                  child: const Center(
                    child: Text(
                      "No Products",
                      style: TextStyle(
                          color: AppColors.whiteColor,
                          fontFamily: AppStyles.semibold,
                          fontSize: 18),
                    ),
                  ),
                );
              } else {
                List<QueryDocumentSnapshot<Object?>> data = snapshot.data!.docs;
                data.sort((a, b) {
                  int lengthA = (a['p_wishlist'] as List).length;
                  int lengthB = (b['p_wishlist'] as List).length;

                  return lengthB.compareTo(lengthA);
                });
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          dashboadButton(
                              title: "Products",
                              count: data.length,
                              icon: "products"),
                          dashboadButton(
                              title: "Orders", count: 15, icon: "orders"),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          dashboadButton(
                              title: "Ratings",
                              count: 75,
                              size: 50.0,
                              isIcon: true,
                              icon: Icons.star_border_rounded),
                          dashboadButton(
                              title: "Total Sales",
                              count: 15,
                              isIcon: true,
                              size: 40.0,
                              icon: Icons.shopping_cart_outlined),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppColors.textfieldGrey,
                            borderRadius: BorderRadius.circular(5)),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Featured Products",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: AppStyles.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                child: Row(
                                  children: List.generate(
                                      data.length,
                                      (index) => data[index]['p_wishlist']
                                                  .length ==
                                              0
                                          ? const SizedBox()
                                          : GestureDetector(
                                              onTap: () => Get.to(
                                                  () => ProductDetails(
                                                      data: data[index]),
                                                  transition:
                                                      Transition.downToUp),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 15),
                                                margin: const EdgeInsets.only(
                                                    right: 10),
                                                width: 150,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7)),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Center(
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7),
                                                        child:
                                                            CachedNetworkImage(
                                                          fit: BoxFit.cover,
                                                          width: 130,
                                                          height: 130,
                                                          imageUrl: data[index]
                                                              ['p_imgs'][0],
                                                          placeholder: (context,
                                                                  url) =>
                                                              const Center(
                                                                  child:
                                                                      CircularProgressIndicator(
                                                            color: AppColors
                                                                .fontGrey,
                                                          )),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Icon(
                                                                  Icons.error),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    Text(
                                                      data[index]["p_name"],
                                                      style: const TextStyle(
                                                          fontFamily: AppStyles
                                                              .semibold,
                                                          fontSize: 16,
                                                          color: AppColors
                                                              .darkFontGrey),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      currencyFormatter.format(
                                                          int.parse(data[index]
                                                              ["p_price"])),
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              AppStyles.bold,
                                                          fontSize: 13,
                                                          color: AppColors
                                                              .redColor),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            }
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.mainColor,
              ),
            );
          },
        ));
  }
}
