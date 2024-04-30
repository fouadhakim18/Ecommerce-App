import 'package:ecommerce_app/consts/colors.dart';
import 'package:ecommerce_app/consts/images.dart';
import 'package:ecommerce_app/controllers/home_controller.dart';
import 'package:ecommerce_app/views/cart_screen/cart_screen.dart';
import 'package:ecommerce_app/views/categories_screen/categories_screen.dart';
import 'package:ecommerce_app/views/profile_screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_screen.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeController());
    final navBarItems = [
      BottomNavigationBarItem(
          icon: Image.asset(
            icHome,
            width: 26,
          ),
          label: "Home"),
      BottomNavigationBarItem(
          icon: Image.asset(
            icCategories,
            width: 26,
          ),
          label: "Categories"),
      BottomNavigationBarItem(
          icon: Image.asset(
            icCart,
            width: 26,
          ),
          label: "Cart"),
      BottomNavigationBarItem(
          icon: Image.asset(
            icProfile,
            width: 26,
          ),
          label: "Profile"),
    ];
    final navBody = [
      const HomeScreen(),
      const CategoriesScreen(),
      const CartScreen(),
      const ProfileScreen()
    ];
    return Scaffold(
      body: Obx(() => navBody[homeController.currentNavIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: homeController.currentNavIndex.value,
          selectedItemColor: AppColors.mainColor,
          // selectedLabelStylconst e: TextStyle(fontWeight: FontWeight.bold),
          items: [
            BottomNavigationBarItem(
                icon: Image.asset(
                  icHome,
                  width: 26,
                  color: homeController.currentNavIndex == 0
                      ? AppColors.mainColor
                      : AppColors.lightGrey3,
                ),
                label: "Home"),
            BottomNavigationBarItem(
                icon: Image.asset(
                  icCategories,
                  width: 26,
                  color: homeController.currentNavIndex == 1
                      ? AppColors.mainColor
                      : AppColors.lightGrey3,
                ),
                label: "Categories"),
            BottomNavigationBarItem(
                icon: Image.asset(
                  icCart,
                  width: 26,
                  color: homeController.currentNavIndex == 2
                      ? AppColors.mainColor
                      : AppColors.lightGrey3,
                ),
                label: "Cart"),
            BottomNavigationBarItem(
                icon: Image.asset(
                  icProfile,
                  width: 26,
                  color: homeController.currentNavIndex == 3
                      ? AppColors.mainColor
                      : AppColors.lightGrey3,
                ),
                label: "Profile"),
          ],
          type: BottomNavigationBarType.fixed,
          onTap: (value) => homeController.currentNavIndex.value = value,
        ),
      ),
    );
  }
}
