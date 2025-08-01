import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';

import 'package:drift/drift.dart' as drift;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tune_catcher/model/accessors/recording_dao.dart';
import 'package:tune_catcher/model/accessors/tune_dao.dart';
import 'package:tune_catcher/model/database.dart';
import 'package:tune_catcher/model/database_provider.dart';
import 'package:tune_catcher/model/providers/recordings_provider.dart';
import 'package:tune_catcher/model/providers/tunes_provider.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;

  setUp(() {
    db = AppDatabase(
      drift.DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
  });
  tearDown(() async {
    await db.close();
    container.dispose();
  });

  test('singleTuneProvider', () async {
    final tuneDao = TuneDao(db);

    final id = await tuneDao.insertTune(
      TunesCompanion(
        name: drift.Value('test tune'),
        createdAt: drift.Value(DateTime.now()),
        genre: drift.Value('irish'),
      ),
    );

    final emittedTunes = <AsyncValue<Tune?>>[];
    final sub = container.listen<AsyncValue<Tune?>>(
      singleTuneProvider(id),
      (previous, next) => emittedTunes.add(next), // insert items
    );

    // wait for first emit
    await Future.delayed(const Duration(milliseconds: 10));

    await tuneDao.updateTune(
      TunesCompanion(id: drift.Value(id), genre: drift.Value('contra')),
    );

    // wait for second emit
    await Future.delayed(const Duration(milliseconds: 10));

    expect(emittedTunes.length, greaterThanOrEqualTo(2));
    expect(emittedTunes[0].value?.genre, 'irish');
    expect(emittedTunes.last.value?.genre, 'contra');

    // cleanup
    sub.close();
  });

  test('singleRecordingProvider', () async {
    final recordingDao = RecordingDao(db);

    final id = await recordingDao.insertRecording(
      RecordingsCompanion(
        filePath: drift.Value('/tmp/file.wav'),
        createdAt: drift.Value(DateTime.now()),
      ),
    );

    final emittedRecordings = <AsyncValue<Recording?>>[];
    final sub = container.listen<AsyncValue<Recording?>>(
      singleRecordingProvider(id),
      (previous, next) => emittedRecordings.add(next), // insert items
    );

    // wait for first emit
    await Future.delayed(const Duration(milliseconds: 10));

    await recordingDao.updateRecording(
      RecordingsCompanion(
        id: drift.Value(id),
        filePath: drift.Value('/tmp/file2.wav'),
      ),
    );

    // wait for second emit
    await Future.delayed(const Duration(milliseconds: 10));

    expect(emittedRecordings.length, greaterThanOrEqualTo(2));
    expect(emittedRecordings[0].value?.filePath, '/tmp/file.wav');
    expect(emittedRecordings.last.value?.filePath, '/tmp/file2.wav');

    // cleanup
    sub.close();
  });

  test('allRecordingsProvider', () async {
    final recordingDao = RecordingDao(db);

    final recoringsHistory = <AsyncValue<List<Recording>>>[];
    final sub = container.listen<AsyncValue<List<Recording>>>(
      allRecordingsProvider,
      (previous, next) => recoringsHistory.add(next), // insert list to history
      fireImmediately: true, // get an empty entry
    );

    final id1 = await recordingDao.insertRecording(
      RecordingsCompanion(
        filePath: drift.Value('/tmp/id1'),
        createdAt: drift.Value(DateTime.now()),
      ),
    );

    final id2 = await recordingDao.insertRecording(
      RecordingsCompanion(
        filePath: drift.Value('/tmp/id2'),
        createdAt: drift.Value(DateTime.now()),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 10));

    expect(
      recoringsHistory.length,
      greaterThanOrEqualTo(3),
      reason: 'should have [], [id1], [id1, id2] in final result',
    );
    expect(recoringsHistory[0].value?.length ?? 0, equals(0));

    expect(recoringsHistory[1].value?.length, equals(1));
    expect(recoringsHistory[1].value?[0].id, equals(id1));

    expect(recoringsHistory[2].value?.length, equals(2));
    expect(recoringsHistory[2].value?[0].id, equals(id1));
    expect(recoringsHistory[2].value?[1].id, equals(id2));

    // cleanup
    sub.close();
  });
}
