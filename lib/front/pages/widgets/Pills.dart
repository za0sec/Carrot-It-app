import 'package:carrot/front/pages/RePick.dart';
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
          onTap: () async {
            if (widget.person.checkTime()) {
              await _selectDateAndTime(context);
            }else {
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
