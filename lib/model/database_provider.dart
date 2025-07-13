import 'package:flutter_riverpod/flutter_riverpod.dart';

import './database.dart'; // for AppDatabase and TuneDao

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase(); // or your actual DB initializer
});
