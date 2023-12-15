import 'package:carrot/front/pages/MyHomePage.dart';
import 'package:carrot/front/pages/HomePage.dart';
import 'package:carrot/front/pages/SettingsScreen.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../back/Person.dart';

void main() {
  runApp(MyApp());
}

//el alumno le pregunto al profesor como poder ponerle un fondo a la app de color naranja y el profesor le dijo que lo hiciera con el colorScheme y el seedColor

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CarrotApp',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFfb901c)),
        ),
        home: MyHomePage(),
        routes: {
          '/second': (context) => HomePage(
                person: Person(''),
              ),
          '/settings': (context) => SettingsScreen(),
        },
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
}

