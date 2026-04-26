import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tune_catcher/model/database.dart';
import 'package:tune_catcher/model/database_provider.dart';

final tunesForRecordingProvider = StreamProvider.family
    .autoDispose<List<Tune>, int>((ref, recordingId) {
      final db = ref.watch(databaseProvider);
      return db.tuneRecordingDao.watchTunesForRecording(recordingId);
    });
