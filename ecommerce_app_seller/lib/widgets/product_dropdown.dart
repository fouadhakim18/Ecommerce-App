import 'package:ecommerce_app_seller/controllers/products_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget productDropDown(
    {hint,
    required List<String> list,
    dropValue,
    required ProductsController controller}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(5)),
    child: Obx(
      () => DropdownButtonHideUnderline(
          child: DropdownButton(
        hint: Text(
          hint,
          style: TextStyle(fontSize: 13),
        ),
        value: dropValue.value == "" ? null : dropValue.value,
        isExpanded: true,
        items: list.map((e) {
          return DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style: TextStyle(fontSize: 13),
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (hint == 'Choose Category') {
            controller.subcategoryValue.value = "";
            controller.populateSubCategoryList(value.toString());
          }

          dropValue.value = value.toString();
        },
      )),
    ),
  );
}
