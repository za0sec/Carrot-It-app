import 'package:carrot/back/network/NetworkUtility.dart';
import 'package:carrot/front/pages/homepage/motivation/widgets/gym/gymDone/widgets/YesDay.dart';
import 'package:carrot/front/pages/homepage/motivation/widgets/gym/gymDone/widgets/notDay.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../../back/person/Person.dart';

class GymDone extends StatefulWidget {
  final Person person;
  const GymDone({super.key, required this.person});

  @override
  State<GymDone> createState() => _GymDoneState();
}

class _GymDoneState extends State<GymDone> {
  bool _isCurrentDaySelected = false;

  @override
  void initState() {
    super.initState();
    initializeDate();
  }

  Future<void> initializeDate() async {
    final now = await NetworkUtility.getCurrentDate();
    print(now);
    final formatter = DateFormat('EEEE');
    print(formatter.format(now));
    _isCurrentDaySelected =
        widget.person.getSelectedDaysString().contains(formatter.format(now));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gym'),
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
      body: (_isCurrentDaySelected &&
              DateTime(widget.person.gymDate.year, widget.person.gymDate.month,
                      widget.person.gymDate.day) !=
                  DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day))
          ? YesDay(person: widget.person)
          : NotDay(person: widget.person),
    );
  }
}
