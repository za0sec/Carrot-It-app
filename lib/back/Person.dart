import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'prizes/prizes.dart';

class Person {
  String name;
  int carrots;
  String? token;
  String? profileImagePath;
  DateTime? dateTime;
  TimeOfDay? time;
  DateTime? lastDate;
  int days = 0;
  int multiplier = 0;
  int sumCarrots = 0;
  String? alertEmail;
  Map<DateTime, List<Prizes>> redeems = {};
  Person(this.name, this.carrots, {this.profileImagePath});

  @override
  String toString() {
    return name;
  }

  void redeemPrice(int carrots) {
    this.carrots -= carrots;
    save();
  }

  void setCarrots(DateTime actualDate) {
    _resetDaysIfNotConsecutive(actualDate);
    sumCarrots++;
    days++;
    sumCarrots = _limitCarrotsToMaximum(days);
    sumCarrots = _applyMultiplierToCarrots(sumCarrots);
    _updateCarrotsCount(sumCarrots);
    save();
  }

  void _resetDaysIfNotConsecutive(DateTime actualDate) {
    if (lastDate != null && !_isNextDay(actualDate, lastDate!)) {
      days = 0;
      multiplier = 0;
      sumCarrots = 0;
    }
    lastDate = actualDate;
  }

  bool _isNextDay(DateTime date1, DateTime date2) {
    final difference = date1.difference(date2).inDays;
    return difference == 1;
  }

  int _limitCarrotsToMaximum(int days) {
    return days >= 7 ? 7 : days;
  }

  int _applyMultiplierToCarrots(int carrots) {
    if (_everySeventhDay()) {
      multiplier++;
      return carrots + (carrots * multiplier);
    }
    return carrots;
  }

  bool _everySeventhDay() {
    return days % 7 == 0;
  }

  void _updateCarrotsCount(int carrots) {
    this.carrots += carrots;
  }

  void setToken(String? token) {
    this.token = token;
  }

  void setTime(TimeOfDay time, DateTime dateTime) {
    this.time = time;
    this.dateTime = dateTime;
    notificationServer(time, dateTime, token);
    save();
  }

  bool checkTime() {
    getSavedPerson();
    return time == null;
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> redeemsMap = {};
    redeems.forEach((key, value) {
      String dateKey = DateFormat('yyyy-MM-dd').format(key);
      List<String> prizeNames = value.map((prize) => prize.name).toList();
      redeemsMap[dateKey] = prizeNames;
    });
    final Map<String, dynamic> personMap = {
      'name': name,
      'carrots': carrots,
      'token': token,
      'dateTime': dateTime?.toIso8601String(),
      'time': time != null ? "${time!.hour}:${time!.minute}" : null,
      'profileImagePath': profileImagePath,
      'lastDate': lastDate?.toIso8601String(),
      'multiplier': multiplier,
      'alertEmail': alertEmail,
      'redeems': json.encode(redeemsMap),
    };
    String personJson = json.encode(personMap);
    await prefs.setString('savedPerson', personJson);
  }

  static Future<Person?> getSavedPerson() async {
    final prefs = await SharedPreferences.getInstance();
    String? personJson = prefs.getString('savedPerson');
    if (personJson != null) {
      Map<String, dynamic> personMap = json.decode(personJson);
      Map<String, dynamic> redeemsJson =
          json.decode(personMap['redeems'] as String);
      Map<DateTime, List<Prizes>> redeems = {};
      redeemsJson.forEach((key, value) {
        DateTime date = DateFormat('yyyy-MM-dd').parse(key);
        List<Prizes> prizes = (value as List).map((name) {
          return Prizes.values.firstWhere((prize) => prize.name == name,
              orElse: () => Prizes.chocolate);
        }).toList();
        redeems[date] = prizes;
      });
      return Person.fromMap(personMap, redeems);
    }
    return null;
  }

  Person.fromMap(Map<String, dynamic> personMap, this.redeems)
      : name = personMap['name'],
        carrots = personMap['carrots'],
        token = personMap['token'],
        profileImagePath = personMap['profileImagePath'],
        dateTime = personMap['dateTime'] != null
            ? DateTime.parse(personMap['dateTime'])
            : null,
        multiplier = personMap['multiplier'] ?? 0,
        alertEmail = personMap['alertEmail'] {
    if (personMap['time'] != null) {
      List<String> timeParts = personMap['time'].split(':');
      time = TimeOfDay(
          hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
    }
    if (personMap['lastDate'] != null) {
      lastDate = DateTime.parse(personMap['lastDate']);
    }
  }

  Future<void> notificationServer(
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

  Future<void> sendEmail(String subject, String body) async {
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

  String formatTimeOfDay(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }
}
