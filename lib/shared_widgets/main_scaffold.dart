import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({required this.child, super.key});

  static const List<String> _bottomNavigationRoutes = [
    '/set_list',
    '/tune_list',
    '/recorder',
    '/recording_list',
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    final currentIndex = _bottomNavigationRoutes.indexWhere(
      (r) => location.startsWith(r),
    );

    return Scaffold(
      body: child, // Will contain composed page content
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex < 0
            ? 1 // default to tunes, could be some "favorite" in the future
            : currentIndex,
        onTap: (index) {
          if (_bottomNavigationRoutes[index] != location) {
            context.go(_bottomNavigationRoutes[index]); // skip home
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.queue_music), label: "Sets"),
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'Tunes'),
          BottomNavigationBarItem(
            icon: Icon(Icons.audio_file),
            label: 'Recordings',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.mic), label: 'Record'),
        ],
      ),
    );
  }
}
