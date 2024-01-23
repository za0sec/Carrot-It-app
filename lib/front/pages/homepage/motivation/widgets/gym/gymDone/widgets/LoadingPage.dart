import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController textController;
  late AnimationController logoAnimationController;
  late Animation<double> logoAnimation;

  @override
  void initState() {
    super.initState();
    textController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..forward();

    logoAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    logoAnimation = Tween<double>(begin: 60, end: 150).animate(
      CurvedAnimation(
        parent: logoAnimationController,
        curve: Curves.easeInOut,
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          logoAnimationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          logoAnimationController.forward();
        }
      });

    logoAnimationController.forward();
  }

  @override
  void dispose() {
    textController.dispose();
    logoAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Logo con Animación
            AnimatedBuilder(
              animation: logoAnimation,
              builder: (context, child) {
                return ImageIcon(
                  AssetImage('lib/front/assets/images/Carrot.png'),
                  color: Color(0xFFfb901c),
                  size: logoAnimation.value,
                );
              },
            ),
            SizedBox(height: 70),
            // Texto Motivacional
            AnimatedBuilder(
              animation: textController,
              builder: (BuildContext context, Widget? child) {
                String text = "AI is checking if you are exercising...";
                int length = (textController.value * text.length).toInt();
                return Text(
                  text.substring(0, length),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            // Barra de Progreso en bucle
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: 50), // Ajusta este margen según tus necesidades
              child: LinearProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
