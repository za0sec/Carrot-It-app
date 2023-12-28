import 'dart:math';

import 'package:carrot/back/Person.dart';
import 'package:flutter/material.dart';

import '../../../../back/prizes/prizes.dart';

class RedeemCard extends StatelessWidget {
  final Prizes prize;
  final DateTime date;
  final Person person;

  RedeemCard({required this.prize, required this.date, required this.person});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: screenSize.width * 0.8,
        height: screenSize.height * 0.5,
        child: Stack(
          children: <Widget>[
            FractionallySizedBox(
              widthFactor: 1.2,
              heightFactor: 0.9,
              child: Image.asset(
                'lib/front/assets/images/ticket.png',
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              left: 0,
              right: 75,
              top: screenSize.height * 0.14,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.001),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Ticket for ${prize.name}!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Valid through ${date.day}/${date.month}/${date.year}\nOne time use.\nScreenshot & send.',
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Property of ${person.name}',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
