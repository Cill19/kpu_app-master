import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:kpu_app/screens/splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();  // Menjamin binding Flutter sudah siap
  await Firebase.initializeApp();  // Inisialisasi Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}