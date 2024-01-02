import 'package:carrot/back/person/PersonRepository.dart';
import 'package:carrot/front/pages/homepage/motivation/widgets/pills/Counter.dart';
import 'package:flutter/material.dart';
import '../../back/person/Person.dart';
import 'homepage/HomePage.dart';
import 'package:carrot/src/providers/push_notifications_provider.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.orange.shade200, // Naranja claro
                Colors.orange.shade400, // Un tono de naranja más oscuro
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(flex: 2),
              Image.asset(
                'lib/front/assets/images/Carrot.png', // Tu logo
                height: 120,
              ),
              Spacer(),
              Text(
                'Carrot It!',
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Your name',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleGetStarted,
                child: Text('Get started'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
              Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }

  void _handleGetStarted() {
    person = Person(_nameController.text, 0);
    person.save();
    PushNotification pushNotif = PushNotification(person);
    pushNotif.initNotifications();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage(person: person)),
    );
  }

  Future<void> _checkSavedPerson() async {
    final savedPerson = await PersonRepository.getSavedPerson();
    if (savedPerson != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(person: savedPerson)),
      );
    }
  }
}
