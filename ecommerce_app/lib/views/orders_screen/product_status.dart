import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:ecommerce_app/widgets/stepper_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../consts/colors.dart';
import '../../consts/styles.dart';

class ProductStatus extends StatelessWidget {
  final dynamic data;
  const ProductStatus({super.key, required this.data});

  @override
  Widget build(BuildContext context) {

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
      body: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: AnotherStepper(
          stepperList: [
            stepperData(
                title: "Order Placed",
                subtitle: "Your order has been placed",
                icon: Icons.done_rounded,
                isActive: data['order_placed']),
            stepperData(
                title: "Order Confirmed",
                subtitle: "Your order has been confirmed",
                icon: Icons.thumb_up_alt_rounded,
                isActive: data['order_confirmed']),
            stepperData(
                title: "On Delivery",
                subtitle: "Your order is on delivery",
                icon: Icons.delivery_dining_rounded,
                isActive: data['order_on_delivery']),
            stepperData(
                title: "Delivered",
                subtitle: "Your order has been delivered",
                icon: Icons.done_all_rounded,
                isActive: data["order_delivered"]),
          ],
          stepperDirection: Axis.vertical,
          iconWidth: 40,
          iconHeight: 40,
          activeBarColor: AppColors.mainColor,
          inActiveBarColor: Colors.grey,
          verticalGap: 60,
          activeIndex: data['order_delivered']
              ? 3
              : data['order_on_delivery']
                  ? 2
                  : data['order_confirmed']
                      ? 1
                      : 0,
          barThickness: 4,
        ),
      ),
    );
  }
}
