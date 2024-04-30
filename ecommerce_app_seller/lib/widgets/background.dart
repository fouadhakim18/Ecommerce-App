import 'package:flutter/cupertino.dart';

import '../const/colors.dart';

Widget bgWidget({Widget? child, bool addLogo = true, bool top = false}) {
  return Container(
    width: double.maxFinite,
    height: double.maxFinite,
    decoration: BoxDecoration(
        color: AppColors.mainColor,
        image: DecorationImage(
            image: const AssetImage("assets/icons/wp2252568.jpg"),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            colorFilter: ColorFilter.mode(
                AppColors.mainColor.withOpacity(0.10), BlendMode.dstATop))),
    child: Stack(children: [
      if (addLogo)
        const Positioned(
          right: 50,
          left: 50,
          top: 50,
          child: Image(image: AssetImage("assets/icons/Logo (10).png")),
        ),
      if (!top)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: child!,
        )
      else
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: child!,
        )
    ]),
  );
}
