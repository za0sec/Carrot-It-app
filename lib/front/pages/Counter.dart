import 'dart:async';

import 'package:carrot/front/pages/homepage/HomePage.dart';
import 'package:flutter/material.dart';

import '../../back/Person.dart';

class Counter extends StatefulWidget {
  final Person person;
  final bool startTimerOnLoad;

  const Counter({Key? key, required this.person, this.startTimerOnLoad = false})
      : super(key: key);

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  late Timer countdownTimer;
  TimeOfDay? callTime;
  late DateTime currentTime;
  int remainingTime = 5 * 60;

  @override
  void initState() {
    super.initState();
    callTime = widget.person.time;
    currentTime = DateTime.now();

    if (widget.startTimerOnLoad) {
      int secondsCurrentTime = currentTime.hour * 3600 +
          currentTime.minute * 60 +
          currentTime.second;
      int secondsCallTime = callTime!.hour * 3600 + callTime!.minute * 60;

      int differenceInSeconds = secondsCurrentTime - secondsCallTime;

      remainingTime -= differenceInSeconds;

      startCountdown();
    }
  }

  void startCountdown() {
    countdownTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          timer.cancel();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(person: widget.person)),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    countdownTimer.cancel();
    super.dispose();
  }

  String formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter'),
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
            SizedBox(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    formatTime(remainingTime),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 85,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFfb901c),
                    ),
                  ),
                  SizedBox(width: 20),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(person: widget.person),
                  ),
                );
                widget.person.setCarrots(DateTime.now());
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
                'Ya la tome!',
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
