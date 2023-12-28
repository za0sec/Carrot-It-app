import 'dart:collection';
import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../back/Person.dart';
import '../../../back/prizes/prizes.dart';
import 'Profile/SettingsScreen.dart';

class Carrots extends StatefulWidget {
  final Person person;

  const Carrots({super.key, required this.person});

  @override
  State<Carrots> createState() => _CarrotsState();
}

class _CarrotsState extends State<Carrots> {
  final ConfettiController _confettiController =
      ConfettiController(duration: Duration(seconds: 10));

  DateTime today = DateTime.now();

  @override
  void initState() {
    super.initState();
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrots'),
        automaticallyImplyLeading: false,
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
                    '${widget.person.carrots} ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 65,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFfb901c),
                    ),
                  ),
                  SizedBox(width: 20),
                  FaIcon(FontAwesomeIcons.carrot, size: 50),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: Prizes.values.length,
              itemBuilder: (context, index) {
                Prizes prize = Prizes.values[index];
                return _buildPrizeCard(prize, widget.person);
              },
            ),
          ],
        ),
      ),
    );
  }

  Card _buildPrizeCard(Prizes prize, Person person) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: FaIcon(FontAwesomeIcons.ticketAlt, color: Color(0xFFfb901c)),
          title: Text(prize.name),
          subtitle: Text('${prize.price} Carrots'),
          trailing: prize.icon(person.carrots),
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child: Column(
                children: [
                  Text(
                    prize.description,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${prize.price} Carrots are needed for redeem.',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, left: 25, right: 25),
              child: Column(
                children: [
                  if (prize.canRedeem(person.carrots))
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 150, // Ancho fijo para el widget del precio
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${prize.price}',
                                style: TextStyle(
                                    fontSize: 30, color: Color(0xFFfb901c)),
                              ),
                              SizedBox(width: 10),
                              FaIcon(FontAwesomeIcons.carrot, size: 25),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              person.redeemPrice(prize.price);
                              if (widget.person.alertEmail != null) {
                                widget.person.sendEmail("Canje de Premio",
                                    "${widget.person.name} ha canjeado ${prize.name}");
                              }
                            });
                            DateTime todayDate =
                                DateTime(today.year, today.month, today.day);

                            if (!widget.person.redeems.containsKey(todayDate)) {
                              widget.person.redeems[todayDate] = [];
                            }

                            widget.person.redeems[todayDate]!.add(prize);
                            _onRedeemButtonPressed(prize);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            textStyle: TextStyle(fontSize: 15),
                          ),
                          child: Text(
                            'Canjear',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onRedeemButtonPressed(Prizes prize) {
    _confettiController.play();
    var screenSize = MediaQuery.of(context).size;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Stack(
            children: <Widget>[
              ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                particleDrag: 0.05,
                emissionFrequency: 0.05,
                numberOfParticles: 30,
                gravity: 0.05,
                shouldLoop: false,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple
                ],
              ),
              FractionallySizedBox(
                widthFactor: 1.2,
                heightFactor: 0.4,
                child: Image.asset(
                  'lib/front/assets/images/ticket.png',
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                left: 0,
                right: 60,
                top: screenSize.height * 0.08,
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
                      SizedBox(height: 15),
                      Text(
                        'Valid through ${today.day}/${today.month}/${today.year}\n\nOne time use.\nScreenshot & send.',
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Property of ${widget.person.name}',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
