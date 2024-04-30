import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../const/colors.dart';
import '../../const/num_curr.dart';
import '../../const/styles.dart';
import '../../widgets/utils.dart';

class ProductDetails extends StatelessWidget {
  final dynamic data;
  const ProductDetails({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(ProductController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          data['p_name'],
          style: TextStyle(
              color: AppColors.darkFontGrey,
              fontSize: 18,
              fontFamily: AppStyles.semibold),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back),
          color: AppColors.darkFontGrey,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselSlider(
                  options: CarouselOptions(
                    height: 250,
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                  items: List.generate(
                    data['p_imgs'].length,
                    (index) => ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        width: double.infinity,
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
                height: 30,
              ),
              Text(
                data['p_name'],
                style: TextStyle(
                    fontFamily: AppStyles.semibold,
                    fontSize: 16,
                    color: AppColors.darkFontGrey),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Text(
                    data['p_category'],
                    style:
                        TextStyle(fontFamily: AppStyles.semibold, fontSize: 16),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("( ${data['p_subcategory']} )")
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                currencyFormatter.format(int.parse(data['p_price'])),
                style: const TextStyle(
                    fontFamily: AppStyles.bold,
                    fontSize: 16,
                    color: AppColors.redColor),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 100,
                          child: Text(
                            "Color: ",
                            style: TextStyle(
                                color: AppColors.darkFontGrey,
                                fontFamily: AppStyles.semibold),
                          ),
                        ),
                        Row(
                          children: List.generate(
                              data['p_colors'].length,
                              (index) => Container(
                                    margin: const EdgeInsets.only(right: 5),
                                    child: CircleAvatar(
                                      backgroundColor:
                                          Color(data["p_colors"][index]),
                                    ),
                                  )),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            "Quantity: ",
                            style: TextStyle(
                                color: AppColors.darkFontGrey,
                                fontFamily: AppStyles.semibold),
                          ),
                        ),
                        Text(
                          "${data["p_quantity"]} items",
                          // controller.quantity.toString(),
                          style: TextStyle(
                              fontSize: 15, color: AppColors.fontGrey),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            "Wishlist: ",
                            style: TextStyle(
                                color: AppColors.darkFontGrey,
                                fontFamily: AppStyles.semibold),
                          ),
                        ),
                        Text(
                          "${data["p_wishlist"].length} persons",
                          // controller.quantity.toString(),
                          style: TextStyle(
                              fontSize: 15, color: AppColors.fontGrey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              // Description Section
              const Text(
                "Description",
                style: TextStyle(fontFamily: AppStyles.semibold, fontSize: 17),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                data['p_desc'],
                style: TextStyle(fontSize: 15, color: AppColors.darkFontGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
