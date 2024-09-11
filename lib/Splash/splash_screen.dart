import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:news_app/Splash/pre_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(PageRouteBuilder(
          transitionDuration: Duration(seconds: 1),
          reverseTransitionDuration: Duration(seconds: 1),
          pageBuilder: (context, animation, secondaryAnimation) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Interval(0, 0.5),
            );
            return FadeTransition(
              opacity: curvedAnimation,
              child: PrePage(),
            );
          }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/Splash/splash.jpeg',
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0), // Adjust padding as needed
              child: SpinKitChasingDots(
                color: Colors.blue, // Change to your desired color
                size: 40, // Adjust the size as needed
              ),
            ),
          ),
        ],
      ),
    );
  }
}
