import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PlaceholderPage extends StatelessWidget {
  final String name;
  const PlaceholderPage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Center(child: Text(
        name,
        style: const TextStyle(
          fontSize: 20,
        )
      )),
    );
  }
}
