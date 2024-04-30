import 'package:ecommerce_app_seller/const/colors.dart';
import 'package:flutter/material.dart';

Widget productImage({required label, onPress}) {
  return Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
        color: AppColors.lightGrey, borderRadius: BorderRadius.circular(8)),
    child: Center(
      child: Text(
        label,
        style: TextStyle(color: AppColors.fontGrey),
      ),
    ),
  );
}
