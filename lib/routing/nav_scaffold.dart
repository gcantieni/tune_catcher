import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavScaffold extends StatelessWidget {
  final Widget child;

  const NavScaffold({required this.child, super.key});

  static const List<String> _bottomNavigationRoutes = [
    '/set_list',
    '/tune_list',
    '/recording_list',
    '/recorder',
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
            ? 3 // recorder should be the "quick draw" for the app
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
            icon: Icon(Icons.audio_file_outlined),
            label: 'Recordings',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.mic), label: 'Record'),
        ],
      ),
    );
  }
}
