import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tune_trove/model/database.dart';
import 'package:tune_trove/model/database_provider.dart';

final allTunesProvider = StreamProvider.autoDispose<List<Tune>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.tuneDao.watchAllTunes();
});

final singleTuneProvider = StreamProvider.family.autoDispose<Tune?, int>((
  ref,
  id,
) {
  final db = ref.watch(databaseProvider);
  return db.tuneDao.watchTune(id);
});
