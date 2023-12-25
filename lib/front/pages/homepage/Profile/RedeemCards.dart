import 'package:flutter/material.dart';

import '../../../../back/prizes/prizes.dart';

class RedeemCard extends StatelessWidget {
  final Prizes prize;

  RedeemCard({required this.prize});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      color:
          Colors.pink, // O el color que prefieras para el fondo de la tarjeta
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.local_offer), // El ícono de tu premio
            title: Text(prize.name),
            subtitle: Text(prize.description),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Código del cupón: ${prize.name.substring(0, 8).toUpperCase()}',
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ButtonBar(
            children: <Widget>[
              ElevatedButton(
                child: Text('OK'),
                onPressed: () {
                  // Lógica para aplicar el cupón
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
