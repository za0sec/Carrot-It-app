import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Prizes {
  chocolate('Chocolate', 100, 'Este premio se puede canjear por un chocolate de cualquier marca.'),
  movieChoice('Pelicula', 200, 'Este premio se puede intercambiar por una eleccion de pelicula a preferencia del canjeador.'),
  foodElection('Salida a comer', 300, 'Este premio puede ser canjeado por una salida a comer.'),
  movieTheatre('Cine', 400, 'Eleccion de dia para poder ir al cine. Paga la persona a la que le canjean el ticket'),
  shoppingTime('Shopping Time', 500, 'Canjeable por un dia entero en un shopping a eleccion y un MINI regalo (puede ser comida o algo muy chiquito)'),
  homeFood('Comida casera', 1000, 'Canjeable por una comida romantica. Comida casera hecha por la persona a la que le canjean el ticket'),
  bag('Cartera', 2000, 'Este premio es canjeable por una cartera a eleccion'),
  domoTime('Domos', 5000, 'Canjeable por una noche en los domos'),
  vacations('Vacaciones', 10000, 'Canjeable por unas vacaciones fuera del pais.');

  final int price;
  final String description;
  final String name;
  const Prizes(this.name, this.price, this.description);

  bool canRedeem(int tusCarrots) {
    return tusCarrots >= price;
  }

  Icon icon(int carrots){
    if (canRedeem(carrots)){
      return Icon(Icons.check, color: Colors.green);
    }
    return Icon(Icons.close, color: Colors.red);
  }

}