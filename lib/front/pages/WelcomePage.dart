import 'package:carrot/back/network/NetworkService.dart';
import 'package:carrot/back/person/PersonRepository.dart';
import 'package:carrot/front/pages/RegisterPage.dart';
import 'package:flutter/material.dart';
import '../../back/person/Person.dart';
import 'homepage/HomePage.dart';
import 'package:carrot/src/providers/push_notifications_provider.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late Person person;

  @override
  void initState() {
    _checkSavedPerson();
    person = Person('', 0);
    super.initState();
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
                  // configuraciones para este campo
                  hintText: 'Username',
                ),
              ),
              SizedBox(height: 20),
              // Agrega un nuevo TextField para la contraseña
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  // configuraciones para este campo
                  hintText: 'Password',
                ),
                obscureText: true, // para ocultar la contraseña
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  await _handleLogin();
                },
                child: Text('Login'),
                // Estilos del botón
              ),
              SizedBox(height: 10), // Espacio entre los botones
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Text(
                  'Register',
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

  Future<void> _handleLogin() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    PushNotification pushNotif = PushNotification(person);
    await pushNotif.initNotifications();
    Person? nPerson =
        await NetworkService.login(username, password, person.token!);

    if (nPerson == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Wrong user or password',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (!nPerson!.isEmpty) {
      person = nPerson;
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
    }
  }

  Future<void> _checkSavedPerson() async {
    print('antes de esperar');
    final savedPerson = await PersonRepository.getSavedPerson();
    print('antes de entrar');
    if (savedPerson != null) {
      print('god');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                  person: savedPerson,
                )),
        (Route<dynamic> route) =>
            false, // Esto removerá todas las rutas anteriores
      );
    }
  }
}
