import 'package:ecommerce_app_seller/const/colors.dart';
import 'package:ecommerce_app_seller/const/styles.dart';
import 'package:ecommerce_app_seller/controllers/home_controller.dart';
import 'package:ecommerce_app_seller/views/chat_screen/messaging_screen.dart';
import 'package:ecommerce_app_seller/views/home_screen/home_screen.dart';
import 'package:ecommerce_app_seller/views/orders_screen/orders_screen.dart';
import 'package:ecommerce_app_seller/views/products_screen/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../profile_screen/profile_screen.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    final navScreens = [
      // const HomeScreen(),
      const ProductScreen(),
      const OrderScreen(),
      const MessagingScreen(),
      const ProfileScreen()
    ];

    return Obx(
      () => Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            onTap: (value) {
              controller.navIndex.value = value;
            },
            currentIndex: controller.navIndex.value,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.mainColor,
            items: [
              // const BottomNavigationBarItem(
              // icon: Icon(
              //   Icons.dashboard_outlined,
              //   size: 28,
              // ),
              // label: "Dashboard"),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/icons/products.png",
                    color: controller.navIndex == 0
                        ? AppColors.mainColor
                        : AppColors.darkGrey,
                    width: 24,
                  ),
                  label: "Products"),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/icons/orders.png",
                    color: controller.navIndex == 1
                        ? AppColors.mainColor
                        : AppColors.darkGrey,
                    width: 24,
                  ),
                  label: "Orders"),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.message_outlined), label: "Messages"),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/icons/general_setting.png",
                  color: controller.navIndex == 3
                      ? AppColors.mainColor
                      : AppColors.darkGrey,
                  width: 24,
                ),
                label: "Settings",
              ),
            ]),
        body: Column(
          children: [
            Expanded(child: navScreens.elementAt(controller.navIndex.value))
          ],
        ),
      ),
    );
  }
}
