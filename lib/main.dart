import 'package:cars_appointments/Screens/Splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home:   const SplashScreen(),
    );
  }
}