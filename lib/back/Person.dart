import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Person {
  String name;
  int carrots;
  String? token;
  Person(this.name, this.carrots);

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


  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> personMap = {
      'name': name,
      'carrots': carrots,
      'token': token,
    };
    String personJson = json.encode(personMap);
    await prefs.setString('savedPerson', personJson);
  }

  static Future<Person?> getSavedPerson() async {
    final prefs = await SharedPreferences.getInstance();
    String? personJson = prefs.getString('savedPerson');
    if (personJson != null) {
      Map<String, dynamic> personMap = json.decode(personJson);
      return Person(personMap['name'], personMap['carrots']);
    }
    return null;
  }


}