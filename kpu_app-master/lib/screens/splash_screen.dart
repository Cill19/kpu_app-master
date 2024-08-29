import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kpu_app/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).padding.top;
    final size = MediaQuery.of(context).size.height;
    final appSize = size - paddingTop;
    return Scaffold(
      body: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: size * 0.35,
                height: size * 0.35,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/splash_image.png'))),
              ),
              Text(
                "KPU APP",
                style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontSize: 32.0,
                    fontWeight: FontWeight.w600),
              ),
            ]),
      ),
    );
  }
}