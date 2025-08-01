import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database.dart';
import '../database_provider.dart';

final allRecordingsProvider = StreamProvider<List<Recording>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.recordingDao.watchAllRecordings();
});

final singleRecordingProvider = StreamProvider.family<Recording?, int>((
  ref,
  id,
) {
  final db = ref.watch(databaseProvider);
  return db.recordingDao.watchRecording(id);
});
