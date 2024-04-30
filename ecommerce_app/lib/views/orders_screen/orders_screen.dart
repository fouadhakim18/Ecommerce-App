import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/num_curr.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:ecommerce_app/views/orders_screen/orders_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart' as intl;

import '../../consts/colors.dart';
import '../../consts/styles.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Orders",
          style: TextStyle(
              color: Colors.black,
              fontFamily: AppStyles.semibold,
              fontSize: 17),
        ),
      ),
      body: StreamBuilder(
          stream: FirestoreService.getAllOrders(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (snapshot.hasData) {
              if (snapshot.data!.docs.isEmpty) {
                return Center(child: Lottie.asset("assets/images/empty.json"));
              } else {
                final data = snapshot.data!.docs;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AnimationLimiter(
                    child: ListView.separated(
                      itemCount: data.length,
                      physics: BouncingScrollPhysics(),
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      itemBuilder: (context, index) {
                        final time = data[index]['order_date'] == null
                            ? DateTime.now()
                            : data[index]['order_date'].toDate();
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 500),
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
                                      borderRadius: BorderRadius.circular(12)),
                                  child: ListTile(
                                    onTap: () {
                                      Get.to(() =>
                                          OrdersDetails(data: data[index]));
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
                                                  color: AppColors.whiteColor,
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
                                                  data[index]['total_amount']),
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
