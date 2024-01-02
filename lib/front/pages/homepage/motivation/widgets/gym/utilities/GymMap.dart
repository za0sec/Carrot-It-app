import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GymMap extends StatelessWidget {
  final Future<LatLng?> centerFuture;
  final LatLng? userLocation; // Ubicación actual del usuario
  final Color markerColor;

  const GymMap({
    Key? key,
    required this.centerFuture,
    this.userLocation, // Añadir esto
    this.markerColor = const Color(0xFFfb901c),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LatLng?>(
      future: centerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.data != null) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: 200, // Altura fija
              width: double.infinity,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: snapshot.data!,
                  zoom: 14.5,
                ),
                markers: {
                  if (userLocation !=
                      null) // Verificar si la ubicación del usuario está disponible
                    Marker(
                      markerId: MarkerId('userMarker'),
                      position: userLocation!,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor
                            .hueAzure, // Color diferente para el marcador del usuario
                      ),
                    ),
                  Marker(
                    markerId: MarkerId('centerMarker'),
                    position: snapshot.data!,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      _getMarkerColorHue(markerColor),
                    ),
                  ),
                },
              ),
            ),
          );
        } else {
          // Si LatLng es nulo
          return Text('Ubicación no disponible');
        }
      },
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    // Aquí se pueden realizar configuraciones adicionales del mapa
  }

  double _getMarkerColorHue(Color color) {
    // Convertir el color a un tono utilizable por Google Maps
    return BitmapDescriptor.hueRed; // Ajustar según el color deseado
  }
}
