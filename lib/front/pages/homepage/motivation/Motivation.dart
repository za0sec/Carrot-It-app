import 'package:carrot/front/pages/homepage/motivation/widgets/gym/gymPage/Gym.dart';
import 'package:carrot/front/pages/homepage/motivation/widgets/pills/Pills.dart';
import 'package:carrot/front/pages/homepage/motivation/widgets/comingSoon/Soon.dart';
import 'package:flutter/material.dart';

import '../../../../back/person/Person.dart';
import '../profile/SettingsScreen.dart';

class Motivation extends StatefulWidget {
  final Person person;

  const Motivation({super.key, required this.person});

  @override
  State<Motivation> createState() => _State();
}

class _State extends State<Motivation> {
  late List boxContent;

  @override
  void initState() {
    super.initState();
    boxContent = [
      Pills(person: widget.person),
      Gym(person: widget.person),
      Soon(),
      Soon(),
      Soon(),
      Soon(),
      Soon(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Motivation'),
        automaticallyImplyLeading: false,
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
      endDrawer: SettingsScreen(person: widget.person),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'Games',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: Color(0xFFfb901c),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(
                  10.0), // Agrega espaciado alrededor de la cuadrícula
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 3 / 3,
                ),
                itemCount: 7,
                itemBuilder: (context, index) {
                  return boxContent[index];
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
