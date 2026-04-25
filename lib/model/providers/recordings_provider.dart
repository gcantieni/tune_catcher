import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tune_catcher/model/database.dart';
import 'package:tune_catcher/model/database_provider.dart';

final allRecordingsProvider = StreamProvider.autoDispose<List<Recording>>((
  ref,
) {
  final db = ref.watch(databaseProvider);
  return db.recordingDao.watchAllRecordings();
});

final singleRecordingProvider = StreamProvider.family
    .autoDispose<Recording?, int>((ref, id) {
      final db = ref.watch(databaseProvider);
      return db.recordingDao.watchRecording(id);
    });
