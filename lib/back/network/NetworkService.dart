import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NetworkService {
  static Future<void> notificationServer(
      TimeOfDay? time, DateTime dateTime, String? token) async {
    final timeString = formatTimeOfDay(time!);
    final dateString = DateFormat('yyyy-MM-dd').format(dateTime);
    print(
        "Enviando solicitud al servidor con hora: $timeString y token: $token");
    final url =
        Uri.parse('http://za0sec.changeip.co:3000/scheduleNotification');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json
            .encode({'date': dateString, 'time': timeString, 'token': token}),
      );
      if (response.statusCode == 200) {
        print('Notificación programada');
      } else {
        print('Error al programar la notificación: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al enviar la solicitud: $e');
    }
  }

  static Future<void> sendEmail(
      String subject, String body, String alertEmail) async {
    var url = Uri.parse('http://za0sec.changeip.co:3000/send-email');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': alertEmail,
        'subject': subject,
        'body': body,
      }),
    );

    if (response.statusCode == 200) {
      print('OK');
    } else {
      print('Error al enviar email');
    }
  }

  static String formatTimeOfDay(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }
}
