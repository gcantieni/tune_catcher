import 'package:drift/drift.dart';

import 'package:tune_catcher/model/database.dart';
import 'package:tune_catcher/model/tables/tune_recording.dart';
import 'package:tune_catcher/model/tables/tunes.dart';

part 'tune_recording_dao.g.dart';

@DriftAccessor(tables: [TuneRecording, Tunes])
class TuneRecordingDao extends DatabaseAccessor<AppDatabase>
    with _$TuneRecordingDaoMixin {
  TuneRecordingDao(AppDatabase db) : super(db);

  Future<int> linkTuneToRecording(int tuneId, int recordingId) {
    return into(tuneRecording).insert(
      TuneRecordingCompanion.insert(tuneId: tuneId, recordingId: recordingId),
    );
  }

  /// Insert a new tune and link it to the recording in a single transaction.
  Future<int> createTuneAndLink(TunesCompanion tune, int recordingId) {
    return transaction(() async {
      final tuneId = await into(tunes).insert(tune);
      await into(tuneRecording).insert(
        TuneRecordingCompanion.insert(
          tuneId: tuneId,
          recordingId: recordingId,
        ),
      );
      return tuneId;
    });
  }

  Stream<List<Tune>> watchTunesForRecording(int recordingId) {
    final query = select(tunes).join([
      innerJoin(tuneRecording, tuneRecording.tuneId.equalsExp(tunes.id)),
    ])..where(tuneRecording.recordingId.equals(recordingId));
    return query.watch().map(
      (rows) => rows.map((row) => row.readTable(tunes)).toList(),
    );
  }
}
