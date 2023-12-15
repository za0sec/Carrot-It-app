import 'dart:convert';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../back/Person.dart';
import '../main.dart';
import 'SecondPage.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    _checkSavedPerson();
    super.initState();
  }

  Future<void> _checkSavedPerson() async {
    final prefs = await SharedPreferences.getInstance();
    String? personJson = prefs.getString('savedPerson');
    if (personJson != null) {
      Navigator.pushReplacementNamed(context, '/second');
    }
  }


  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFfaf3e1), Color(0xFFfbe1b4)],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [ SizedBox(height: 10), // Espaciado después del título
              Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('lib/front/assets/images/Carrot.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
              Text(
                'Carrot It!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFfb901c),
                ),
              ),
              Text(
                'Enter your name:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: _nameController,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final Person newPerson = Person(_nameController.text);
                  print('New person instance: ${newPerson.name}');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SecondPage(person: newPerson),
                    ),
                  );
                  _savePerson(newPerson);
                },
                style: ElevatedButton.styleFrom(
                  //aqui abajo pongo el boton mas cuadrado
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(fontSize: 20),
                ),
                child: Text('Next',
                  style: TextStyle(
                    color: Color(0xFFfb901c), // Color del texto del botón
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }

  Future<void> _savePerson(Person person) async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> personMap = {
      'name': person.name,
      // Añade aquí otros campos si los hay
    };
    String personJson = json.encode(personMap);
    await prefs.setString('savedPerson', personJson);
  }

  Future<Person?> _getSavedPerson() async {
    final prefs = await SharedPreferences.getInstance();
    String? personJson = prefs.getString('savedPerson');
    if (personJson != null) {
      Map<String, dynamic> personMap = json.decode(personJson);
      return Person(personMap['name']); // Asegúrate de que esto coincida con la estructura de tu clase Person
    }
    return null;
  }

}