import 'package:carrot/front/pages/homepage/motivation/Motivation.dart';
import 'package:carrot/front/pages/homepage/motivation/widgets/pills/Counter.dart';
import 'package:flutter/material.dart';
import '../../../back/person/Person.dart';
import '../../../src/providers/push_notifications_provider.dart';
import 'carrots/CarrotsPage.dart';
import 'profile/ProfilePage.dart';

class HomePage extends StatefulWidget {
  final Person person;

  const HomePage({super.key, required this.person});

  @override
  State<HomePage> createState() => _MotivationalState();
}

class _MotivationalState extends State<HomePage> with WidgetsBindingObserver {
  final TextEditingController _nameController = TextEditingController();

  late List<Widget> pages;

  int _selectedIndex = 0;

  late PushNotification pushNotification;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
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
    WidgetsBinding.instance!.removeObserver(this);
    _nameController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _redirectIfNecessary();
    }
  }

  void _redirectIfNecessary() {
    if (widget.person.time != null) {
      TimeOfDay horaInicio = widget.person.time!;
      TimeOfDay horaFin = addMinutes(widget.person.time!, 5);

      TimeOfDay ahora = TimeOfDay.now();

      if (_belongsToRange(ahora, horaInicio, horaFin) &&
          !_isSameDate(
              widget.person.lastDate != null
                  ? widget.person.lastDate!
                  : DateTime.now(),
              DateTime.now())) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Counter(
                    person: widget.person,
                    startTimerOnLoad: true,
                  )),
        );
      }
    }
  }

  bool _isSameDate(DateTime day1, DateTime day2) {
    return day1.year == day2.year &&
        day1.month == day2.month &&
        day1.day == day2.day;
  }

  TimeOfDay addMinutes(TimeOfDay time, int minutes) {
    int totalMinutes = time.hour * 60 + time.minute + minutes;
    int newHour = totalMinutes ~/ 60;
    int newMinute = totalMinutes % 60;

    // Ajusta las horas si sobrepasan las 24 horas
    if (newHour >= 24) {
      newHour = newHour % 24;
    }

    return TimeOfDay(hour: newHour, minute: newMinute);
  }

  bool _belongsToRange(TimeOfDay now, TimeOfDay start, TimeOfDay end) {
    final nowMinutes = now.hour * 60 + now.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    return nowMinutes >= startMinutes && nowMinutes <= endMinutes;
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
