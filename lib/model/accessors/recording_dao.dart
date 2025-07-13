import 'package:drift/drift.dart';
import 'package:tune_catcher/model/tables/recordings.dart';
import 'package:tune_catcher/model/database.dart';

part 'recording_dao.g.dart';

@DriftAccessor(tables: [Recordings])
class RecordingDao extends DatabaseAccessor<AppDatabase>
    with _$RecordingDaoMixin {
  RecordingDao(AppDatabase db) : super(db);

  // create
  Future insertRecording(RecordingsCompanion recording) =>
      into(recordings).insert(recording);

  // read static
  Future<List<Recording>> getAll() => select(recordings).get();
  Future<Recording?> getRecording(int id) =>
      (select(recordings)..where((r) => r.id.equals(id))).getSingleOrNull();

  // read reactive
  Stream<List<Recording>> watchAllRecordings() => select(recordings).watch();
  Stream<Recording?> watchRecording(int id) =>
      (select(recordings)..where((r) => r.id.equals(id))).watchSingleOrNull();

  // update
  Future<int> updateRecording(Recording updatedRecording) {
    return (update(
      recordings,
    )..where((t) => t.id.equals(updatedRecording.id))).write(
      updatedRecording.toCompanion(
        true,
      ), // coalesces Recording into RecordingCompanion
    );
  }

  // delete
  Future deleteRecording(int id) =>
      (delete(recordings)..where((r) => r.id.equals(id))).go();
}
