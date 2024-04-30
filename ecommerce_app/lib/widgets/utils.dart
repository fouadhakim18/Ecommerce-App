import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import '../consts/colors.dart';

class Utils {
  // static showSnackbar(
  //     {required title, required message, color = AppColors.whiteColor}) {
  //   Get.snackbar(title, message,
  //       backgroundColor: color.withOpacity(0.6),
  //       titleText: Text(
  //         title,
  //         style: const TextStyle(color: AppColors.mainColor),
  //       ));
  // }

  static showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.fontGrey.withOpacity(0.9),
        textColor: Colors.white,
        fontSize: 14.0);
  }

  static Future<bool> showExitDialog() async {
    return await Get.defaultDialog(
      titlePadding: const EdgeInsets.symmetric(vertical: 15),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      title: 'Exit App?',
      content: const Text('Are you sure you want to quit?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Get.back(result: false);
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.mainColor),
          ),
        ),
        TextButton(
          onPressed: () {
            Get.back(result: true);
          },
          child: const Text(
            'Quit',
            style: TextStyle(color: AppColors.mainColor),
          ),
        ),
      ],
    );
  }
}
