import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:ecommerce_app/views/chat_screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../consts/colors.dart';
import '../../consts/styles.dart';
import 'package:intl/intl.dart' as intl;

class MessagingScreen extends StatelessWidget {
  const MessagingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Messages",
          style: TextStyle(
              color: Colors.black,
              fontFamily: AppStyles.semibold,
              fontSize: 17),
        ),
      ),
      body: StreamBuilder(
          stream: FirestoreService.getAllMessages(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (snapshot.hasData) {
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                    child: Center(
                  child: Lottie.asset("assets/images/empty.json"),
                ));
              } else {
                final data = snapshot.data!.docs;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final t = data[index]['created_on'] == null
                          ? DateTime.now()
                          : data[index]['created_on'].toDate();
                      final time = intl.DateFormat('HH:mm').format(t);
                      return Card(
                        child: ListTile(
                          onTap: () => Get.to(() => ChatScreen(), arguments: [
                            data[index]['friend_name'],
                            data[index]['toId'], 
                            data[index]['friend_token']
                          ]),
                          leading: CircleAvatar(
                            backgroundColor: AppColors.mainColor,
                            child: Icon(
                              Icons.person,
                              color: AppColors.whiteColor,
                            ),
                          ),
                          title: Text(
                            data[index]['friend_name'],
                            style: TextStyle(fontFamily: AppStyles.semibold),
                          ),
                          subtitle: Text(
                            data[index]['last_msg'],
                          ),
                          trailing: Text(
                            time.toString(),
                            style: TextStyle(
                                color: AppColors.lightGrey3, fontSize: 14),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            }
            ;
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.mainColor,
              ),
            );
          }),
    );
  }
}
