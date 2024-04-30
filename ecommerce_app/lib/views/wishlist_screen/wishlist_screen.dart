import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../consts/colors.dart';
import '../../consts/num_curr.dart';
import '../../consts/styles.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Wishlist",
          style: TextStyle(
              color: Colors.black,
              fontFamily: AppStyles.semibold,
              fontSize: 17),
        ),
      ),
      body: StreamBuilder(
          stream: FirestoreService.getWishlist(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (snapshot.hasData) {
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                    child: Center(
                  child: Lottie.asset("assets/images/empty.json"),
                ));
              } else {
                final data = snapshot.data!.docs;
                return AnimationLimiter(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 500),
                        child: SlideAnimation(
                          horizontalOffset: 100.0,
                          child: FadeInAnimation(
                            child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Slidable(
                                      key: const ValueKey(0),
                                      endActionPane: ActionPane(
                                          motion: const ScrollMotion(),
                                          children: [
                                            SlidableAction(
                                              flex: 1,
                                              onPressed: (context) {
                                                FirestoreService
                                                    .removeFromWishlist(
                                                        data[index].id);
                                              },
                                              backgroundColor: Colors.red,
                                              foregroundColor: Colors.white,
                                              icon: Icons.delete,
                                              label: "Delete",
                                            )
                                          ]),
                                      child: Container(
                                        width: Get.width,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5,
                                                bottom: 5,
                                                left: 5,
                                                right: 5),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5,
                                                          bottom: 5,
                                                          left: 5,
                                                          right: 15),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      width: 100,
                                                      height: 100,
                                                      imageUrl: data[index]
                                                          ['p_imgs'][0],
                                                      placeholder: (context,
                                                              url) =>
                                                          const Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                        color:
                                                            AppColors.fontGrey,
                                                      )),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data[index]['p_name'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      data[index]["p_seller"],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      currencyFormatter.format(
                                                          int.parse(data[index]
                                                              ["p_price"])),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: AppColors
                                                              .redColor),
                                                    ),
                                                  ],
                                                )),
                                                const Icon(
                                                  Icons.arrow_back_ios,
                                                  size: 15,
                                                  color: AppColors.darkFontGrey,
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
                );
              }
            }

            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.mainColor,
              ),
            );
          }),
    );
  }
}
