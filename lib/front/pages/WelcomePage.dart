import 'package:carrot/src/providers/push_notifications_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../back/Person.dart';
import '../../main.dart';
import 'homepage/HomePage.dart';

class WelcomePage extends StatefulWidget {
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final TextEditingController _nameController = TextEditingController();

  late Person person;

  @override
  void initState() {
    super.initState();
    person = Person('', 0);
    _checkSavedPerson();
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
            children: [
              SizedBox(height: 10),
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
                  person = Person(_nameController.text, 0);
                  print('New person instance: $person');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(person: person),
                    ),
                  );
                  person.save();
                  PushNotification push_notif = PushNotification(person);
                  push_notif.initNotifications();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(fontSize: 20),
                ),
                child: Text(
                  'Next',
                  style: TextStyle(
                    color: Color(0xFFfb901c),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _checkSavedPerson() async {
    final personN = await Person.getSavedPerson();
    if (personN != null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(person: personN),
        ),
      );
    }
  }
}
