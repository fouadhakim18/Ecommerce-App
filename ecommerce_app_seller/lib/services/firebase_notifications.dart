import 'dart:convert';

import 'package:http/http.dart' as http;

var serverToken =
    "AAAAR67zztk:APA91bGkrbprBtupZTh_gYnQyU5bgIgOw4D1hrn3zQnqyIZbD7iF3GFrcXyNy0B7LvwvBSSc02lfzAXLbH_GvzTRUmwxyMkLYleZf_wSIPC0NekswMMYiyyuXwB0x5yj1aAkotK0ASLC";
sendNotif(String title, String body, String token) async {
  await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(<String, dynamic>{
        'notification': <String, dynamic>{
          'body': body.toString(),
          'title': title.toString(),
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        },
        'to': token
      }));
}
