import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Prizes {
  chocolate('Chocolate', 100,
      'This prize can be redeemed for a chocolate of any brand.'),
  movieChoice('Movie', 200,
      'This prize can be exchanged for a movie choice at the redeemer’s preference.'),
  foodElection('Eating Out', 300,
      'This prize can be redeemed for a dining out experience.'),
  movieTheatre('Cinema', 400,
      'Choice of day to go to the cinema. The person who redeems the ticket pays'),
  shoppingTime('Shopping Time', 500,
      'Redeemable for an entire day at a shopping center of choice and a MINI gift (can be food or something very small)'),
  homeFood('Homemade Food', 1000,
      'Redeemable for a romantic meal. Homemade food cooked by the person who redeems the ticket'),
  bag('Handbag', 2000,
      'This prize can be redeemed for a handbag of choice, not Gucci, not Prada, not LV.'),
  domoTime('Domos', 5000,
      'Redeemable for a night in the domes. Nestled in a serene natural landscape.'),
  vacations('Vacations', 10000,
      'Redeemable for a vacation abroad. Embark on an international getaway.');

  final int price;
  final String description;
  final String name;
  const Prizes(this.name, this.price, this.description);

  bool canRedeem(int tusCarrots) {
    return tusCarrots >= price;
  }

  Icon icon(int carrots) {
    if (canRedeem(carrots)) {
      return Icon(Icons.check, color: Colors.green);
    }
    return Icon(Icons.close, color: Colors.red);
  }
}
