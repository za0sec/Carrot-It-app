import 'package:carrot/back/network/NetworkUtility.dart';
import 'package:carrot/back/person/Person.dart';
import 'package:carrot/front/pages/homepage/motivation/widgets/gym/gymDone/widgets/NotDay.dart';
import 'package:carrot/front/pages/homepage/motivation/widgets/gym/gymPage/GymPage.dart';
import 'package:carrot/front/pages/homepage/motivation/widgets/gym/utilities/GymMap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class YesDay extends StatefulWidget {
  final Person person;

  const YesDay({Key? key, required this.person}) : super(key: key);

  @override
  _YesDayState createState() => _YesDayState();
}

String apiKey = dotenv.env['GOOGLE_API_KEY']!;
late LatLng? location;

class _YesDayState extends State<YesDay> {
  @override
  void initState() {
    location = widget.person.coords;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: Text(
                    'Are you at your gym?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFfb901c),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    _handleCheckIn();
                  },
                  child: Text('Check in!'),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: 100.0), // Ajusta este valor a tus necesidades
            child: ElevatedButton(
              onPressed: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GymPage(
                      person: widget.person,
                    ),
                  ),
                );
              },
              child: Text('Change gym'),
            ),
          ),
        ),
      ],
    );
  }

  void _handleCheckIn() async {
    print(widget.person.coords);
    try {
      Position posicionActual = await _determinePosition();
      LatLng ubicacionObjetivo = widget.person.coords!;
      if (_isInLocation(posicionActual, ubicacionObjetivo, 100)) {
        print("Estás cerca de la ubicación objetivo!");
        widget.person.addCarrotsGym();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => NotDay(
                    person: widget.person,
                  )),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No gym nearby detected. Please only check in when you are at the gym.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
        print("No estás cerca de la ubicación objetivo.");
      }
    } catch (e) {
      // Manejar errores (servicios de ubicación desactivados, permisos denegados, etc.)
      print(e);
    }
  }
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
