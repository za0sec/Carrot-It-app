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
            color: Color(0xFFf7c58c),
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
                      return AlertDialog(
                        title: Text('Add redeem email alert'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                hintText: 'Email',
                              ),
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                widget.person.alertEmail = _nameController.text;
                                widget.person.save();
                                print(
                                    'Saved new alertEmail: ${widget.person.alertEmail}');
                                Navigator.pop(context);
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
                      );
                    });
              }),
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
