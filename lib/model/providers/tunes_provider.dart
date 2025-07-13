import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database.dart';
import '../database_provider.dart';

final allTunesStreamProvider = StreamProvider<List<Tune>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.tuneDao.watchAllTunes();
});

final singleTuneProvider = StreamProvider.family<Tune?, int>((ref, id) {
  final db = ref.watch(databaseProvider);
  return db.tuneDao.watchTune(id);
});
