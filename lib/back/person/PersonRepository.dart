import 'dart:convert';

import 'package:carrot/back/person/Person.dart';
import 'package:carrot/back/prizes/prizes.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonRepository {
  static Future<void> savePerson(Person person) async {
    final prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> redeemsMap = {};
    person.redeems.forEach((key, value) {
      String dateKey = DateFormat('yyyy-MM-dd').format(key);
      List<String> prizeNames = value.map((prize) => prize.name).toList();
      redeemsMap[dateKey] = prizeNames;
    });

    final personMap = {
      'name': person.name,
      'carrots': person.carrots,
      'token': person.token,
      'dateTime': person.dateTime.toIso8601String(),
      'time': person.time != null
          ? "${person.time!.hour}:${person.time!.minute}"
          : null,
      'profileImagePath': person.profileImagePath,
      'lastDate': person.lastDate?.toIso8601String(),
      'multiplier': person.multiplier,
      'alertEmail': person.alertEmail,
      'redeems': json.encode(redeemsMap),
      'gym': person.gym,
      'coords': person.coords,
      'daysOfWeekSelected': person.daysOfWeekSelected != null
          ? person.daysOfWeekSelected!.join(',')
          : null,
    };

    String personJson = json.encode(personMap);
    await prefs.setString('savedPerson', personJson);
  }

  static Future<Person?> getSavedPerson() async {
    final prefs = await SharedPreferences.getInstance();
    String? personJson = prefs.getString('savedPerson');
    if (personJson == null) {
      print('No saved person found');
      return null;
    }
    try {
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
      print('About to call Person.fromMap');
      return Person.fromMap(personMap, redeems);
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<void> clearSavedPerson() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('savedPerson');
  }
}
