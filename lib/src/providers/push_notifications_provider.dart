import 'package:firebase_messaging/firebase_messaging.dart';

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

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Mensaje en primer plano: ${message.notification?.body}");
      // Aquí puedes hacer algo con el mensaje en primer plano
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Mensaje recibido al abrir la app desde segundo plano: ${message.notification?.body}");
      // Aquí puedes hacer algo con el mensaje al abrir la app desde segundo plano
    });
  }
}