import 'dart:convert';

import 'package:flutter/material.dart';
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


}