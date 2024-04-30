import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_seller/const/colors.dart';
import 'package:ecommerce_app_seller/const/num_curr.dart';
import 'package:ecommerce_app_seller/controllers/products_controller.dart';
import 'package:ecommerce_app_seller/services/firestore_services.dart';
import 'package:ecommerce_app_seller/views/products_screen/add_product.dart';
import 'package:ecommerce_app_seller/views/products_screen/product_details.dart';
import 'package:ecommerce_app_seller/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../widgets/utils.dart';
import '../../const/styles.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await Utils.showExitDialog();
      },
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              Get.to(
                  () => const AddProduct(
                        title: "Add Product",
                      ),
                  transition: Transition.downToUp);
            },
            backgroundColor: AppColors.mainColor,
            child: const Icon(Icons.add),
          ),
          appBar: appBar("Products"),
          body: StreamBuilder(
            stream: FirestoreService.getProducts(),
            builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                  return Padding(
                    padding: const EdgeInsets.all(12),
                    child: AnimationLimiter(
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 10,
                          );
                        },
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 350),
                            child: SlideAnimation(
                              horizontalOffset: 150.0,
                              child: FadeInAnimation(
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(
                                        () => ProductDetails(
                                              data: data[index],
                                            ),
                                        transition: Transition.downToUp);
                                  },
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Slidable(
                                        key: const ValueKey(0),
                                        endActionPane: ActionPane(
                                            motion: const ScrollMotion(),
                                            extentRatio: 0.7,
                                            children: [
                                              SlidableAction(
                                                flex: 2,
                                                onPressed: (context) {
                                                  Get.to(
                                                      () => AddProduct(
                                                            title:
                                                                "Edit product",
                                                          ),
                                                      arguments: data[index]);
                                                },
                                                backgroundColor:
                                                    Colors.blueAccent,
                                                foregroundColor: Colors.white,
                                                icon: Icons.edit,
                                                label: "Edit",
                                              ),
                                              SlidableAction(
                                                flex: 2,
                                                onPressed: (context) {
                                                  Utils.confirmAction(
                                                      onPressed: () async {
                                                    await FirestoreService
                                                        .deleteProduct(
                                                            data[index].id);
                                                    Get.back();
                                                    Utils.showToast(
                                                        "product deleted");
                                                  });
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
                                                        width: 90,
                                                        height: 90,
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
                                                  Expanded(
                                                      child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        data[index]["p_name"],
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontFamily: AppStyles
                                                              .semibold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        data[index]
                                                                ["p_category"] +
                                                            ' ( ${data[index]["p_subcategory"]} )',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontFamily: AppStyles
                                                              .semibold,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        currencyFormatter.format(
                                                            int.parse(data[
                                                                    index]
                                                                ["p_price"])),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontFamily:
                                                                AppStyles
                                                                    .semibold,
                                                            color: AppColors
                                                                .redColor),
                                                      ),
                                                    ],
                                                  )),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8),
                                                    child: const Icon(
                                                      Icons.arrow_back_ios,
                                                      size: 15,
                                                      color: AppColors
                                                          .darkFontGrey,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
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
          )),
    );
  }
}
