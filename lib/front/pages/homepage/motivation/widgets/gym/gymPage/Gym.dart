import 'package:carrot/back/person/Person.dart';
import 'package:carrot/front/pages/homepage/motivation/widgets/gym/gymDone/GymDone.dart';
import 'package:carrot/front/pages/homepage/motivation/widgets/gym/gymPage/GymPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Gym extends StatefulWidget {
  final Person person;

  const Gym({super.key, required this.person});

  @override
  State<Gym> createState() => _GymState();
}

class _GymState extends State<Gym> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 5,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => (widget.person.gym == null ||
                        widget.person.daysOfWeekSelected == null)
                    ? GymPage(person: widget.person)
                    : GymDone(person: widget.person)),
          );
        },
        child: Container(
          alignment: Alignment.center,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('Gym'),
            SizedBox(height: 5),
            Icon(
              Icons.fitness_center,
              size: 33.0,
              color: Color(0xFFfb901c),
            ),
          ]),
        ),
      ),
    );
  }
}
