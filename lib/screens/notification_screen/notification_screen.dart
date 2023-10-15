import 'dart:convert';

import 'package:eanemart_admin_panel/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

Future<void> sendNotificationToWholeUsers() async {
  const String serverKey =
      'AAAAUmqwtng:APA91bHmtTgSkElV-LpfX7y1UTx8cjvrHIPhEIKUjATSwwgosZBZxK2kdAzLX7VHjqRpyc294Bob8lr2HlSOlb7PHJ4I9-7Jqez0zB3ug--yqMjA5jLftjmPgTX86Ngbb4S97NZZ4HVd';

  const String firebaseUrl = 'https://fcm.googleapis.com/fcm/send';

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'key=$serverKey'
  };

  final Map<String, dynamic> notification = {
    'title': 'Notification Title',
    'body': 'Notification Body',
  };
  final Map<String, dynamic> requestBody = {
    'notification': notification,
    'piority': 'high',
    'registration_ids': ['']
  };

  final String encodedBody = jsonEncode(requestBody);

  final http.Response response = await http.post(
    Uri.parse(firebaseUrl),
    headers: headers,
    body: encodedBody,
  );

  if (response.statusCode == 200) {
    showMessage("Notification sent successfullt.");
  } else {
    showMessage(
        "Notification sending failed with status: ${response.statusCode}");
  }
}
