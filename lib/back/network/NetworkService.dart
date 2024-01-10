import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NetworkService {
  static Future<void> notificationServer(TimeOfDay? time, DateTime dateTime,
      String? token, String name, int carrots) async {
    final timeString = formatTimeOfDay(time!);
    final dateString = DateFormat('yyyy-MM-dd').format(dateTime);
    print(
        "Enviando solicitud al servidor con hora: $timeString, token: $token, nombre: $name, y carrots: $carrots");
    final url =
        Uri.parse('http://za0sec.changeip.co:3000/scheduleNotification');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'date': dateString,
          'time': timeString,
          'token': token,
          'name': name,
          'carrots': carrots
        }),
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

  static Future<void> createUser(
      String? token, String name, int carrots) async {
    print("Creando usuario en servidor con nombre: $name, y carrots: $carrots");
    final url = Uri.parse('http://za0sec.changeip.co:3000/createUser');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({'token': token, 'name': name, 'carrots': carrots}),
      );
      if (response.statusCode == 200) {
        print('Usuario creado');
      } else {
        print('Error al crear usuario: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al enviar la solicitud: $e');
    }
  }

  static Future<void> updateCarrots(String token, int newCarrots) async {
    final url = Uri.parse('http://za0sec.changeip.co:3000/updateCarrots');
    var body = json.encode({'token': token, 'newCarrots': newCarrots});
    print('Enviando: $body');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      if (response.statusCode == 200) {
        print('Carrots actualizados');
      } else {
        print('Error al actualizar los carrots: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al enviar la solicitud de actualización: $e');
    }
  }

  static Future<int> updateCarrotsFromServer(String token) async {
    final url = Uri.parse(
        'http://za0sec.changeip.co:3000/getCarrots?token=$token'); // Reemplaza con la URL de tu servidor
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        int carrots = data['carrots'];
        return carrots;
      } else {
        throw Exception('Error al obtener los carrots desde el servidor');
      }
    } catch (e) {
      throw Exception('Error al conectarse al servidor: $e');
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
