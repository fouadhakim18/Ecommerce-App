import 'package:ecommerce_app/consts/colors.dart';
import 'package:ecommerce_app/consts/num_curr.dart';
import 'package:ecommerce_app/consts/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

orderPlaceDetails(data) {
  return [
    Center(
      child: Container(
        width: 70,
        height: 5,
        decoration: BoxDecoration(
            color: AppColors.lightGrey2,
            borderRadius: BorderRadius.circular(10)),
      ),
    ),
    const SizedBox(
      height: 30,
    ),
    Row(
      children: [
        const Text(
          "Order Code : ",
          style: TextStyle(fontFamily: AppStyles.semibold),
        ),
        Text("${data['order_code']}")
      ],
    ),
    const SizedBox(
      height: 20,
    ),
    Row(
      children: [
        const Text(
          "Shipping Method : ",
          style: TextStyle(fontFamily: AppStyles.semibold),
        ),
        Text("${data['shipping_method']}")
      ],
    ),
    const SizedBox(
      height: 20,
    ),
    Row(
      children: [
        const Text(
          "Order Date : ",
          style: TextStyle(fontFamily: AppStyles.semibold),
        ),
        Text(
            "${intl.DateFormat().add_yMEd().add_Hm().format(data['order_date'].toDate())}")
      ],
    ),
    const SizedBox(
      height: 20,
    ),
    Row(
      children: [
        const Text(
          "Payment Method : ",
          style: TextStyle(fontFamily: AppStyles.semibold),
        ),
        Text("${data['payment_method']}")
      ],
    ),
    const SizedBox(
      height: 20,
    ),
    Row(
      children: const [
        Text(
          "Payment Status : ",
          style: TextStyle(fontFamily: AppStyles.semibold),
        ),
        Text("Unpaid")
      ],
    ),
    const SizedBox(
      height: 20,
    ),
    Row(
      children: const [
        Text(
          "Delivery Status : ",
          style: TextStyle(fontFamily: AppStyles.semibold),
        ),
        Text("Order placed")
      ],
    ),
    const SizedBox(
      height: 20,
    ),
    Row(
      children: const [
        Text(
          "Shipping  Adress : ",
          style: TextStyle(fontFamily: AppStyles.semibold),
        ),
      ],
    ),
    const SizedBox(
      height: 15,
    ),
    Padding(
      padding: const EdgeInsets.only(left: 40),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                "Name : ",
                style: TextStyle(
                    fontFamily: AppStyles.semibold,
                    color: AppColors.lightGrey3),
              ),
              Text(data['order_by_name'])
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                "Email : ",
                style: TextStyle(
                    fontFamily: AppStyles.semibold,
                    color: AppColors.lightGrey3),
              ),
              Text(data['order_by_email'])
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                "Adress : ",
                style: TextStyle(
                    fontFamily: AppStyles.semibold,
                    color: AppColors.lightGrey3),
              ),
              Expanded(
                  child: Text(data['order_by_adress'],
                      overflow: TextOverflow.ellipsis))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                "City : ",
                style: TextStyle(
                    fontFamily: AppStyles.semibold,
                    color: AppColors.lightGrey3),
              ),
              Text(data['order_by_city'])
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                "State : ",
                style: TextStyle(
                    fontFamily: AppStyles.semibold,
                    color: AppColors.lightGrey3),
              ),
              Text(data['order_by_state'])
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                "Phone : ",
                style: TextStyle(
                    fontFamily: AppStyles.semibold,
                    color: AppColors.lightGrey3),
              ),
              Text(data['order_by_phone'])
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                "Postal Code : ",
                style: TextStyle(
                    fontFamily: AppStyles.semibold,
                    color: AppColors.lightGrey3),
              ),
              Text(
                data['order_by_postalcode'],
              )
            ],
          ),
        ],
      ),
    ),
    const SizedBox(
      height: 20,
    ),
    const Divider(
      thickness: 1.3,
    ),
    const SizedBox(
      height: 20,
    ),
    Row(
      children: [
        const Text(
          "Total Amount : ",
          style: TextStyle(fontFamily: AppStyles.semibold),
        ),
        Text(
          currencyFormatter.format(data['total_amount']),
          style: const TextStyle(
              color: AppColors.redColor, fontFamily: AppStyles.bold),
        )
      ],
    ),
    const SizedBox(
      height: 15,
    ),
  ];
}
