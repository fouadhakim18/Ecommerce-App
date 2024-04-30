import 'package:ecommerce_app/views/categories_screen/category_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/product_controller.dart';

Widget featuredItem({img, title}) {
  final controller = Get.put(ProductController());

  return GestureDetector(
    onTap: () {
      controller.getSubCategories(title);

      Get.to(() => CategoryDetails(title: title), arguments: title);
    },
    child: Container(
      width: 230,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(
              8.0,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                img,
                width: 60,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    ),
  );
}
