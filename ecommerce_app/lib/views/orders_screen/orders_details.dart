import 'package:another_stepper/another_stepper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/consts/colors.dart';
import 'package:ecommerce_app/views/orders_screen/order_place_details.dart';
import 'package:ecommerce_app/views/orders_screen/product_status.dart';
import 'package:ecommerce_app/widgets/bottom_button.dart';
import 'package:ecommerce_app/widgets/stepper_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import '../../consts/num_curr.dart';
import '../../consts/styles.dart';

class OrdersDetails extends StatelessWidget {
  final dynamic data;
  const OrdersDetails({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomButton(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              useSafeArea: true,
              isDismissible: true,
              builder: (BuildContext context) {
                return DraggableScrollableSheet(
                  initialChildSize: 0.5, // Initial collapsed size
                  minChildSize: 0.5,
                  maxChildSize: 1.0,
                  builder: (context, scrollController) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: ListView(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        controller: scrollController,
                        children: orderPlaceDetails(data),
                      ),
                    );
                  },
                );
              },
            );
          },
          title: "View Details"),
      appBar: AppBar(
          title: const Text(
        "Order Details",
        style: TextStyle(
            color: Colors.black, fontFamily: AppStyles.semibold, fontSize: 17),
      )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: AnimationLimiter(
          child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: data['orders'].length,
              itemBuilder: (context, index) =>
                  AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      horizontalOffset: 200.0,
                      child: FadeInAnimation(
                        child: InkWell(
                          onTap: () {
                            Get.to(() => ProductStatus(
                                  data: data['orders'][index],
                                ));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 5, bottom: 5, left: 5, right: 5),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5, left: 5, right: 15),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        width: 95,
                                        height: 95,
                                        imageUrl: data['orders'][index]['img'],
                                        placeholder: (context, url) =>
                                            const Center(
                                                child:
                                                    CircularProgressIndicator(
                                          color: AppColors.fontGrey,
                                        )),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${data['orders'][index]['title']} (x${data['orders'][index]["quantity"]})',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontFamily: AppStyles.semibold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          Text("Color :  "),
                                          CircleAvatar(
                                              radius: 13,
                                              backgroundColor: Color(
                                                  data['orders'][index]
                                                      ["color"])),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        currencyFormatter.format(int.parse(
                                            data['orders'][index]["total_price"]
                                                .toString())),
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: AppColors.redColor),
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
        ),
      ),
    );
  }
}
