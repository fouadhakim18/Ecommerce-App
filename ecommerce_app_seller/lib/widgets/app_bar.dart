import 'package:flutter/material.dart';

import '../const/colors.dart';
import '../const/styles.dart';
import 'package:intl/intl.dart' as intl;

AppBar appBar(title) {
  return AppBar(
    backgroundColor: Colors.white,
    automaticallyImplyLeading: false,
    title: Text(
      title,
      style: TextStyle(
          fontSize: 18,
          color: AppColors.darkFontGrey,
          fontFamily: AppStyles.semibold),
    ),
    actions: [
      Center(
        child: Text(
          intl.DateFormat('EEE, MMM d, ' 'yy').format(DateTime.now()),
          style: TextStyle(color: AppColors.darkFontGrey),
        ),
      ),
      SizedBox(
        width: 10,
      )
    ],
  );
}
