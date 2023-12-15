import 'package:carrot/front/pages/Motivation.dart';
import 'package:flutter/material.dart';
import '../../back/Person.dart';
import '../main.dart';
import 'Carrots.dart';
import 'Profile.dart';
import 'SettingsScreen.dart';

class HomePage extends StatefulWidget {
  final Person person;

  const HomePage({Key? key, required this.person}) : super(key: key);

  @override
  State<HomePage> createState() => _MotivationalState();
}

class _MotivationalState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();

  late List<Widget> pages;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Inicializar las páginas aquí
    pages = [
      Motivation(),
      Carrots(person: widget.person),
      Profile(person: widget.person),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Motivation',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('lib/front/assets/icons/zanahoria_color.png')),
            label: 'Carrots',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',

          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFFfb901c),
        onTap: _onItemTapped,
      ),
    );
  }
}