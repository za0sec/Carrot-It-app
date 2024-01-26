import 'package:carrot/back/network/NetworkUtility.dart';
import 'package:carrot/back/person/Person.dart';
import 'package:carrot/front/pages/homepage/motivation/widgets/gym/gymPage/GymPage.dart';
import 'package:carrot/front/pages/homepage/motivation/widgets/gym/utilities/GymMap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NotDay extends StatefulWidget {
  final Person person;

  const NotDay({Key? key, required this.person}) : super(key: key);

  @override
  _NotDayState createState() => _NotDayState();
}

String apiKey = dotenv.env['GOOGLE_API_KEY']!;
late LatLng? location;

class _NotDayState extends State<NotDay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;
  int baseDurationMillis = 100; // Duración base de 100 milisegundos
  late int totalDurationMillis;

  @override
  void initState() {
    location = widget.person.coords;
    totalDurationMillis =
        baseDurationMillis * widget.person.gymStreak.clamp(10, 50);

    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: totalDurationMillis),
      vsync: this,
    );

    _animation = IntTween(begin: 0, end: widget.person.gymStreak).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linearToEaseOut,
      ),
    )..addListener(() {
        setState(() {});
      });

    // Inicia la animación
    _controller.forward();
  }

  @override
  void didUpdateWidget(NotDay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.person.gymStreak != widget.person.gymStreak) {
      _animation =
          IntTween(begin: _animation.value, end: widget.person.gymStreak)
              .animate(_controller)
            ..addListener(() {
              setState(() {});
            });

      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 25),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Text(
                'Gym Streak',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFfb901c),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/front/assets/gifs/flame.gif',
                  scale: 4,
                ), // Reemplaza 'path_to_gif.gif' con la ruta de tu GIF
                SizedBox(width: 10),
                Text(
                  '${_animation.value}',
                  style: TextStyle(
                    fontSize: 65,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFfb901c),
                  ),
                ),
              ],
            ),
            SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Every ${widget.person.getSelectedDaysString().join(', ')} at ${widget.person.gym}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            GymMap(
              centerFuture: NetworkUtility.getCoordenates(widget.person.gym!),
              userLocation: location,
            ),
            SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GymPage(person: widget.person),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                textStyle: TextStyle(fontSize: 20),
              ),
              child: Text(
                'Modify week',
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
}
