import 'package:go_router/go_router.dart';
import 'package:tune_catcher/feat/home/home_page.dart';
import 'package:tune_catcher/feat/recorder/recorder_page.dart';
import 'package:tune_catcher/feat/recording_list/recording_list_page.dart';
import 'package:tune_catcher/feat/tune_list/tune_list_page.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/tune_list',
      name: 'tune_list',
      builder: (context, state) => TuneListPage(),
    ),
    GoRoute(
      path: '/recorder',
      name: 'recorder',
      builder: (context, state) => RecorderPage(),
    ),
    GoRoute(
      path: '/recording_list',
      name: 'recording_list',
      builder: (context, state) => RecordingListPage(),
    ),
  ],
);
