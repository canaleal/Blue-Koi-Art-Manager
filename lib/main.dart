import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test_bed/screens/splash/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);


    return MaterialApp(
      title: 'FlutterFire Samples',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Muli',
        primarySwatch: Colors.indigo,
        brightness: Brightness.light,
      ),
      home: const SplashScreen(),
    );
  }
}

