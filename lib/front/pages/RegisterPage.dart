import 'package:carrot/back/network/NetworkService.dart';
import 'package:carrot/back/person/PersonRepository.dart';
import 'package:carrot/front/pages/WelcomePage.dart';
import 'package:flutter/material.dart';
import '../../back/person/Person.dart';
import 'homepage/HomePage.dart';
import 'package:carrot/src/providers/push_notifications_provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late Person person;
  bool _obscureText = true;

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
                controller: _usernameController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Username',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                obscureText: _obscureText,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  await _handleRegister();
                },
                child: Text('Register'),
                // Estilos del botón
              ),
              SizedBox(height: 10), // Espacio entre los botones
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomePage()),
                  );
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue, // Color del texto
                    decoration: TextDecoration
                        .underline, // Subrayado para parecer un enlace
                  ),
                ),
              ),
              Spacer(flex: 4),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    person = Person(username, 0);
    PushNotification pushNotif = PushNotification(person);
    await pushNotif.initNotifications();
    if (!isValidPassword(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Password must contain 8+ characters, 1+ capital letter and numbers.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      bool success =
          await NetworkService.register(username, password, person.token!);

      if (success) {
        person.save();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    person: person,
                  )),
          (Route<dynamic> route) =>
              false, // Esto removerá todas las rutas anteriores
        );
      } else {
        print('ERRORRRRRR');
      }
    }
  }

  Future<void> _checkSavedPerson() async {
    final savedPerson = await PersonRepository.getSavedPerson();
    if (savedPerson != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                  person: person,
                )),
        (Route<dynamic> route) =>
            false, // Esto removerá todas las rutas anteriores
      );
    }
  }

  bool isValidPassword(String password) {
    String pattern = r'^(?=.*[A-Z])(?=.*[0-9]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(password);
  }
}
