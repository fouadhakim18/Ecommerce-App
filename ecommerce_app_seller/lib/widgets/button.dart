import 'package:ecommerce_app_seller/const/styles.dart';
import 'package:flutter/material.dart';
import '../const/colors.dart';

class Button extends StatelessWidget {
  Color? color;
  final String text;
  final double size;
  Color? textColor;
  VoidCallback clicked;
  Button(
      {super.key,
      this.color = AppColors.mainColor,
      this.textColor = Colors.white,
      required this.text,
      this.size = 16,
      required this.clicked});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: clicked,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: color,
            ),
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontFamily: AppStyles.semibold,
                fontSize: size,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
