import 'package:carrot/front/pages/homepage/carrots/Counter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../back/Person.dart';

class PushNotification {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Person person;

  PushNotification(this.person);

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    String? token = await _firebaseMessaging.getToken();
    print('===== FCM TOKEN =====');
    if (token != null) {
      person.setToken(token);
      print(token);
    }
  }

  void setOnMessageOpenedApp(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Mensaje en primer plano: ${message.notification?.body}");
      navigateToCounter(context, startTimer: true);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          "Mensaje recibido al abrir la app desde segundo plano: ${message.notification?.body}");
      navigateToCounter(context, startTimer: true);
    });
  }

  void navigateToCounter(BuildContext context, {required bool startTimer}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Counter(person: person, startTimerOnLoad: startTimer),
      ),
    );
  }
}
