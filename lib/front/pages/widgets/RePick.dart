import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../back/Person.dart';

class RePick extends StatefulWidget {
  final Person person;
  const RePick({super.key, required this.person});

  @override
  State<RePick> createState() => _RePickState();
}

class _RePickState extends State<RePick> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pills'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: ImageIcon(
                AssetImage('lib/front/assets/images/Carrot.png'),
                color: Color(0xFFfb901c),
                size: 60,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Actualmente, \nempiezas tu nuevo blister:\n${DateFormat('yyyy-MM-dd').format(widget.person.dateTime!)}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFfb901c),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Todos los dias a las: ${widget.person.time}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFfb901c),
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                await _selectDateAndTime(context);
                widget.person.setCarrots(50, DateTime.now());
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                textStyle: TextStyle(fontSize: 20),
              ),
              child: Text(
                'Cambiar Fecha y Hora',
                style: TextStyle(
                  color: Color(0xFFfb901c),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
        setState(() {
          widget.person.setTime(selectedTime, selectedDate);
        });
      }
    }
  }
}
