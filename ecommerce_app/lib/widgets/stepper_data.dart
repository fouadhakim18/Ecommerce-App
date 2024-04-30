import 'package:another_stepper/another_stepper.dart';
import 'package:ecommerce_app/consts/colors.dart';
import 'package:flutter/material.dart';

StepperData stepperData(
    {required String title,
    required String subtitle,
    required IconData icon,
    required bool isActive}) {
  return StepperData(
      title: StepperText(
        title,
      ),
      subtitle: StepperText(subtitle),
      iconWidget: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: isActive ? AppColors.mainColor : AppColors.darkFontGrey,
            borderRadius: const BorderRadius.all(Radius.circular(30))),
        child: Icon(icon, color: Colors.white),
      ));
}
