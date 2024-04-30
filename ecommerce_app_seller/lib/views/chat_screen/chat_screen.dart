import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

import '../../const/colors.dart';
import '../../const/firebase_consts.dart';
import '../../const/styles.dart';
import '../../controllers/chat_controller.dart';
import '../../services/firestore_services.dart';
import '../../widgets/sender_bubble.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.senderName,
          style: const TextStyle(
              color: AppColors.darkFontGrey,
              fontSize: 18,
              fontFamily: AppStyles.semibold),
        ),
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.darkFontGrey,
          ),
        ),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.mainColor,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(12),
                child: Column(children: [
                  Expanded(
                      child: StreamBuilder(
                    stream: FirestoreService.getChatMessages(
                        controller.chatDocId.toString()),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      } else if (snapshot.hasData) {
                        if (snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text("Start the conversation"),
                          );
                        } else {
                          return ListView(
                            reverse: true,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            children: snapshot.data!.docs.map((e) {
                              return Align(
                                  alignment: e['uid'] == currentUser!.uid
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: senderBubble(e));
                            }).toList(),
                          );
                        }
                      }
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.mainColor,
                        ),
                      );
                    },
                  )),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    height: 60,
                    child: Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                          controller: controller.messageController,
                          decoration: const InputDecoration(
                            hintText: "Type a message ..",
                            hintStyle: TextStyle(
                                color: AppColors.lightGrey2, fontSize: 15),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColors.darkFontGrey)),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.mainColor),
                            ),
                          ),
                        )),
                        InkWell(
                            onTap: () {
                              controller
                                  .sendMsg(controller.messageController.text);
                              controller.messageController.clear();
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.send,
                                color: AppColors.mainColor,
                              ),
                            ))
                      ],
                    ),
                  )
                ]),
              ),
      ),
    );
  }
}
