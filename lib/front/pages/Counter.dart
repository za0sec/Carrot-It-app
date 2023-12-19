import 'dart:async';

import 'package:carrot/front/pages/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../back/Person.dart';

class Counter extends StatefulWidget {
  final Person person;
  final bool startTimerOnLoad; // Parámetro para indicar si se debe iniciar el temporizador

  const Counter({Key? key, required this.person, this.startTimerOnLoad = false}) : super(key: key);

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  late Timer countdownTimer;
  TimeOfDay? callTime;
  TimeOfDay currentTime = TimeOfDay.now();
  int remainingTime = 5 * 60;

    @override
    void initState() {
      super.initState();
      callTime = (widget.person.time);
      if (widget.startTimerOnLoad) {
        int seconds1 = (currentTime.hour * 60 + currentTime.minute) * 60;
        int seconds2 = (callTime!.hour * 60 + callTime!.minute) * 60;
        int differenceInSeconds = (seconds1 - seconds2).abs();
        differenceInSeconds *= -1;
        remainingTime += differenceInSeconds;
        startCountdown();
      }
    }

  void startCountdown() {
    countdownTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        timer.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(person: widget.person)),
        );
      }
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
              onPressed: () {
              },
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(person: widget.person),
                  ),
                );
                widget.person.setCarrots(50);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                textStyle: TextStyle(fontSize: 20),
              ),
              child: Text('Ya la tome!',
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
