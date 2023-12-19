import 'dart:convert';

import 'package:carrot/front/pages/MyHomePage.dart';
import 'package:carrot/front/pages/RePick.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
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
          onTap: () async {
            if (widget.person.checkTime()) {
              await _selectDateAndTime(context);
              programarNotificacionEnServidor(widget.person.time, widget.person.token);
            }else{
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RePick(person: widget.person),
                ),
              );
            }
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

  Future<void> programarNotificacionEnServidor(TimeOfDay? time, String? token) async {
    final timeString = time!.format(context);
    print("Enviando solicitud al servidor con hora: $timeString y token: $token");
    final url = Uri.parse('http://za0sec.changeip.co:3000/scheduleNotification');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({'time': timeString, 'token': token}),
      );
      if (response.statusCode == 200) {
        print('Notificación programada');
      } else {
        print('Error al programar la notificación: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al enviar la solicitud: $e');
    }
  }

  Future<void> _selectDateAndTime(BuildContext context) async {
    final currentDate = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null && mounted) {
      final currentTime = TimeOfDay.now();
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: currentTime,
      );

      if (selectedTime != null && mounted) {
        widget.person.setTime(selectedTime, selectedDate);
      }
    }
  }



}
