import 'package:flutter/material.dart';
import 'package:tune_catcher/home.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tune Catcher',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 204, 95),
        ),
      ),
      home: const MyHomePage(title: 'Tune Catcher'),
    );
  }
}
