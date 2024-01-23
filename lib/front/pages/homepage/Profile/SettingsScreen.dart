import 'package:carrot/back/network/NetworkService.dart';
import 'package:carrot/front/pages/homepage/profile/RedeemPage.dart';
import 'package:flutter/material.dart';
import 'package:modern_form_line_awesome_icons/modern_form_line_awesome_icons.dart';

import '../../../../back/person/Person.dart';
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
            color: Color(0xFFfff0e8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Text(
                      'Configuración',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
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
                          onPressed: () async {
                            widget.person.alertEmail = _nameController.text;
                            bool success = await NetworkService.saveEmail(
                                widget.person.name, widget.person.alertEmail!);
                            Navigator.pop(context);
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Email successfully saved!',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Error saveing email...',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                            widget.person.save();
                            print(
                                'Saved new alertEmail: ${widget.person.alertEmail}');
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
