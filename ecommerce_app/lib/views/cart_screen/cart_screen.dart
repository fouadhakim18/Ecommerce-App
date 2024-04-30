import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/firebase_consts.dart';
import 'package:ecommerce_app/consts/num_curr.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:ecommerce_app/views/cart_screen/shipping_details.dart';
import 'package:ecommerce_app/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletons/skeletons.dart';

import '../../consts/colors.dart';
import '../../consts/styles.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/home_controller.dart';
import '../../services/firebase_notifications.dart';
import '../../widgets/bottom_button.dart';
import '../../widgets/utils.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CartController());
    return WillPopScope(
      onWillPop: () async {
        return await Utils.showExitDialog();
      },
      child: SafeArea(
        child: Scaffold(
          bottomNavigationBar: bottomButton(
              onTap: () {
                if (controller.productSnapshot != null) {
                  Get.to(
                    () => const ShippingDetails(),
                  );
                } else {
                  Utils.showToast("empty cart");
                }
              },
              title: "Proceed to checkout"),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Center(
              child: const Text(
                "Shopping cart",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: AppStyles.semibold,
                    fontSize: 17),
              ),
            ),
          ),
          body: StreamBuilder(
              stream: FirestoreService.getCart(currentUser!.uid),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else if (snapshot.hasData) {
                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Lottie.asset("assets/images/empty.json"),
                    );
                  } else {
                    final data = snapshot.data!.docs;
                    controller.calculatePrice(data);
                    controller.productSnapshot = data;
                    return Column(
                      children: [
                        Expanded(
                          child: AnimationLimiter(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 400),
                                  child: SlideAnimation(
                                    horizontalOffset: 100.0,
                                    child: FadeInAnimation(
                                      child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Slidable(
                                                key: const ValueKey(0),
                                                endActionPane: ActionPane(
                                                    motion:
                                                        const ScrollMotion(),
                                                    children: [
                                                      SlidableAction(
                                                        flex: 1,
                                                        onPressed:
                                                            (context) async {
                                                          await FirestoreService
                                                              .deleteDoc(
                                                                  data[index]
                                                                      .id);

                                                          Utils.showToast(
                                                              "Item deleted");
                                                        },
                                                        backgroundColor:
                                                            Colors.red,
                                                        foregroundColor:
                                                            Colors.white,
                                                        icon: Icons.delete,
                                                        label: "Delete",
                                                      )
                                                    ]),
                                                child: Container(
                                                  width: Get.width,
                                                  child: Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                    color: Colors.white,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5,
                                                              bottom: 5,
                                                              left: 5,
                                                              right: 5),
                                                      child: Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5,
                                                                    bottom: 5,
                                                                    left: 5,
                                                                    right: 15),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              child:
                                                                  CachedNetworkImage(
                                                                fit: BoxFit
                                                                    .cover,
                                                                width: 100,
                                                                height: 100,
                                                                imageUrl:
                                                                    data[index]
                                                                        ['img'],
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
                                                                    const Icon(Icons
                                                                        .error),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                              child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                data[index]
                                                                    ['title'],
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                currencyFormatter
                                                                    .format(data[
                                                                            index]
                                                                        [
                                                                        "total_price"]),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 15,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                data[index][
                                                                    "seller_name"],
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  CircleAvatar(
                                                                    radius: 15,
                                                                    backgroundColor:
                                                                        const Color(
                                                                            0xfff5f5f5),
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        if (data[index]["quantity"] >
                                                                            1) {
                                                                          controller.updateQuantity(
                                                                              context: context,
                                                                              docId: data[index].id,
                                                                              qty: data[index]["quantity"] - 1,
                                                                              itemPrice: data[index]['item_price']);
                                                                          controller
                                                                              .calculatePrice(data);
                                                                        }
                                                                      },
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .keyboard_arrow_down,
                                                                        color: Colors
                                                                            .black,
                                                                        size:
                                                                            25,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        vertical:
                                                                            7),
                                                                    child: Text(data[index]
                                                                            [
                                                                            "quantity"]
                                                                        .toString()),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  CircleAvatar(
                                                                    radius: 15,
                                                                    backgroundColor:
                                                                        const Color(
                                                                            0xfff5f5f5),
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        controller.updateQuantity(
                                                                            context:
                                                                                context,
                                                                            docId: data[index]
                                                                                .id,
                                                                            qty: data[index]["quantity"] +
                                                                                1,
                                                                            itemPrice:
                                                                                data[index]['item_price']);
                                                                        controller
                                                                            .calculatePrice(data);
                                                                      },
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .keyboard_arrow_up,
                                                                        color: Colors
                                                                            .black,
                                                                        size:
                                                                            25,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          )),
                                                          const Icon(
                                                            Icons
                                                                .arrow_back_ios,
                                                            size: 15,
                                                            color: AppColors
                                                                .darkFontGrey,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ))),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 10),
                          width: double.infinity,
                          color: AppColors.mainColor.withOpacity(0.2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total: ",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 17),
                              ),
                              Obx(() => Text(
                                    currencyFormatter
                                        .format(controller.totalPrice.value),
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 17),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                }
                // return SkeletonListView();
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.mainColor,
                  ),
                );
              }),
        ),
      ),
    );
  }
}
