import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart' as intl;

import '../const/colors.dart';
import '../const/firebase_consts.dart';

Widget senderBubble(DocumentSnapshot data) {
  final t =
      data["created_on"] == null ? DateTime.now() : data['created_on'].toDate();

  final time = intl.DateFormat('HH:mm').format(t);
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
        color: data["uid"] == currentUser!.uid
            ? AppColors.mainColor
            : const Color.fromARGB(255, 179, 179, 179),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        )),
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data["msg"],
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            time,
            style: const TextStyle(
                color: Color.fromARGB(255, 236, 236, 236), fontSize: 12),
          )
        ],
      ),
    ),
  );
}
