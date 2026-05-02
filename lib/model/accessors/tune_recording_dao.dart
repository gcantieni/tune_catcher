import 'package:drift/drift.dart';

import 'package:tune_catcher/model/database.dart';
import 'package:tune_catcher/model/tables/recordings.dart';
import 'package:tune_catcher/model/tables/tune_recording.dart';
import 'package:tune_catcher/model/tables/tunes.dart';

part 'tune_recording_dao.g.dart';

/// A row of `tune_recording` joined with its referenced tune.
typedef RecordedTune = ({Tune tune, TuneRecordingData link});

/// A row of `tune_recording` joined with its referenced recording.
typedef LinkedRecording = ({Recording recording, TuneRecordingData link});

@DriftAccessor(tables: [TuneRecording, Tunes, Recordings])
class TuneRecordingDao extends DatabaseAccessor<AppDatabase>
    with _$TuneRecordingDaoMixin {
  TuneRecordingDao(AppDatabase db) : super(db);

  /// Re-linking the same (tune, recording) pair is a silent no-op
  /// thanks to the composite PK and insertOrIgnore mode.
  Future<int> linkTuneToRecording(int tuneId, int recordingId) {
    return into(tuneRecording).insert(
      TuneRecordingCompanion.insert(tuneId: tuneId, recordingId: recordingId),
      mode: InsertMode.insertOrIgnore,
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

  /// Insert a new recording and link it to the tune in a single transaction.
  Future<int> createRecordingAndLink(
    RecordingsCompanion recording,
    int tuneId,
  ) {
    return transaction(() async {
      final recordingId = await into(recordings).insert(recording);
      await into(tuneRecording).insert(
        TuneRecordingCompanion.insert(
          tuneId: tuneId,
          recordingId: recordingId,
        ),
      );
      return recordingId;
    });
  }

  Future<int> updateLink(TuneRecordingData updated) {
    return (update(tuneRecording)..where(
          (t) =>
              t.tuneId.equals(updated.tuneId) &
              t.recordingId.equals(updated.recordingId),
        ))
        .write(updated.toCompanion(true));
  }

  Future<int> unlinkTuneFromRecording(int tuneId, int recordingId) {
    return (delete(tuneRecording)..where(
          (t) => t.tuneId.equals(tuneId) & t.recordingId.equals(recordingId),
        ))
        .go();
  }

  Stream<List<RecordedTune>> watchLinksForRecording(int recordingId) {
    final query = select(tunes).join([
      innerJoin(tuneRecording, tuneRecording.tuneId.equalsExp(tunes.id)),
    ])..where(tuneRecording.recordingId.equals(recordingId));
    return query.watch().map(
      (rows) => rows
          .map(
            (row) => (
              tune: row.readTable(tunes),
              link: row.readTable(tuneRecording),
            ),
          )
          .toList(),
    );
  }

  Stream<List<LinkedRecording>> watchLinksForTune(int tuneId) {
    final query = select(recordings).join([
      innerJoin(
        tuneRecording,
        tuneRecording.recordingId.equalsExp(recordings.id),
      ),
    ])..where(tuneRecording.tuneId.equals(tuneId));
    return query.watch().map(
      (rows) => rows
          .map(
            (row) => (
              recording: row.readTable(recordings),
              link: row.readTable(tuneRecording),
            ),
          )
          .toList(),
    );
  }
}
