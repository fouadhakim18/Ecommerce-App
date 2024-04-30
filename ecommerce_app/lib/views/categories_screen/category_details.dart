import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/controllers/cat_details_controller.dart';
import 'package:ecommerce_app/controllers/product_controller.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:ecommerce_app/views/categories_screen/item_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../consts/colors.dart';
import '../../consts/num_curr.dart';
import '../../consts/styles.dart';

class CategoryDetails extends StatelessWidget {
  final String title;
  const CategoryDetails({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();
    final controller2 = Get.put(CatDetailsController());
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.lightGrey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          title,
          style: const TextStyle(
              fontSize: 18,
              fontFamily: AppStyles.semibold,
              color: AppColors.darkFontGrey),
        ),
        // iconTheme: IconThemeData(color: AppColors.whiteColor),
      ),
      body: Container(
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //         image: const AssetImage("assets/icons/wp2252568.jpg"),
        //         fit: BoxFit.cover,
        //         alignment: Alignment.topCenter,
        //         colorFilter: ColorFilter.mode(
        //             AppColors.mainColor.withOpacity(0.15), BlendMode.dstATop))),
        padding:
            const EdgeInsets.only(top: 60, bottom: 12, left: 12, right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                    controller.subCat.length,
                    (index) => Obx(
                          () => GestureDetector(
                            onTap: () {
                              controller2
                                  .switchCategory(controller.subCat[index]);

                              controller2.subCatIndex.value = index;
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              margin:
                                  const EdgeInsets.only(right: 4, bottom: 10),
                              decoration: BoxDecoration(
                                  color: controller2.subCatIndex.value == index
                                      ? AppColors.mainColor
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: controller2.subCatIndex.value == index
                                      ? Border.all(
                                          color: AppColors.whiteColor, width: 1)
                                      : null),
                              child: Text(
                                controller.subCat[index],
                                style: TextStyle(
                                    color:
                                        controller2.subCatIndex.value == index
                                            ? Colors.white
                                            : Colors.black),
                              ),
                            ),
                          ),
                        )),
              ),
            ),
            Expanded(
              child: Obx(
                () => StreamBuilder(
                  stream: controller2.productMethod!.value,
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
                        return GridView.builder(
                          padding: const EdgeInsets.only(top: 20),
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  mainAxisExtent: 230),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Get.to(
                                    () => ItemDetails(
                                          data: data[index],
                                        ),
                                    transition: Transition.downToUp);
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 7),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(7)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Center(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              width: 150,
                                              height: 150,
                                              imageUrl: data[index]['p_imgs']
                                                  [0],
                                              placeholder: (context, url) =>
                                                  const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                color: AppColors.fontGrey,
                                              )),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      data[index]['p_name'],
                                      style: const TextStyle(
                                          fontSize: 13,
                                          overflow: TextOverflow.ellipsis,
                                          color: AppColors.darkFontGrey),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      currencyFormatter.format(
                                          int.parse(data[index]['p_price'])),
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: AppColors.redColor,
                                          fontFamily: AppStyles.semibold),
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
                        color: AppColors.whiteColor,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
