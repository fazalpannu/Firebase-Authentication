import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase/firebase_services/splash_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

class spalashscreen extends StatefulWidget {
  const spalashscreen({super.key});

  @override
  State<spalashscreen> createState() => _loginscreenState();
}

class _loginscreenState extends State<spalashscreen> {
  SplashServices _splashServices = SplashServices();

  @override
  void initState() {
    // TODO: implement initState

    _splashServices.login(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Splash',
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 250.0,
            child: TextLiquidFill(
              text: 'Firebase-Toturials',
              waveColor: Colors.black,
              boxBackgroundColor: Colors.white,
              textStyle: TextStyle(
                fontSize: 30.0,
                fontFamily: 'DancingScript',
                fontWeight: FontWeight.bold,
              ),
              boxHeight: 300.0,
            ),
          ),
        ),
      ),
    );
  }
}
