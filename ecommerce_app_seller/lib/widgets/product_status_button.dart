import 'package:ecommerce_app_seller/controllers/orders_controller.dart';
import 'package:ecommerce_app_seller/services/firestore_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../const/colors.dart';

Widget productStatusButton({data, index, id, required context, required token}) {
  final controller = Get.find<OrdersController>();
  return Visibility(
    visible: !data['order_delivered'],
    child: GestureDetector(
      onTap: () {
        data['order_on_delivery']
            ? controller.deliveredOrder(id, index, context, data['title'], token)
            : data['order_confirmed']
                ? controller.onDeliveryOrder(id, index, context, data['title'], token)
                : controller.confirmOrder(id, index, context, data['title'], token);
      },
      child: Container(
        width: double.infinity,
        height: 60,
        color: AppColors.mainColor,
        child: Obx(
          () => controller.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Center(
                  child: Text(
                    data['order_on_delivery']
                        ? 'Order Delivered'
                        : data['order_confirmed']
                            ? 'On Delivery'
                            : 'Confirm Order',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
        ),
      ),
    ),
  );
}
