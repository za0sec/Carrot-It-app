import 'package:carrot/front/pages/homepage/Motivation.dart';
import 'package:flutter/material.dart';
import '../../../back/Person.dart';
import '../../../src/providers/push_notifications_provider.dart';
import 'Carrots.dart';
import 'Profile/Profile.dart';

class HomePage extends StatefulWidget {
  final Person person;

  const HomePage({super.key, required this.person});

  @override
  State<HomePage> createState() => _MotivationalState();
}

class _MotivationalState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();

  late List<Widget> pages;

  int _selectedIndex = 0;

  late PushNotification pushNotification;

  @override
  void initState() {
    super.initState();
    // Inicializar PushNotification
    pushNotification = PushNotification(widget.person);
    pushNotification.initNotifications();

    pages = [
      Motivation(person: widget.person),
      Carrots(person: widget.person),
      Profile(person: widget.person),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Configurar el manejador para cuando se abra la app desde una notificación
    pushNotification.setOnMessageOpenedApp(context);
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
            icon: ImageIcon(
                AssetImage('lib/front/assets/icons/zanahoria_color.png')),
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
