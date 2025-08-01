import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';

import 'package:drift/drift.dart' as drift;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tune_catcher/model/accessors/tune_dao.dart';
import 'package:tune_catcher/model/database.dart';
import 'package:tune_catcher/model/database_provider.dart';
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

  test('allTunesProvider', () async {
    final tuneDao = TuneDao(db);

    final tunesHistory = <AsyncValue<List<Tune>>>[];
    final sub = container.listen<AsyncValue<List<Tune>>>(
      allTunesProvider,
      (previous, next) => tunesHistory.add(next), // insert list to history
      fireImmediately: true, // get an empty entry
    );

    final id1 = await tuneDao.insertTune(
      TunesCompanion(
        name: drift.Value('test tune'),
        createdAt: drift.Value(DateTime.now()),
        genre: drift.Value('irish'),
      ),
    );

    final id2 = await tuneDao.insertTune(
      TunesCompanion(
        name: drift.Value('test tune'),
        createdAt: drift.Value(DateTime.now()),
        genre: drift.Value('irish'),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 10));

    expect(
      tunesHistory.length,
      greaterThanOrEqualTo(3),
      reason: 'should have [], [id1], [id1, id2] in final result',
    );
    expect(tunesHistory[0].value?.length ?? 0, equals(0));

    expect(tunesHistory[1].value?.length, equals(1));
    expect(tunesHistory[1].value?[0].id, equals(id1));

    expect(tunesHistory[2].value?.length, equals(2));
    expect(tunesHistory[2].value?[0].id, equals(id1));
    expect(tunesHistory[2].value?[1].id, equals(id2));

    // cleanup
    sub.close();
  });
}
