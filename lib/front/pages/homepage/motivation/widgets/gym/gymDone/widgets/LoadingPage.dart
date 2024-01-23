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
      duration: const Duration(
          seconds:
              5), // Duración ajustada para el ciclo completo de escritura y borrado
      vsync: this,
    )..repeat(); // Cambiado a repeat para un ciclo continuo

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
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Logo con Animación en Container de Altura Fija
              Container(
                height: 150, // Altura fija para contener la animación del logo
                child: AnimatedBuilder(
                  animation: logoAnimation,
                  builder: (context, child) {
                    return Center(
                      child: ImageIcon(
                        AssetImage('lib/front/assets/images/Carrot.png'),
                        color: Color(0xFFfb901c),
                        size: logoAnimation.value,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              // Texto Motivacional con Efecto de Escritura y Borrado
              AnimatedBuilder(
                animation: textController,
                builder: (BuildContext context, Widget? child) {
                  String fullText = "AI is checking if you are exercising...";
                  int totalLength = fullText.length;
                  int animationValue =
                      (textController.value * totalLength * 2).round();
                  int startIndex = 0;
                  int endIndex;

                  if (animationValue < totalLength) {
                    endIndex = animationValue;
                  } else {
                    endIndex = totalLength - (animationValue - totalLength);
                  }

                  return Text(
                    fullText.substring(startIndex, endIndex),
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
                margin: EdgeInsets.symmetric(horizontal: 50),
                child: LinearProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
