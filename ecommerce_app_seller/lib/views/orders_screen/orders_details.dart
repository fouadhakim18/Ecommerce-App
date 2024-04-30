import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../const/colors.dart';
import '../../const/styles.dart';
import '../../widgets/bottom_button.dart';
import '../../widgets/stepper_data.dart';
import 'order_place_details.dart';

class OrdersDetails extends StatelessWidget {
  final dynamic data;
  const OrdersDetails({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: bottomButton(
      //     onTap: () {
      //       showModalBottomSheet(
      //         context: context,
      //         isScrollControlled: true,
      //         backgroundColor: Colors.transparent,
      //         useSafeArea: true,
      //         isDismissible: true,
      //         builder: (BuildContext context) {
      //           return DraggableScrollableSheet(
      //             initialChildSize: 0.5, // Initial collapsed size
      //             minChildSize: 0.5,
      //             maxChildSize: 1.0,
      //             builder: (context, scrollController) {
      //               return Container(
      //                 padding:
      //                     const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      //                 decoration: BoxDecoration(
      //                     color: AppColors.whiteColor,
      //                     borderRadius: BorderRadius.circular(10)),
      //                 child: ListView(
      //                   shrinkWrap: true,
      //                   physics: const BouncingScrollPhysics(),
      //                   controller: scrollController,
      //                   children: orderPlaceDetails(data),
      //                 ),
      //               );
      //             },
      //           );
      //         },
      //       );
      //     },
      //     title: "View Details"),
      appBar: AppBar(
          title: const Text(
        "Order Details",
        style: TextStyle(
            color: Colors.black, fontFamily: AppStyles.semibold, fontSize: 17),
      )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
          verticalGap: 50,
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
