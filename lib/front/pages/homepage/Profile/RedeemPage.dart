import 'package:carrot/back/Person.dart';
import 'package:carrot/front/pages/homepage/HomePage.dart';
import 'package:carrot/front/pages/homepage/Profile/RedeemCards.dart';
import 'package:flutter/material.dart';
import 'package:carrot/back/prizes/prizes.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';

class RedeemPage extends StatelessWidget {
  final Person person;

  RedeemPage({required this.person});

  @override
  Widget build(BuildContext context) {
    List<Widget> cards = [];
    person.redeems.forEach((date, prizes) {
      for (var prize in prizes) {
        cards.add(RedeemCard(prize: prize, date: date, person: person));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Prizes'),
      ),
      body: cards.isEmpty
          ? SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 30),
                  SizedBox(
                    height: 200,
                    child: Text(
                      'No redeems yet :(',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFfb901c),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'To redeem tickets you have to complete any task on Motivation page',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage(person: person)),
                      );
                    },
                    child: Text(
                      'Go to Motivation page',
                      style: TextStyle(fontSize: 17),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFfff0e8)),
                  ),
                ],
              ),
            )
          : StackedCardCarousel(
              initialOffset: -50,
              spaceBetweenItems: 400,
              items: cards,
            ),
    );
  }
}
