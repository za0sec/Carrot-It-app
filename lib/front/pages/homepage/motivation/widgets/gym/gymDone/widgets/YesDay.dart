import 'dart:io';

import 'package:carrot/back/network/NetworkService.dart';
import 'package:carrot/back/network/NetworkUtility.dart';
import 'package:carrot/back/person/Person.dart';
import 'package:carrot/front/pages/homepage/motivation/widgets/gym/gymDone/GymDone.dart';
import 'package:carrot/front/pages/homepage/motivation/widgets/gym/gymDone/widgets/LoadingPage.dart';
import 'package:carrot/front/pages/homepage/motivation/widgets/gym/gymPage/GymPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as Path;

class YesDay extends StatefulWidget {
  final Person person;

  const YesDay({Key? key, required this.person}) : super(key: key);

  @override
  _YesDayState createState() => _YesDayState();
}

String apiKey = dotenv.env['GOOGLE_API_KEY']!;
late LatLng? location;

class _YesDayState extends State<YesDay> {
  bool _isLoading = false;

  @override
  void initState() {
    location = widget.person.coords;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _isLoading
            ? Center(child: LoadingScreen())
            : SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'What\'ll happen when Check-in button is pressed?',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFfb901c),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            Text(
                              '1. We\'ll check if your location matches the gym\'s.\n'
                              '2. You\'ll need to take a photo of yourself exercising.\n'
                              '3. If our AI confirms your exercise, you\'ll earn your reward!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                await _handleCheckIn();
                              },
                              child: Text('Check in!'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 100.0),
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

  Future<void> _handleCheckIn() async {
    print(widget.person.coords);
    try {
      Position posicionActual = await _determinePosition();
      LatLng ubicacionObjetivo = widget.person.coords!;
      if (_isInLocation(posicionActual, ubicacionObjetivo, 100)) {
        final image = await _takeImage();
        setState(() {
          _isLoading = true;
        });
        final sendImageResult = await NetworkService.sendImage(image);
        if (sendImageResult) {
          print('Imagen es de ejercicio!!');
          widget.person.gymDate = await NetworkUtility.getCurrentDate();
          widget.person.addCarrotsGym();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Great! You have checked in. +20 Carrots!',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ),
          );
          widget.person.incrementGymStreak();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => GymDone(
                      person: widget.person,
                    )),
          );
        } else {
          print('Imagen no es de ejercicio :(');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'No Exercise Detected. Please try again.',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
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
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

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

  Future<String> _takeImage() async {
    try {
      ImagePicker picker = ImagePicker();
      XFile? photo = await picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        final File image = File(photo.path);
        final directory = await getApplicationDocumentsDirectory();
        const name = 'gptSend.jpeg';
        final imageFile = await image.copy('${directory.path}/$name');
        print('aca');
        final imagePath = imageFile.path;

        Directory tempDir =
            await getTemporaryDirectory().timeout(Duration(seconds: 20));
        print('otro aqui');
        String tempPath = tempDir.path;
        String fileName = Path.basename(imagePath);
        String targetPath = "$tempPath/compressed_$fileName";

        print('antes de comprimir');
        File compressedImage = await compressImage(File(imagePath), targetPath)
            .timeout(Duration(seconds: 20));
        print('despues de comprimir');

        return compressedImage.path;
      } else {
        throw Exception('No se seleccionó ninguna imagen.');
      }
    } catch (e) {
      print('Error al capturar imagen: $e');
    }
    return '';
  }

  Future<File> compressImage(File file, String targetPath) async {
    try {
      var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 88,
        rotate: 0,
      );

      if (result != null) {
        return File(result.path); // Convierte XFile a File
      } else {
        throw Exception('La imagen no se pudo comprimir, resultado nulo.');
      }
    } catch (e) {
      print('Error al comprimir la imagen: $e');
      if (e is CompressError) {
        print('Detalles del error de compresión: ${e.message}');
      }
      rethrow; // Vuelve a lanzar la excepción para manejarla más arriba en la pila.
    }
  }
}
