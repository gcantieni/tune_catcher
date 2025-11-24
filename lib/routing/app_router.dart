import 'package:go_router/go_router.dart';

import 'package:tune_catcher/feat/recorder/recorder_page.dart';
import 'package:tune_catcher/feat/recording_list/recording_list_page.dart';
import 'package:tune_catcher/feat/set_list/set_list_page.dart';
import 'package:tune_catcher/feat/tune_list/tune_list_page.dart';
import 'package:tune_catcher/routing/nav_scaffold.dart';

final GoRouter router = GoRouter(
  initialLocation: '/recorder', // recording should be the app's "quick draw"
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return NavScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/set_list',
          name: 'set_list',
          builder: (context, state) => SetListPage(),
        ),
        GoRoute(
          path: '/tune_list',
          name: 'tune_list',
          builder: (context, state) => TuneListPage(),
        ),
        GoRoute(
          path: '/recording_list',
          name: 'recording_list',
          builder: (context, state) => RecordingListPage(),
        ),
        GoRoute(
          path: '/recorder',
          name: 'recorder',
          builder: (context, state) => RecorderPage(),
        ),
      ],
    ),
  ],
);
