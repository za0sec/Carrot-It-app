import 'package:carrot/front/pages/homepage/HomePage.dart';
import 'package:carrot/front/pages/homepage/motivation/widgets/pills/Counter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../back/person/Person.dart';

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

  bool _isSameDate(DateTime day1, DateTime day2) {
    return day1.year == day2.year &&
        day1.month == day2.month &&
        day1.day == day2.day;
  }

  void navigateToCounter(BuildContext context, {required bool startTimer}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => !_isSameDate(
                person.lastDate != null ? person.lastDate! : DateTime.now(),
                DateTime.now())
            ? Counter(person: person, startTimerOnLoad: startTimer)
            : HomePage(person: person),
      ),
    );
  }
}
