import 'package:ecommerce_app/consts/lists.dart';
import 'package:ecommerce_app/controllers/cart_controller.dart';
import 'package:ecommerce_app/controllers/home_controller.dart';
import 'package:ecommerce_app/views/home_screen/home.dart';
import 'package:ecommerce_app/views/home_screen/home_screen.dart';
import 'package:ecommerce_app/widgets/bottom_button.dart';
import 'package:ecommerce_app/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../../consts/colors.dart';
import '../../consts/styles.dart';
import '../../widgets/utils.dart';
import 'order_confirmed.dart';

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Payment Methods",
          style: TextStyle(
              color: Colors.black,
              fontFamily: AppStyles.semibold,
              fontSize: 17),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back),
          color: AppColors.darkFontGrey,
        ),
      ),
      bottomNavigationBar: Obx(() {
        return controller.placingOrder.value
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.mainColor,
                ),
              )
            : bottomButton(
                onTap: () async {
                  await controller.placeMyOrder(
                      orderPaymentMethod:
                          paymentMethods[controller.paymentIndex.value],
                      totalAmount: controller.totalPrice.value);

                  Get.to(() => const OrderConfirmed());
                  await controller.clearCart();
                },
                title: 'Place My Order');
      }),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(
                paymentMethodsImg.length,
                (index) => Obx(
                      () => Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            if (index == controller.paymentIndex.value)
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.4), // Shadow color
                                spreadRadius: 3, // Spread radius
                                blurRadius: 10, // Blur radius
                                offset: const Offset(0, 3), // Shadow offset
                              ),
                          ],
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () => controller.changePaymentIndex(index),
                          child: Stack(
                            // alignment: Alignment.topRight,
                            children: [
                              Image.asset(
                                paymentMethodsImg[index],
                                colorBlendMode:
                                    index == controller.paymentIndex.value
                                        ? BlendMode.darken
                                        : BlendMode.color,
                                color: index == controller.paymentIndex.value
                                    ? Colors.black.withOpacity(0.4)
                                    : Colors.transparent,
                              ),
                              index == controller.paymentIndex.value
                                  ? Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Transform.scale(
                                        scale: 1.3,
                                        child: Checkbox(
                                          activeColor: Colors.green,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          value: index ==
                                              controller.paymentIndex.value,
                                          onChanged: (value) {},
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AnimatedOpacity(
                                    opacity:
                                        controller.paymentIndex.value == index
                                            ? 1.0
                                            : 0.0,
                                    duration: const Duration(milliseconds: 300),
                                    child: Text(
                                      paymentMethods[index],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
          ),
        ),
      ),
    );
  }
}
