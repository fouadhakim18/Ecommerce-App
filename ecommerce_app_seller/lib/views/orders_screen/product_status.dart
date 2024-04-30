import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:ecommerce_app_seller/controllers/orders_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

import '../../const/colors.dart';
import '../../const/styles.dart';
import '../../widgets/product_status_button.dart';
import '../../widgets/stepper_data.dart';

class ProductStatus extends StatelessWidget {
  final dynamic documentId;
  final int index;
  final dynamic orders;
  final  token;
  const ProductStatus(
      {super.key, required this.orders, this.documentId, required this.index, required this.token});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrdersController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Product Status",
          style: TextStyle(
              color: Colors.black,
              fontFamily: AppStyles.semibold,
              fontSize: 17),
        ),
      ),
      bottomNavigationBar: productStatusButton(
          data: orders, id: documentId, index: index, context: context, token: token),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: AnotherStepper(
            stepperList: [
              stepperData(
                  title: "Order Placed",
                  subtitle: "Your order has been placed",
                  icon: Icons.done_rounded,
                  isActive: orders['order_placed']),
              stepperData(
                  title: "Order Confirmed",
                  subtitle: "Your order has been confirmed",
                  icon: Icons.thumb_up_alt_rounded,
                  isActive: orders['order_confirmed']),
              stepperData(
                  title: "On Delivery",
                  subtitle: "Your order is on delivery",
                  icon: Icons.delivery_dining_rounded,
                  isActive: orders['order_on_delivery']),
              stepperData(
                  title: "Delivered",
                  subtitle: "Your order has been delivered",
                  icon: Icons.done_all_rounded,
                  isActive: orders["order_delivered"]),
            ],
            stepperDirection: Axis.vertical,
            iconWidth: 40,
            iconHeight: 40,
            activeBarColor: AppColors.mainColor,
            inActiveBarColor: Colors.grey,
            verticalGap: 60,
            activeIndex: orders['order_delivered']
                ? 3
                : orders['order_on_delivery']
                    ? 2
                    : orders['order_confirmed']
                        ? 1
                        : 0,
            barThickness: 4,
          ),
        ),
      ),
    );
  }
}
