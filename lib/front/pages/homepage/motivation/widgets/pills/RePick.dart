import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../back/person/Person.dart';

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
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Actually, \nyour blister starts at:\n${DateFormat('dd-MM-yyyy').format(widget.person.dateTime!)}',
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
                'Your pill notification is set at:\n${formatTimeOfDay(widget.person.time!)}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFfb901c),
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () async {
                  await _selectDateAndTime(context);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  textStyle: TextStyle(fontSize: 20),
                ),
                child: Text(
                  'Change date & time',
                  style: TextStyle(
                    color: Color(0xFFfb901c),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatTimeOfDay(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
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
