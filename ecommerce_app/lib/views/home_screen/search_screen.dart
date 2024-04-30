import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';

import '../../consts/colors.dart';
import '../../consts/num_curr.dart';
import '../../consts/styles.dart';
import '../categories_screen/item_details.dart';

class SearchScreen extends StatelessWidget {
  final String? title;
  const SearchScreen({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        title: Text(
          title!,
          style: TextStyle(
              color: AppColors.darkFontGrey,
              fontSize: 18,
              fontFamily: AppStyles.semibold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: FirestoreService.searchProducts(title),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (snapshot.hasData) {
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/no-product.png",
                        width: 300,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        "No products found",
                        style: TextStyle(
                            color: AppColors.mainColor,
                            fontFamily: AppStyles.semibold,
                            fontSize: 18),
                      ),
                    ],
                  ),
                );
              } else {
                final data = snapshot.data!.docs;
                final filtered = data
                    .where((element) => element['p_name']
                        .toString()
                        .toLowerCase()
                        .contains(title!.toLowerCase()))
                    .toList();
                if (filtered.isEmpty) {
                  return Center(
                      child: Lottie.asset("assets/images/empty.json"));
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      mainAxisExtent: 240,
                      crossAxisSpacing: 8),
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => ItemDetails(data: filtered[index]));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                width: 150,
                                height: 150,
                                imageUrl: filtered[index]['p_imgs'][0],
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                  color: AppColors.fontGrey,
                                )),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              filtered[index]['p_name'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: AppStyles.semibold,
                                  color: AppColors.darkFontGrey),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              currencyFormatter.format(
                                  int.parse(filtered[index]['p_price'])),
                              style: TextStyle(
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
    );
  }
}
