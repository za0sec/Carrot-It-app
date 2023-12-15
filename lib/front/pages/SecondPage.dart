import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../back/Person.dart';
import '../main.dart';

class SecondPage extends StatefulWidget {

  final Person person;

  const SecondPage({Key? key, required this.person}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final TextEditingController _nameController = TextEditingController();

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
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              // Widget Text para el título
              Text(
                'Carrot It!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFfb901c),
                ),
              ),
              // Widget Text para el subtítulo
              Text(
                "Bienvenido ${widget.person.name}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFfb901c),
                ),
              ),
              // Widget Text para el subtítulo
              Text(
                '¿Cómo te llamas?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFfb901),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}