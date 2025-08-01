import 'package:drift/drift.dart';

import '../tables/recordings.dart';
import '../database.dart';

part 'recording_dao.g.dart';

@DriftAccessor(tables: [Recordings])
class RecordingDao extends DatabaseAccessor<AppDatabase>
    with _$RecordingDaoMixin {
  RecordingDao(AppDatabase db) : super(db);

  // create
  Future<int> insertRecording(RecordingsCompanion recording) =>
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
  Future<int> updateRecording(RecordingsCompanion updatedRecording) {
    return (update(recordings)
          ..where((t) => t.id.equals(updatedRecording.id.value)))
        .write(updatedRecording);
  }

  // delete
  Future deleteRecording(int id) =>
      (delete(recordings)..where((r) => r.id.equals(id))).go();
}
