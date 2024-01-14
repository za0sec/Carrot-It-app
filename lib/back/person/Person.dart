import 'package:carrot/back/network/NetworkService.dart';
import 'package:carrot/back/network/NetworkUtility.dart';
import 'package:carrot/back/person/PersonRepository.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../prizes/prizes.dart';

class Person {
  String name;
  int carrots;
  String? token;
  String? profileImagePath;
  //This is set to yesterday just to work.
  DateTime dateTime = DateTime.now().subtract(Duration(days: 1));
  TimeOfDay? time;
  DateTime? lastDate;
  int days = 0;
  int multiplier = 0;
  int sumCarrots = 0;
  String? alertEmail;
  String? gym;
  DateTime gymDate = DateTime.now().subtract(Duration(days: 1));
  LatLng? coords;
  Map<DateTime, List<Prizes>> redeems = {};
  List<bool>? daysOfWeekSelected;
  bool firstPill = false;
  Person(this.name, this.carrots, {this.profileImagePath});

  @override
  String toString() {
    return name;
  }

  void redeemPrice(int carrots) {
    this.carrots -= carrots;
    save();
  }

  void addCarrotsGym() {
    this.gymDate = DateTime.now();
    this.carrots += 10;
    this.save();
    NetworkService.saveDateGym(this.name, this.gymDate);
    NetworkService.updateCarrots(this.name, this.carrots, this.sumCarrots,
        this.multiplier, this.days, this.lastDate);
  }

  void setCarrots(DateTime actualDate) async {
    _resetDaysIfNotConsecutive(actualDate);
    sumCarrots++;
    days++;
    sumCarrots = _limitCarrotsToMaximum(days);
    sumCarrots = _applyMultiplierToCarrots(sumCarrots);
    _updateCarrotsCount(sumCarrots);
    await NetworkService.updateCarrots(
        name, carrots, sumCarrots, multiplier, days, lastDate);
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
    NetworkService.notificationServer(time, dateTime, token, name, carrots);
    save();
  }

  bool checkTime() {
    PersonRepository.getSavedPerson();
    return time == null;
  }

  void save() {
    PersonRepository.savePerson(this);
  }

  static List<bool>? _parseDaysOfWeekSelected(String daysString) {
    return daysString.split(',').map((s) => s == 'true').toList();
  }

  Future<void> setLocation() async {
    coords = await NetworkUtility.getCoordenates(gym!);
    save();
  }

  List<String> getSelectedDaysString() {
    List<String> days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    List<String> selectedDays = [];
    for (int i = 0; i < days.length; i++) {
      if (daysOfWeekSelected![i]) {
        selectedDays.add(days[i]);
      }
    }
    return selectedDays;
  }

  Person.fromMap(Map<String, dynamic> personMap, this.redeems)
      : name = personMap['name'],
        carrots = personMap['carrots'],
        token = personMap['token'],
        profileImagePath = personMap['profileImagePath'],
        gym = personMap['gym'],
        coords = personMap['lat'] != null
            ? LatLng(personMap['lat'], personMap['lng'])
            : null,
        daysOfWeekSelected = personMap['daysOfWeekSelected'] != null
            ? _handleDaysOfWeekSelected(personMap['daysOfWeekSelected'])
            : null,
        dateTime = personMap['dateTime'] != null
            ? DateTime.parse(personMap['dateTime'])
            : DateTime.now().subtract(Duration(days: 1)),
        gymDate = personMap['gymDate'] != null
            ? DateTime.parse(personMap['gymDate'])
            : DateTime.now().subtract(Duration(days: 1)),
        multiplier = personMap['multiplier'] ?? 0,
        alertEmail = personMap['alertEmail'] {
    print('Person.fromMap is called');
    if (personMap['time'] != null && personMap['time'].isNotEmpty) {
      List<String> timeParts = personMap['time'].split(':');
      time = TimeOfDay(
          hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
    }
    if (personMap['lastDate'] != null) {
      lastDate = DateTime.parse(personMap['lastDate']);
    }
  }

  static List<bool>? _handleDaysOfWeekSelected(dynamic daysOfWeek) {
    if (daysOfWeek is String) {
      // Si es un String, utiliza _parseDaysOfWeekSelected
      return _parseDaysOfWeekSelected(daysOfWeek);
    } else if (daysOfWeek is List) {
      // Si es una List, conviértela directamente
      return List<bool>.from(daysOfWeek);
    }
    return null; // O manejar de otra manera si es necesario
  }

  bool get isEmpty => name.isEmpty;
}
