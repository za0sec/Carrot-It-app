import 'package:carrot/back/network/NetworkUtility.dart';
import 'package:carrot/back/person/Person.dart';
import 'package:carrot/front/pages/homepage/motivation/widgets/gym/gymPage/GymPage.dart';
import 'package:carrot/front/pages/homepage/motivation/widgets/gym/utilities/GymMap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NotDay extends StatefulWidget {
  final Person person;

  const NotDay({Key? key, required this.person}) : super(key: key);

  @override
  _NotDayState createState() => _NotDayState();
}

String apiKey = dotenv.env['GOOGLE_API_KEY']!;
late LatLng? location;

class _NotDayState extends State<NotDay> {
  @override
  void initState() {
    location = widget.person.coords;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                'Every ${widget.person.getSelectedDaysString().join(', ')}',
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
          ],
        ),
      ),
    );
  }
}
