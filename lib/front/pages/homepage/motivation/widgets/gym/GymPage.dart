import 'package:carrot/back/network/NetworkService.dart';
import 'package:carrot/front/pages/homepage/motivation/widgets/gym/GymDone.dart';
import 'package:carrot/front/pages/homepage/motivation/widgets/gym/utilities/LocationListTitle.dart';
import 'package:carrot/back/network/NetworkUtility.dart';
import 'package:carrot/front/pages/homepage/motivation/widgets/gym/utilities/PlaceAutocompleteResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../../back/person/Person.dart';

class GymPage extends StatefulWidget {
  final Person person;
  const GymPage({super.key, required this.person});

  @override
  State<GymPage> createState() => _GymPageState();
}

const tPrimaryColor = Color(0xFFfb901c);

String apiKey = dotenv.env['GOOGLE_API_KEY']!;

class _GymPageState extends State<GymPage> {
  List<AutocompletePrediction> placePredictions = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedAddress = '';
  late List<bool> daysSelected;
  bool showCheckboxes = false;

  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    daysSelected = widget.person.daysOfWeekSelected ??
        [false, false, false, false, false, false, false];
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Gym'),
        automaticallyImplyLeading: false,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: ImageIcon(
                AssetImage('lib/front/assets/images/Carrot.png'),
                color: tPrimaryColor,
                size: 60,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          reverse: true,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(right: 20, left: 20, top: 50, bottom: 25),
                child: Text(
                  'Stay motivated and hit your weekly goals!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: tPrimaryColor,
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: showCheckboxes ? 0.0 : 1.0,
                duration: Duration(seconds: 1),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showCheckboxes = true;
                    });
                  },
                  child: Text('Seleccionar días'),
                ),
              ),
              AnimatedSize(
                duration:
                    Duration(seconds: 1), // Duración de la animación de tamaño
                child: ConstrainedBox(
                  constraints: showCheckboxes
                      ? BoxConstraints()
                      : BoxConstraints(maxHeight: 0.0),
                  child: Column(children: [
                    Divider(
                      color: tPrimaryColor,
                      height: 30,
                    ),
                    ...List.generate(
                      7,
                      (index) => CheckboxListTile(
                        activeColor: tPrimaryColor,
                        title: Text([
                          'Monday',
                          'Tuesday',
                          'Wednesday',
                          'Thursday',
                          'Friday',
                          'Sunday',
                          'Saturday'
                        ][index]),
                        value: daysSelected[index],
                        onChanged: (bool? value) {
                          setState(() {
                            daysSelected[index] = value!;
                          });
                        },
                      ),
                    ),
                    Divider(
                      color: tPrimaryColor,
                      height: 30,
                    ),
                  ]),
                ),
              ),
              AnimatedOpacity(
                opacity: showCheckboxes ? 1.0 : 0.0,
                duration: Duration(seconds: 1),
                child: ElevatedButton(
                  style: ButtonStyle(
                    alignment: Alignment.center,
                  ),
                  onPressed: _saveSelectedDays,
                  child: Text('Guardar'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  controller: _textController,
                  onChanged: (value) {
                    _placeAutocomplete(value);
                  },
                  decoration: InputDecoration(
                    labelText: 'Gym Address',
                    labelStyle: TextStyle(color: tPrimaryColor),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: tPrimaryColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: tPrimaryColor),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: tPrimaryColor),
                    ),
                    prefixIcon: Icon(Icons.location_on, color: tPrimaryColor),
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: placePredictions.length,
                itemBuilder: (context, index) {
                  final prediction = placePredictions[index];
                  return LocationListTile(
                    title: prediction.description!,
                    onTap: () {
                      setState(() {
                        selectedAddress = prediction.description!;
                        _textController.text = selectedAddress;
                        widget.person.gym = selectedAddress;
                        widget.person.setLocation();
                        widget.person.save();
                        print(selectedAddress);
                        placePredictions.clear();
                      });
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                  );
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  bool success = await NetworkService.saveGym(
                      widget.person.name,
                      widget.person.gym!,
                      widget.person.daysOfWeekSelected!);
                  if (success) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GymDone(person: widget.person),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Error in database...',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _placeAutocomplete(String query) async {
    Uri uri =
        Uri.https("maps.googleapis.com", 'maps/api/place/autocomplete/json', {
      "input": query,
      "key": apiKey,
    });
    String? response = await NetworkUtility.fetchUrl(uri);

    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResponse(response);
      if (result.predictions != null) {
        setState(() {
          placePredictions = result.predictions!;
        });
      }
    }
  }

  void _saveSelectedDays() {
    setState(() {
      widget.person.daysOfWeekSelected = daysSelected;
      widget.person.save();
      showCheckboxes = false;
      // Aquí puedes guardar la instancia de Person si es necesario
      // Por ejemplo: widget.person.save();
    });
  }
}
