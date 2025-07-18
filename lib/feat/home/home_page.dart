import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Go to Tune List'),
            onTap: () => context.go('/tune_list'),
          ),
          ListTile(
            title: const Text('Go to Recorder'),
            onTap: () => context.go('/recorder'),
          ),
          ListTile(
            title: const Text('Go to Recording List'),
            onTap: () => context.go('/recording_list'),
          ),
        ],
      ),
    );
  }
}
