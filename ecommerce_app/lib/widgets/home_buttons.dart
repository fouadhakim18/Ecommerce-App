import 'package:flutter/material.dart';

Widget homeButtons({width, height, icon, title, onPress}) {
  return Container(
    width: width,
    height: height,
    padding: const EdgeInsets.symmetric(horizontal: 5),
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(10)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          icon,
          width: 26,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 13),
          textAlign: TextAlign.center,
        )
      ],
    ),
  );
}
