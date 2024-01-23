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
  late final DateTime now;
  late Future<bool> _shouldShowYesDayFuture;

  @override
  void initState() {
    super.initState();
    _shouldShowYesDayFuture = shouldShowYesDay();
  }

  Future<void> initializeDate() async {
    now = await NetworkUtility.getCurrentDate();
    print(now);
    final formatter = DateFormat('EEEE');
    print(formatter.format(now));
    setState(() {
      _isCurrentDaySelected =
          widget.person.getSelectedDaysString().contains(formatter.format(now));
    });
    print(_isCurrentDaySelected);
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
      body: FutureBuilder<bool>(
        future: _shouldShowYesDayFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Aquí manejas el resultado del futuro
            return snapshot.data!
                ? YesDay(person: widget.person)
                : NotDay(person: widget.person);
          }
        },
      ),
    );
  }

  Future<bool> shouldShowYesDay() async {
    await initializeDate();
    return _isCurrentDaySelected &&
        DateTime(widget.person.gymDate.year, widget.person.gymDate.month,
                widget.person.gymDate.day) !=
            DateTime(now.year, now.month, now.day);
  }
}
