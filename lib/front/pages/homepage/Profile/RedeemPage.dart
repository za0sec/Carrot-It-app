import 'package:carrot/back/Person.dart';
import 'package:carrot/front/pages/homepage/Profile/RedeemCards.dart';
import 'package:flutter/material.dart';

class RedeemPage extends StatelessWidget {
  final Person person;

  RedeemPage({required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prizes'),
      ),
      body: ListView.builder(
        itemCount: person.redeems.length,
        itemBuilder: (context, index) {
          return RedeemCard(prize: person.redeems[index]);
        },
      ),
    );
  }
}
