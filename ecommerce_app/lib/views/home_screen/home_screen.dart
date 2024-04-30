import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/images.dart';
import 'package:ecommerce_app/consts/lists.dart';
import 'package:ecommerce_app/consts/num_curr.dart';
import 'package:ecommerce_app/controllers/home_controller.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:ecommerce_app/views/categories_screen/item_details.dart';
import 'package:ecommerce_app/views/home_screen/search_screen.dart';
import 'package:ecommerce_app/widgets/feautured_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../consts/colors.dart';
import '../../consts/styles.dart';
import '../../widgets/home_buttons.dart';
import '../../widgets/utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return WillPopScope(
      onWillPop: () async {
        return await Utils.showExitDialog();
      },
      child: Scaffold(
        backgroundColor: AppColors.lightGrey,
        body: SafeArea(
            child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: 60,
                color: AppColors.lightGrey,
                child: TextFormField(
                  controller: controller.searchController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    suffixIcon: InkWell(
                        onTap: () {
                          Get.to(
                              () => SearchScreen(
                                    title: controller.searchController.text,
                                  ),
                              transition: Transition.cupertinoDialog);
                        },
                        child: Icon(Icons.search)),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Search anything ..",
                    suffixIconColor: AppColors.mainColor,
                    hintStyle:
                        TextStyle(color: AppColors.textfieldGrey, fontSize: 13),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: AnimationLimiter(
                    child: Column(
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 400),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          horizontalOffset: 100.0,
                          child: FadeInAnimation(
                            child: widget,
                          ),
                        ),
                        children: [
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 170,
                              autoPlay: true,
                              enlargeCenterPage: true,
                            ),
                            items: slidersList.map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(7),
                                        child: Image.asset(
                                          i,
                                          fit: BoxFit.fill,
                                        ),
                                      ));
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              homeButtons(
                                  width: Get.width / 2.7,
                                  height: Get.height * 0.13,
                                  icon: icTodaysDeal,
                                  title: "Today's Deal",
                                  onPress: () {}),
                              homeButtons(
                                  width: Get.width / 2.7,
                                  height: Get.height * 0.13,
                                  icon: icFlashDeal,
                                  title: "Flash Scale",
                                  onPress: () {}),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 170,
                              autoPlay: true,
                              enlargeCenterPage: true,
                            ),
                            items: secondSlidersList.map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(7),
                                        child: Image.asset(
                                          i,
                                          fit: BoxFit.fill,
                                        ),
                                      ));
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              homeButtons(
                                  width: Get.width / 3.5,
                                  height: Get.height * 0.12,
                                  icon: icTopCategories,
                                  title: "Top Categories",
                                  onPress: () {}),
                              homeButtons(
                                  width: Get.width / 3.5,
                                  height: Get.height * 0.12,
                                  icon: icBrands,
                                  title: "Brand",
                                  onPress: () {}),
                              homeButtons(
                                  width: Get.width / 3.5,
                                  height: Get.height * 0.12,
                                  icon: icTopSeller,
                                  title: "Top Sellers",
                                  onPress: () {}),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),

                          // Featured Categories

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Featured Categories",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkFontGrey),
                              ),
                              InkWell(
                                onTap: () {
                                  controller.currentNavIndex.value = 1;
                                },
                                child: Text(
                                  "See all",
                                  style: TextStyle(
                                      color: AppColors.mainColor,
                                      fontFamily: AppStyles.semibold),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            child: Row(
                              children: List.generate(
                                  3,
                                  (index) => Container(
                                        margin: const EdgeInsets.only(right: 6),
                                        child: Column(
                                          children: [
                                            featuredItem(
                                                img: featuredImages1[index],
                                                title: featuredTitles1[index]),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            featuredItem(
                                                img: featuredImages2[index],
                                                title: featuredTitles2[index])
                                          ],
                                        ),
                                      )).toList(),
                            ),
                          ),

                          // Features Products

                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: AppColors.mainColor,
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
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                StreamBuilder(
                                    stream: FirestoreService.getAllProducts(),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasError) {
                                        return Center(
                                          child:
                                              Text(snapshot.error.toString()),
                                        );
                                      } else if (snapshot.hasData) {
                                        if (snapshot.data!.docs.isEmpty) {
                                          return Center(
                                              child: Lottie.asset(
                                                  "assets/images/empty_yellow.json"));
                                        } else {
                                          final products = snapshot.data!.docs;
                                          products.sort((a, b) {
                                            List<dynamic> wishlistA =
                                                a['p_wishlist'];
                                            List<dynamic> wishlistB =
                                                b['p_wishlist'];
                                            return wishlistB.length
                                                .compareTo(wishlistA.length);
                                          });
                                          return SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            physics: BouncingScrollPhysics(),
                                            child: Row(
                                              children: List.generate(
                                                  products.length,
                                                  (index) => GestureDetector(
                                                        onTap: () {
                                                          Get.to(
                                                              () => ItemDetails(
                                                                  data: products[
                                                                      index]),
                                                              transition:
                                                                  Transition
                                                                      .downToUp);
                                                        },
                                                        child: Container(
                                                          width: 170,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 10),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Center(
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              7),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    width: 150,
                                                                    height: 150,
                                                                    imageUrl: products[
                                                                            index]
                                                                        [
                                                                        'p_imgs'][0],
                                                                    placeholder: (context,
                                                                            url) =>
                                                                        const Center(
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                      color: AppColors
                                                                          .fontGrey,
                                                                    )),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        const Icon(
                                                                            Icons.error),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                products[index]
                                                                    ['p_name'],
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: AppColors
                                                                        .darkFontGrey),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                currencyFormatter
                                                                    .format(int.parse(
                                                                        products[index]
                                                                            [
                                                                            'p_price'])),
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        AppStyles
                                                                            .semibold,
                                                                    fontSize:
                                                                        13,
                                                                    color: AppColors
                                                                        .redColor),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      )),
                                            ),
                                          );
                                        }
                                      }
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.mainColor,
                                        ),
                                      );
                                    })
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 170,
                              autoPlay: true,
                              enlargeCenterPage: true,
                            ),
                            items: secondSlidersList.map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(7),
                                        child: Image.asset(
                                          i,
                                          fit: BoxFit.fill,
                                        ),
                                      ));
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(
                            height: 15,
                          ),

                          // All product
                          const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "All Products",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkFontGrey),
                              )),
                          const SizedBox(
                            height: 15,
                          ),

                          StreamBuilder(
                              stream: FirestoreService.getAllProducts(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text(snapshot.error.toString()),
                                  );
                                } else if (snapshot.hasData) {
                                  if (snapshot.data!.docs.isEmpty) {
                                    return Center(
                                        child: Lottie.asset(
                                            "assets/images/empty.json"));
                                  } else {
                                    final products = snapshot.data!.docs;
                                    return GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: products.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              mainAxisSpacing: 8,
                                              mainAxisExtent: 230,
                                              crossAxisSpacing: 8),
                                      itemBuilder: (_, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            Get.to(
                                                () => ItemDetails(
                                                    data: products[index]),
                                                transition:
                                                    Transition.downToUp);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                  child: CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    width: 150,
                                                    height: 150,
                                                    imageUrl: products[index]
                                                        ['p_imgs'][0],
                                                    placeholder: (context,
                                                            url) =>
                                                        const Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                      color: AppColors.fontGrey,
                                                    )),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  products[index]['p_name'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily:
                                                          AppStyles.semibold,
                                                      color: AppColors
                                                          .darkFontGrey),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  currencyFormatter.format(
                                                      int.parse(products[index]
                                                          ['p_price'])),
                                                  style: TextStyle(
                                                      fontFamily:
                                                          AppStyles.semibold,
                                                      fontSize: 13,
                                                      color:
                                                          AppColors.redColor),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                }
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.mainColor,
                                  ),
                                );
                              })
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
