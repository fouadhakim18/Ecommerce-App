import 'package:ecommerce_app/consts/colors.dart';
import 'package:ecommerce_app/consts/lists.dart';
import 'package:ecommerce_app/consts/styles.dart';
import 'package:ecommerce_app/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import '../../widgets/utils.dart';
import 'category_details.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    return WillPopScope(
      onWillPop: () async {
        return await Utils.showExitDialog();
      },
      child: SafeArea(
          child: Scaffold(
              backgroundColor: AppColors.lightGrey,
              // extendBodyBehindAppBar: true,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: const Center(
                  child: Text(
                    "Categories",
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: AppStyles.semibold,
                        color: AppColors.darkFontGrey),
                  ),
                ),
              ),
              body: Container(
                height: Get.height,
                padding: const EdgeInsets.all(12),
                child: AnimationLimiter(
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: categoriesList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            mainAxisExtent: 190),
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        columnCount: 3,
                        duration: const Duration(milliseconds: 400),
                        child: SlideAnimation(
                          verticalOffset: 70.0,
                          child: FadeInAnimation(
                            child: InkWell(
                              onTap: () {
                                controller
                                    .getSubCategories(categoriesList[index]);
                                Get.to(
                                    () => CategoryDetails(
                                          title: categoriesList[index],
                                        ),
                                    arguments: categoriesList[index],
                                    transition: Transition.fadeIn);
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 7),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(7)),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      categoriesImages[index],
                                      height: 130,
                                      width: 200,
                                      fit: BoxFit.contain,
                                    ),
                                    Text(
                                      categoriesList[index],
                                      style: const TextStyle(
                                          fontSize: 12,
                                          height: 1.3,
                                          fontFamily: AppStyles.semibold),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ))),
    );
  }
}
