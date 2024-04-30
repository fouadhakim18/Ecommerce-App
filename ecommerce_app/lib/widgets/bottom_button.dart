import 'package:flutter/material.dart';

import '../consts/colors.dart';

Widget bottomButton({required onTap, required title}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      height: 60,
      color: AppColors.mainColor,
      child: Center(
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
      ),
    ),
  );
}
