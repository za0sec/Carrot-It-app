import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../back/Person.dart';
import 'SettingsScreen.dart';

class Profile extends StatefulWidget {

  final Person person;

  const Profile({Key? key, required this.person}) : super(key: key);

  @override
  State<Profile> createState() => _State();
}

class _State extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: ImageIcon(
                AssetImage('lib/front/assets/images/Carrot.png'),
                color: Color(0xFFfb901c),
                size: 60,
              ),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: SettingsScreen(),
      body:SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Card(
                    child: Container(
                      width: 160,
                    ),
                  );
                },
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Pastillas Anticonceptivas'),
                    leading: Icon(Icons.category),
                    subtitle: Text('Detalles del minijuego ${index + 1}'),
                    trailing: Text('${(index + 1) * 100} Carrots'),
                  ),
                );
              },
            ),
          ],

        ),
      ),

    );
  }
}
