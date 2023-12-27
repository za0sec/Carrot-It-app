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
        width: screenSize.width * 0.8, // 80% del ancho de la pantalla
        height: screenSize.height * 0.5, // 50% del alto de la pantalla
        child: Stack(
          children: <Widget>[
            FractionallySizedBox(
              widthFactor: 1.3,
              heightFactor: 0.9,
              child: Image.asset(
                'lib/front/assets/images/ticket.png',
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              left: 75,
              right: 0,
              top: screenSize.height * 0.13,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '¡Ticket para ${prize.name}!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Valido solo el ${date.day}/${date.month}/${date.year}\nValido por un solo uso.\nScreenshotear y enviar.',
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Propiedad de ${person.name}',
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
