import 'package:carrot/front/pages/MyHomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../back/Person.dart';

class Pills extends StatefulWidget {
  final Person person;
  
  const Pills({super.key, required this.person});

  @override
  State<Pills> createState() => _PillsState();
}

class _PillsState extends State<Pills> {
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        child: InkWell(
            onTap: (){
              widget.person.setCarrots(5);
            },
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.pills,
                    size: 37.0,
                    color: Color(0xFFfb901c),
                  ),
                ]
              ),
            ),
        ),
    );
  }
}
