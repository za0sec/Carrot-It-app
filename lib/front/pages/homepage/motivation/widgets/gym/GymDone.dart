import 'package:carrot/back/network/NetworkUtility.dart';
import 'package:carrot/front/pages/homepage/motivation/widgets/gym/GymPage.dart';
import 'package:carrot/front/pages/homepage/motivation/widgets/gym/utilities/GymMap.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../../../back/person/Person.dart';

class GymDone extends StatefulWidget {
  final Person person;
  const GymDone({super.key, required this.person});

  @override
  State<GymDone> createState() => _GymDoneState();
}

String apiKey = dotenv.env['GOOGLE_API_KEY']!;
late LatLng? location;

class _GymDoneState extends State<GymDone> {
  @override
  void initState() {
    location = widget.person.coords;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gym'),
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Text(
                  'Your actual selected gym is\n${widget.person.gym}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFfb901c),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Every ${widget.person.getSelectedDaysString()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFfb901c),
                  ),
                ),
              ),
              SizedBox(height: 50),
              GymMap(
                centerFuture: NetworkUtility.getCoordenates(widget.person.gym!),
                userLocation: location,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GymPage(person: widget.person),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  textStyle: TextStyle(fontSize: 20),
                ),
                child: Text(
                  'Modify week',
                  style: TextStyle(
                    color: Color(0xFFfb901c),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  print(widget.person.coords);

                  try {
                    Position posicionActual = await _determinePosition();
                    LatLng ubicacionObjetivo = widget.person.coords!;
                    if (_isInLocation(posicionActual, ubicacionObjetivo, 100)) {
                      // El usuario está cerca de la ubicación objetivo
                      print("Estás cerca de la ubicación objetivo!");
                    } else {
                      // El usuario no está cerca
                      print("No estás cerca de la ubicación objetivo.");
                    }
                  } catch (e) {
                    // Manejar errores (servicios de ubicación desactivados, permisos denegados, etc.)
                    print(e);
                  }
                },
                child: Text('Comprobar ubicación'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verifica si los servicios de ubicación están habilitados
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Los servicios de ubicación están desactivados.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Los permisos de ubicación fueron denegados');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Los permisos de ubicación están permanentemente denegados, no podemos solicitar permisos.');
    }

    return await Geolocator.getCurrentPosition();
  }

  double _checkDisctance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  bool _isInLocation(
      Position posicionActual, LatLng ubicacionObjetivo, double umbralMetros) {
    double distancia = _checkDisctance(
      posicionActual.latitude,
      posicionActual.longitude,
      ubicacionObjetivo.latitude,
      ubicacionObjetivo.longitude,
    );
    return distancia <= umbralMetros;
  }
}
