import 'package:carrot/front/pages/Counter.dart';
import 'package:carrot/front/pages/homepage/Profile/Info.dart';
import 'package:carrot/front/pages/WelcomePage.dart';
import 'package:carrot/front/pages/homepage/HomePage.dart';
import 'package:carrot/front/pages/widgets/RePick.dart';
import 'package:carrot/front/pages/homepage/Profile/SettingsScreen.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timezone/data/latest.dart' as tz;

import '../back/Person.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  tz.initializeTimeZones();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Carrot it!',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFfb901c)),
        ),
        home: WelcomePage(),
        routes: {
          '/second': (context) => HomePage(
                person: Person('', 0),
              ),
          '/settings': (context) => SettingsScreen(person: Person('', 0)),
          '/counter': (context) => Counter(person: Person('', 0)),
          '/rePick': (context) => RePick(person: Person('', 0)),
          '/info': (context) => Information(),
        },
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
}
