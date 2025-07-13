import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';

import 'package:drift/drift.dart' as drift;
import 'package:tune_catcher/model/accessors/tune_dao.dart';
import 'package:tune_catcher/model/database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(
      drift.DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
  });
  tearDown(() async {
    await db.close();
  });

  // Unit Tests
  test('tuneDao.insertTune', () async {
    final tuneDao = TuneDao(db);

    final name = 'test tune';
    final genre = 'irish';
    final id = await tuneDao.insertTune(
      TunesCompanion(
        name: drift.Value(name),
        createdAt: drift.Value(DateTime.now()),
        genre: drift.Value(genre),
      ),
    );
    final tune = await tuneDao.getTune(id);

    expect(tune != null, true);
    expect(tune?.name, name);
    expect(tune?.genre, genre);
    expect(tune?.createdAt.isBefore(DateTime.now()), true);
  });

  test('tuneDao.watchTune', () async {
    final tuneDao = TuneDao(db);

    final name = 'test tune';
    final genre = 'irish';

    final id = await tuneDao.insertTune(
      TunesCompanion(
        name: drift.Value(name),
        createdAt: drift.Value(DateTime.now()),
        genre: drift.Value(genre),
      ),
    );

    final tuneStream = tuneDao.watchTune(id); // to reactively read later

    // read from stream
    expectLater(
      tuneStream,
      emitsInOrder([
        isA<Tune>().having((t) => t.genre, 'genre', genre),
        isA<Tune>().having((t) => t.genre, 'genre', 'contra'),
      ]),
    );
    // await Future.delayed(Duration(milliseconds: 10));

    // make an update
    await tuneDao.updateTune(
      TunesCompanion(id: drift.Value(id), genre: drift.Value('contra')),
    );
  });
}
