import 'package:flutter/material.dart';
import 'package:weatherapp/src/app.dart';
import 'src/app.dart';
import 'src/splashscreen.dart';

void main() {
  runApp(App());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: splashscreen(),
    );
  }
}
