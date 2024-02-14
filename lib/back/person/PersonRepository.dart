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
      'gymDate': person.gymDate.toIso8601String(),
      'multiplier': person.multiplier,
      'alertEmail': person.alertEmail,
      'redeems': json.encode(redeemsMap),
      'gym': person.gym,
      'gymStreak': person.gymStreak,
      'lat': person.coords?.latitude,
      'lng': person.coords?.longitude,
      'firstPill': person.firstPill,
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
      return Person.fromMap(personMap, redeems);
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static String serializeRedeems(Map<DateTime, List<Prizes>> redeems) {
    Map<String, dynamic> redeemsMap = {};
    redeems.forEach((date, prizes) {
      String dateString = date.toIso8601String();
      List<Map<String, dynamic>> prizesList =
          prizes.map((prize) => _prizeToMap(prize)).toList();
      redeemsMap[dateString] = prizesList;
    });
    return jsonEncode(redeemsMap);
  }

  static Map<DateTime, List<Prizes>> deserializeRedeems(String jsonStr) {
    var decoded = jsonDecode(jsonStr);
    Map<DateTime, List<Prizes>> redeems = {};

    decoded.forEach((dateStr, prizesList) {
      DateTime date = DateTime.parse(dateStr);
      List<Prizes> prizes = (prizesList as List<dynamic>)
          .map((prizeMap) => _mapToPrize(prizeMap))
          .toList();
      redeems[date] = prizes;
    });

    return redeems;
  }

  static Prizes _mapToPrize(Map<String, dynamic> prizeMap) {
    String name = prizeMap['name'];
    for (Prizes prize in Prizes.values) {
      if (prize.name == name) {
        return prize;
      }
    }
    throw Exception('Prize not found for name: $name');
  }

  static Map<String, dynamic> _prizeToMap(Prizes prize) {
    return {
      'name': prize.name,
      'price': prize.price,
      'description': prize.description,
    };
  }

  static Future<void> clearSavedPerson() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('savedPerson');
  }
}
