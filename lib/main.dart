import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tune_catcher/routing/app_router.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    final colorScheme = ColorScheme.fromSeed(
      contrastLevel: 0.75,
      seedColor: Colors.deepPurple,
      brightness: brightness,
    );

    return MaterialApp.router(
      title: 'Tune Catcher',
      theme: ThemeData(
        colorScheme: colorScheme,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: colorScheme.secondary,
          unselectedItemColor: colorScheme.secondaryContainer,
        ),
      ),
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
