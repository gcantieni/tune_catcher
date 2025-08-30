import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tune_catcher/model/providers/sort_provider.dart';

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

final sortedRecordingsProvider = Provider<List<Recording>>((ref) {
  final recordingsAsync = ref.watch(allRecordingsProvider);
  final sort = ref.watch(sortProvider);

  return recordingsAsync.maybeWhen(
    data: (list) {
      final copy = [...list];
      switch (sort) {
        case Sort.createdAsc:
          copy.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          break;
        case Sort.createdDesc:
          copy.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          break;
      }
      return copy;
    },
    orElse: () => [],
  );
});
