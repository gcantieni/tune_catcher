import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tune_catcher/model/accessors/tune_recording_dao.dart';
import 'package:tune_catcher/model/database_provider.dart';

final linksForRecordingProvider = StreamProvider.family
    .autoDispose<List<RecordedTune>, int>((ref, recordingId) {
      final db = ref.watch(databaseProvider);
      return db.tuneRecordingDao.watchLinksForRecording(recordingId);
    });

final recordingsForTuneProvider = StreamProvider.family
    .autoDispose<List<LinkedRecording>, int>((ref, tuneId) {
      final db = ref.watch(databaseProvider);
      return db.tuneRecordingDao.watchLinksForTune(tuneId);
    });
