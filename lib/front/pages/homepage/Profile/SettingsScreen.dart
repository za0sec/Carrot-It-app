import 'package:carrot/front/pages/homepage/Profile/RedeemCards.dart';
import 'package:carrot/front/pages/homepage/Profile/RedeemPage.dart';
import 'package:flutter/material.dart';
import 'package:modern_form_line_awesome_icons/modern_form_line_awesome_icons.dart';

import '../../../../back/Person.dart';
import 'ProfileMenuWidget.dart';

class SettingsScreen extends StatefulWidget {
  final Person person;

  const SettingsScreen({super.key, required this.person});

  @override
  State<SettingsScreen> createState() => _SettingsScreen();
}

class _SettingsScreen extends State<SettingsScreen> {
  final TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Text(
                      'Configuración',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          ProfileMenuWidget(
            title: "Add redeem email alert",
            icon: LineAwesomeIcons.envelope,
            onPress: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: AlertDialog(
                      title: Text('Enter Redeem Email'),
                      content: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(hintText: 'Email'),
                        obscureText: false,
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Submit'),
                          onPressed: () {
                            widget.person.alertEmail = _nameController.text;
                            widget.person.save();
                            print(
                                'Saved new alertEmail: ${widget.person.alertEmail}');
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          const Divider(),
          ProfileMenuWidget(
              title: "Past Redeems",
              icon: LineAwesomeIcons.envelope,
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RedeemPage(person: widget.person),
                  ),
                );
              }),
          const Divider(),
        ],
      ),
    );
  }
}
