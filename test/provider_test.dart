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
}
