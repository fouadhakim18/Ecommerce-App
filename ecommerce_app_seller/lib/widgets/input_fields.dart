import 'package:flutter/material.dart';

import '../const/colors.dart';
import '../const/styles.dart';

Widget inputField(
    {required TextEditingController controller,
    required String title,
    IconData? icon,
    VoidCallback? onTap,
    bool isPasswordVisible = false,
    bool isPassword = false,
    bool isFilled = false,
    bool addTitle = false,
    int maxLines = 1,
    padding = 10.0,
    textColor = Colors.white}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: padding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (addTitle)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              title,
              style:
                  TextStyle(color: textColor, fontFamily: AppStyles.semibold),
            ),
          ),
        TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return 'This field is required.';
            }
            return null;
          },
          maxLines: maxLines,
          controller: controller,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
              filled: isFilled,
              fillColor: Colors.white,
              border: InputBorder.none,
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.mainColor)),
              prefixIcon: icon == null
                  ? null
                  : onTap != null
                      ? Icon(Icons.lock)
                      : Icon(icon),
              suffixIcon: onTap == null
                  ? null
                  : GestureDetector(
                      onTap: onTap,
                      child: Icon(
                        icon,
                        color: AppColors.mainColor,
                      ),
                    ),
              hintText: title,
              hintStyle: const TextStyle(fontSize: 12)),
          obscureText: isPassword ? !isPasswordVisible : false,
        )
      ],
    ),
  );
}
