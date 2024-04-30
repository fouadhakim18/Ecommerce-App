import 'package:ecommerce_app/consts/colors.dart';
import 'package:ecommerce_app/consts/styles.dart';
import 'package:ecommerce_app/controllers/home_controller.dart';
import 'package:ecommerce_app/views/categories_screen/categories_screen.dart';
import 'package:ecommerce_app/views/home_screen/home.dart';
import 'package:ecommerce_app/views/orders_screen/orders_screen.dart';
import 'package:ecommerce_app/widgets/bottom_button.dart';
import 'package:ecommerce_app/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class OrderConfirmed extends StatelessWidget {
  const OrderConfirmed({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: bottomButton(
            onTap: () {
              controller.currentNavIndex.value = 1;
              Get.to(() => Home());
            },
            title: "Continue Shopping"),
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(
                Icons.home_rounded,
                size: 30,
                color: AppColors.mainColor,
              ),
              onPressed: () {
                controller.currentNavIndex.value = 0;
                Get.to(() => Home());
              },
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            Lottie.asset("assets/images/confirmed.json", width: 200),
            SizedBox(
              height: 20,
            ),
            Text(
              "Order Confirmed!",
              style: TextStyle(fontFamily: AppStyles.bold, fontSize: 23),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Your order has been confirmed, we will send you confirmation notification shortly.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.fontGrey),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Button(
                text: "Go to orders",
                clicked: () {
                  Get.to(() => OrdersScreen());
                },
                color: AppColors.lightGrey,
                textColor: AppColors.lightGrey3,
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
