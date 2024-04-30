import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce_app/consts/colors.dart';
import 'package:ecommerce_app/consts/images.dart';
import 'package:ecommerce_app/consts/lists.dart';
import 'package:ecommerce_app/consts/num_curr.dart';
import 'package:ecommerce_app/consts/styles.dart';
import 'package:ecommerce_app/views/chat_screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/product_controller.dart';
import '../../widgets/utils.dart';

class ItemDetails extends StatelessWidget {
  final dynamic data;
  const ItemDetails({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    controller.checkIsFav(data);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          data["p_name"],
          style: const TextStyle(
              color: AppColors.darkFontGrey,
              fontSize: 17,
              fontFamily: AppStyles.semibold),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
            controller.resetValues();
          },
          icon: const Icon(Icons.arrow_back),
          color: AppColors.darkFontGrey,
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.share,
                color: AppColors.darkFontGrey,
              )),
          Obx(
            () => IconButton(
                onPressed: () {
                  if (controller.isFav.value) {
                    controller.removeFromWishlist(data.id, context);
                  } else {
                    controller.addToWishlist(data.id, context);
                  }
                },
                icon: Icon(
                  controller.isFav.value
                      ? Icons.favorite_sharp
                      : Icons.favorite_outline,
                  color: AppColors.redColor,
                )),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CarouselSlider(
                      options: CarouselOptions(
                        height: 200,
                        autoPlay: true,
                        enlargeCenterPage: true,
                      ),
                      items: List.generate(
                        data["p_imgs"].length,
                        (index) => ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 150,
                            imageUrl: data['p_imgs'][index],
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                              color: AppColors.fontGrey,
                            )),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    data["p_name"],
                    style: const TextStyle(
                        fontFamily: AppStyles.semibold,
                        fontSize: 16,
                        color: AppColors.darkFontGrey),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    currencyFormatter.format(int.parse(data['p_price'])),
                    style: const TextStyle(
                        fontFamily: AppStyles.bold,
                        fontSize: 16,
                        color: AppColors.redColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 228, 228, 228),
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Seller",
                              style: TextStyle(fontFamily: AppStyles.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(data["p_seller"])
                          ],
                        )),
                        InkWell(
                          onTap: () => Get.to(() => const ChatScreen(),
                              arguments: [data["p_seller"], data['vendor_id'], data['vendor_token']]),
                          child: const CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.message_rounded,
                              color: AppColors.mainColor,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4), // Shadow color
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3), // Shadow position
                        ),
                      ],
                    ),
                    child: Obx(
                      () => Column(
                        children: [
                          Row(
                            children: [
                              const SizedBox(
                                width: 100,
                                child: Text(
                                  "Color: ",
                                  style:
                                      TextStyle(color: AppColors.darkFontGrey),
                                ),
                              ),
                              Row(
                                children: List.generate(
                                    data["p_colors"].length,
                                    (index) => Container(
                                          margin:
                                              const EdgeInsets.only(right: 5),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () => controller
                                                    .changeColorIndex(index),
                                                child: CircleAvatar(
                                                  backgroundColor: Color(
                                                      data["p_colors"][index]),
                                                ),
                                              ),
                                              if (index ==
                                                  controller.colorIndex.value)
                                                const Icon(
                                                  Icons.done,
                                                  color: Colors.white,
                                                )
                                            ],
                                          ),
                                        )),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 100,
                                child: Text(
                                  "Quantity: ",
                                  style:
                                      TextStyle(color: AppColors.darkFontGrey),
                                ),
                              ),
                              Row(children: [
                                IconButton(
                                    onPressed: () =>
                                        controller.decreaseQuantity(
                                            int.parse(data['p_price'])),
                                    icon: const Icon(Icons.remove)),
                                Text(
                                  controller.quantity.toString(),
                                  style: const TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                                IconButton(
                                    onPressed: () =>
                                        controller.increaseQuantity(
                                            int.parse(data['p_quantity']),
                                            int.parse(data['p_price'])),
                                    icon: const Icon(Icons.add)),
                                Text(
                                  "(${data["p_quantity"]} available)",
                                  style: const TextStyle(
                                      color: AppColors.textfieldGrey),
                                )
                              ]),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 100,
                                child: Text(
                                  "Total: ",
                                  style:
                                      TextStyle(color: AppColors.darkFontGrey),
                                ),
                              ),
                              Text(
                                currencyFormatter
                                    .format(controller.totalPrice.value),
                                style: const TextStyle(
                                    color: AppColors.redColor,
                                    fontSize: 16,
                                    fontFamily: AppStyles.bold),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // Description Section

                  const Text(
                    "Description",
                    style:
                        TextStyle(fontFamily: AppStyles.semibold, fontSize: 17),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    data["p_desc"],
                    style: const TextStyle(
                        fontSize: 15, color: AppColors.darkFontGrey),
                  ),

                  // Buttons Section
                  const SizedBox(
                    height: 20,
                  ),
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: List.generate(
                        itemDetailsButtonsList.length,
                        (index) => ListTile(
                              title: Text(
                                itemDetailsButtonsList[index],
                                style: const TextStyle(
                                    fontFamily: AppStyles.semibold,
                                    color: AppColors.darkFontGrey),
                              ),
                              trailing: const Icon(Icons.arrow_forward),
                            )),
                  ),
                ],
              ),
            ),
          )),
          Obx(
            () => GestureDetector(
              onTap: () async {
                if (!controller.isLoading.value) {
                  if (controller.quantity.value > 0) {
                    await controller.addToCart(
                        context: context,
                        title: data['p_name'],
                        img: data['p_imgs'][0],
                        sellerName: data['p_seller'],
                        color: data["p_colors"][controller.colorIndex.value],
                        quantity: controller.quantity.value,
                        vendorId: data['vendor_id'],
                        itemPrice: data["p_price"],
                        vendorToken: data['vendor_token']);

                    controller.resetValues();
                  } else {
                    Utils.showToast("increase the quantity");
                  }
                }
              },
              child: Container(
                width: double.infinity,
                height: 60,
                color: AppColors.mainColor,
                child: Center(
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Add to cart",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
