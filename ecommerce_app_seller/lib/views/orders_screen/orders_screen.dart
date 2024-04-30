import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_seller/const/colors.dart';
import 'package:ecommerce_app_seller/const/num_curr.dart';
import 'package:ecommerce_app_seller/services/firestore_services.dart';
import 'package:ecommerce_app_seller/views/orders_screen/ordered_products.dart';
import 'package:ecommerce_app_seller/views/orders_screen/orders_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';

import '../../const/styles.dart';
import 'package:intl/intl.dart' as intl;

import '../../widgets/app_bar.dart';
import '../../widgets/utils.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await Utils.showExitDialog();
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: appBar("Orders"),
          body: StreamBuilder(
            stream: FirestoreService.getOrders(),
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
                          physics: const BouncingScrollPhysics(),
                          itemCount: data.length,
                          separatorBuilder: (context, index) {
                            return const Divider(
                              color: AppColors.darkFontGrey,
                            );
                          },
                          itemBuilder: (context, index) {
                            final time = data[index]['order_date'] == null
                                ? DateTime.now()
                                : data[index]['order_date'].toDate();
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 400),
                              child: SlideAnimation(
                                horizontalOffset: 150.0,
                                child: FadeInAnimation(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        image: const AssetImage(
                                            "assets/images/orders.png"),
                                        fit: BoxFit.cover,
                                        alignment: Alignment.topCenter,
                                      ),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.65),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: ListTile(
                                        onTap: () {
                                          Get.to(() => OrderedProducts(
                                              data: data[index]));
                                        },
                                        leading: Text(
                                          '${index + 1}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        title: Text(
                                          data[index]['order_code'],
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.calendar_month,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  intl.DateFormat()
                                                      .add_yMd()
                                                      .format(time),
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: const [
                                                Icon(
                                                  Icons.payment,
                                                  size: 18,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Unpaid",
                                                  style: TextStyle(
                                                      color:
                                                          AppColors.whiteColor,
                                                      fontSize: 13),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.price_change_outlined,
                                                  color: Color.fromARGB(
                                                      255, 255, 0, 0),
                                                  size: 18,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  currencyFormatter.format(
                                                      data[index]
                                                          ['total_amount']),
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 255, 0, 0),
                                                      fontSize: 13,
                                                      fontFamily:
                                                          AppStyles.semibold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ));
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
