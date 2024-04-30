import 'package:flutter/material.dart';

import '../const/colors.dart';


Widget bottomButton({required onTap, required title, color = AppColors.mainColor, textColor = Colors.white}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      height: 60,
      color: color,
      child: Center(
        child: Text(
          title,
          style: TextStyle(color: textColor, fontSize: 17),
        ),
      ),
    ),
  );
}
