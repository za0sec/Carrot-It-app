import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Information extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Information'),
        backgroundColor:
            Color(0xFFfff0e8), // Ajusta esto al color de tu preferencia
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://avatars.githubusercontent.com/u/112484112?s=400&u=f3a3e816c737657a555de438d845947aaeb511f1&v=4'), // Reemplaza con tu imagen
            ),
            SizedBox(height: 10),
            Text(
              'Javier Peral',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'My name is Javier and I am a freelance developer. If you need a developer then contact me for more informations',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                Uri url = Uri.parse(
                    'https://www.linkedin.com/in/javier-peral-belmont-854052208/');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  throw 'No se pudo lanzar $url';
                }
              },
              child: Text('Contact me'),
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color(0xFFfff0e8)), // Ajusta al color de tu preferencia
            ),
          ],
        ),
      ),
    );
  }
}
