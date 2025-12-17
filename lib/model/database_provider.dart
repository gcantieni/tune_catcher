import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tune_catcher/model/database.dart'; // for AppDatabase and TuneDao

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase(); // or your actual DB initializer
});
