import 'package:ecommerce_app_seller/const/colors.dart';
import 'package:ecommerce_app_seller/const/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget dashboadButton({title, count, icon, isIcon = false ,size}) {
  return Container(
    // padding: EdgeInsets.all(8),
    width: Get.width * 0.46,
    height: 80,
    decoration: BoxDecoration(
        color: AppColors.mainColor, borderRadius: BorderRadius.circular(10)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontFamily: AppStyles.bold,
                  color: Colors.white,
                  fontSize: 16),
            ),
            Text(
              count.toString(),
              style: TextStyle(
                  fontFamily: AppStyles.bold,
                  color: Colors.white,
                  fontSize: 16),
            )
          ],
        ),
        isIcon
            ? Icon(
                icon,
                color: Colors.white,
                size: size,
              )
            : Image.asset("assets/icons/$icon.png",
                color: Colors.white, width: 35)
      ],
    ),
  );
}
