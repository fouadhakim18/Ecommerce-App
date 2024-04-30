import 'package:ecommerce_app/controllers/cart_controller.dart';
import 'package:ecommerce_app/views/cart_screen/payment_method.dart';
import 'package:ecommerce_app/widgets/bottom_button.dart';
import 'package:ecommerce_app/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

import '../../consts/colors.dart';
import '../../consts/styles.dart';

class ShippingDetails extends StatelessWidget {
  const ShippingDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Shipping Info",
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
      bottomNavigationBar: bottomButton(
          onTap: () {
            if (controller.formKey.currentState!.validate()) {
              Get.to(() => const PaymentMethod());
            }
          },
          title: 'Continue'),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                inputField(
                    controller: controller.adressController,
                    title: "Adress",
                    icon: Icons.location_city,
                    addTitle: true,
                    isFilled: true,
                    textColor: AppColors.mainColor),
                inputField(
                    controller: controller.cityController,
                    textColor: AppColors.mainColor,
                    title: 'City',
                    isFilled: true,
                    icon: Icons.location_city,
                    addTitle: true),
                inputField(
                    controller: controller.stateController,
                    title: "State",
                    addTitle: true,
                    isFilled: true,
                    icon: Icons.location_on,
                    textColor: AppColors.mainColor),
                inputField(
                    controller: controller.pCodeController,
                    title: "Postal Code",
                    addTitle: true,
                    isFilled: true,
                    icon: Icons.qr_code,
                    textColor: AppColors.mainColor),
                inputField(
                    controller: controller.phoneController,
                    title: "Phone",
                    addTitle: true,
                    icon: Icons.phone,
                    isFilled: true,
                    textColor: AppColors.mainColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
