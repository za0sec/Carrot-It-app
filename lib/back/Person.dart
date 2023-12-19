import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Person {
  String name;
  int carrots;
  String? token;
  Person(this.name, this.carrots);
  DateTime? dateTime;
  TimeOfDay? time;

  @override
  String toString() {
    return name;
  }

  void redeemPrice(int carrots){
    this.carrots -= carrots;
    save();
  }

  void setCarrots(int carrots){
    this.carrots += carrots;
    save();
  }

  void setToken(String? token){
    this.token = token;
  }

  void setTime(TimeOfDay time, DateTime dateTime){
    this.time = time;
    this.dateTime = dateTime;
    notificationServer(time, dateTime, token);
    save();
  }

  bool checkTime(){
    getSavedPerson();
    return time == null;
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> personMap = {
      'name': name,
      'carrots': carrots,
      'token': token,
      'dateTime': dateTime?.toIso8601String(), // Convertir DateTime a String
      'time': time != null ? "${time!.hour}:${time!.minute}" : null, // Convertir TimeOfDay a String
    };
    String personJson = json.encode(personMap);
    await prefs.setString('savedPerson', personJson);
  }

  static Future<Person?> getSavedPerson() async {
    final prefs = await SharedPreferences.getInstance();
    String? personJson = prefs.getString('savedPerson');
    if (personJson != null) {
      Map<String, dynamic> personMap = json.decode(personJson);
      DateTime? dateTime = personMap['dateTime'] != null ? DateTime.parse(personMap['dateTime']) : null;
      TimeOfDay? time;
      if (personMap['time'] != null) {
        List<String> timeParts = personMap['time'].split(':');
        time = TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
      }
      return Person(personMap['name'], personMap['carrots'])
        ..setToken(personMap['token'])
        ..dateTime = dateTime
        ..time = time;
    }
    return null;
  }


  Future<void> notificationServer(TimeOfDay? time, DateTime dateTime, String? token) async {
    final timeString = formatTimeOfDay(time!);
    final dateString = DateFormat('yyyy-MM-dd').format(dateTime);
    print("Enviando solicitud al servidor con hora: $timeString y token: $token");
    final url = Uri.parse('http://za0sec.changeip.co:3000/scheduleNotification');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({'date': dateString, 'time': timeString, 'token': token}),
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

  String formatTimeOfDay(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }


}