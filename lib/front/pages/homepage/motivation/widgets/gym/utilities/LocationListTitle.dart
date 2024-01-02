import 'package:flutter/material.dart';

class LocationListTile extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const LocationListTile({
    Key? key,
    required this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(
          'Detalles adicionales aquí'), // Asumiendo que hay más detalles para mostrar
      leading: Icon(Icons.location_on), // Icono representativo de una ubicación
      trailing:
          Icon(Icons.arrow_forward), // Icono para indicar acción de navegación
      onTap: onTap, // Callback para manejar el evento de tap
    );
  }
}
