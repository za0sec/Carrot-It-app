import 'dart:convert';
import 'package:carrot/back/person/Person.dart';
import 'package:carrot/back/prizes/prizes.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NetworkService {
  static const String _baseUrl = 'http://za0sec.changeip.co:3000';
  static const Map<String, String> header = {
    "Content-Type": "application/json"
  };
  static Future<void> notificationServer(TimeOfDay? time, DateTime dateTime,
      String? token, String name, int carrots) async {
    final timeString = formatTimeOfDay(time!);
    final dateString = DateFormat('yyyy-MM-dd').format(dateTime);
    print(
        "Enviando solicitud al servidor con hora: $timeString, token: $token, nombre: $name, y carrots: $carrots");
    final url = Uri.parse('$_baseUrl/scheduleNotification');

    try {
      final response = await http.post(
        url,
        headers: header,
        body: json.encode({
          'date': dateString,
          'time': timeString,
          'token': token,
          'username': name,
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

  static Future<void> updateCarrots(String username, int newCarrots,
      int sumCarrots, int multiplier, int days, DateTime? lastDate) async {
    final url = Uri.parse('$_baseUrl/updateCarrots');
    var body = json.encode({
      'username': username,
      'newCarrots': newCarrots,
      'sumCarrots': sumCarrots,
      'multiplier': multiplier,
      'days': days,
      'lastDate': lastDate?.toIso8601String()
    });
    print('Enviando: $body');

    try {
      final response = await http.post(
        url,
        headers: header,
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

  static Future<int> updateCarrotsFromServer(String username) async {
    final url = Uri.parse(
        '$_baseUrl/getCarrots?username=$username'); // Reemplaza con la URL de tu servidor
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

  static Future<bool> register(
      String username, String password, String token) async {
    final carrots = 0;
    final url = Uri.parse('$_baseUrl/register');
    try {
      final response = await http
          .post(
            url,
            headers: header,
            body: json.encode({
              'username': username,
              'password': password,
              'carrots': carrots,
              'token': token
            }),
          )
          .timeout(Duration(seconds: 10));

      print(response.body);

      return response.statusCode == 200;
    } catch (e) {
      print('Error en la solicitud de registro: $e');
      return false;
    }
  }

  static Future<bool> saveGym(
      String username, String gym, List<bool> selected) async {
    final url = Uri.parse('$_baseUrl/saveGym');
    try {
      final response = await http.post(
        url,
        headers: header,
        body: json
            .encode({'username': username, 'gym': gym, 'selected': selected}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error en el guardado del gymnasio en la base de datos.');
      return false;
    }
  }

  static Future<bool> saveEmail(String username, String alertEmail) async {
    final url = Uri.parse('$_baseUrl/saveEmail');
    try {
      final response = await http.post(
        url,
        headers: header,
        body: json.encode({'username': username, 'alertemail': alertEmail}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error en el guardado del email en la base de datos.');
      return false;
    }
  }

  static Future<Person?> login(
      String username, String password, String token) async {
    final url = Uri.parse('$_baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
            {'username': username, 'password': password, 'token': token}),
      );

      if (response.statusCode == 200) {
        print('Respuesta del servidor: ${response.body}');
        final personMap = json.decode(response.body);
        Map<DateTime, List<Prizes>> redeems = {};
        return Person.fromMap(personMap, redeems);
      }

      return null;
    } catch (e) {
      print('Error en la solicitud de inicio de sesión: $e');
      return null;
    }
  }

  static Future<void> sendEmail(
      String subject, String body, String alertEmail) async {
    var url = Uri.parse('$_baseUrl/send-email');
    var response = await http.post(
      url,
      headers: header,
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
