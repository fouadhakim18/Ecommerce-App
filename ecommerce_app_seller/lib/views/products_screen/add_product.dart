import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app_seller/const/colors.dart';
import 'package:ecommerce_app_seller/const/styles.dart';
import 'package:ecommerce_app_seller/controllers/products_controller.dart';
import 'package:ecommerce_app_seller/widgets/input_fields.dart';
import 'package:ecommerce_app_seller/widgets/product_dropdown.dart';
import 'package:ecommerce_app_seller/widgets/product_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';

import '../../widgets/utils.dart';

class AddProduct extends StatelessWidget {
  final String title;
  const AddProduct({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductsController());
    return Scaffold(
      // backgroundColor: AppColors.mainColor,
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
              fontFamily: AppStyles.semibold,
              fontSize: 18,
              color: AppColors.darkFontGrey),
        ),
        // iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Obx(
            () => controller.isLoading.value
                ? Padding(
                    padding: const EdgeInsets.only(right: 14.0, top: 4),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.mainColor,
                      ),
                    ),
                  )
                : TextButton(
                    onPressed: () async {
                      await controller.validateProductForm(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        "Save",
                        style: TextStyle(
                            color: AppColors.mainColor,
                            fontFamily: AppStyles.semibold,
                            fontSize: 17),
                      ),
                    )),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                inputField(
                    controller: controller.pnameController,
                    title: 'Product Name',
                    isFilled: true,
                    padding: 10.0),
                inputField(
                    controller: controller.pdescController,
                    title: 'Description',
                    isFilled: true,
                    padding: 10.0,
                    maxLines: 4),
                inputField(
                    controller: controller.ppriceController,
                    title: 'Product Price',
                    isFilled: true,
                    padding: 10.0),
                inputField(
                    controller: controller.pquantityController,
                    title: 'Product Quantity',
                    isFilled: true,
                    padding: 10.0),
                const SizedBox(
                  height: 10,
                ),
                productDropDown(
                    hint: "Choose Category",
                    list: controller.categoryList,
                    dropValue: controller.categoryValue,
                    controller: controller),
                const SizedBox(
                  height: 10,
                ),
                productDropDown(
                    hint: "Choose Subcategory",
                    list: controller.subcategoryList,
                    dropValue: controller.subcategoryValue,
                    controller: controller),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Add product images : ( first image will be on display )",
                  style: TextStyle(
                      color: AppColors.darkFontGrey,
                      fontFamily: AppStyles.semibold,
                      fontSize: 15),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                      3,
                      (index) => InkWell(
                          onTap: () {
                            if (controller.pImgsEdit[index] == null) {
                              controller.pickImage(index, context);
                            }
                          },
                          child: Obx(() => controller.pImagesList[index] != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(7),
                                  child: Image.file(
                                    controller.pImagesList[index],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : controller.pImgsEdit[index] != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(7),
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: controller.pImgsEdit[index],
                                          placeholder: (context, url) =>
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                            color: AppColors.whiteColor,
                                          )),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                    )
                                  : productImage(label: '${index + 1}')))),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Add product colors :",
                  style: TextStyle(
                      color: AppColors.darkFontGrey,
                      fontFamily: AppStyles.semibold,
                      fontSize: 15),
                ),
                const SizedBox(
                  height: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Obx(
                      () => Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: controller.availableColors.map((color) {
                          return CircleAvatar(
                            radius: 25,
                            backgroundColor: Color(color),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainColor,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Pick a color'),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  pickerColor: controller.selectedColor,
                                  onColorChanged: (color) {
                                    controller.selectedColor = color;
                                  },
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    controller.availableColors
                                        .add(controller.selectedColor.value);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Select'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        'Add Color',
                        style: TextStyle(
                            color: AppColors.whiteColor,
                            fontFamily: AppStyles.semibold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
