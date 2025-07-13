import 'package:drift/drift.dart';
import 'package:tune_catcher/model/tables/tunes.dart';
import 'package:tune_catcher/model/database.dart';

part 'tune_dao.g.dart';

@DriftAccessor(tables: [Tunes])
class TuneDao extends DatabaseAccessor<AppDatabase> with _$TuneDaoMixin {
  TuneDao(AppDatabase db) : super(db);

  // create
  Future<int> insertTune(TunesCompanion tune) => into(tunes).insert(tune);

  // read static
  Future<List<Tune>> getAll() => select(tunes).get();
  Future<Tune?> getTune(int id) =>
      (select(tunes)..where((t) => t.id.equals(id))).getSingleOrNull();

  // read reactive
  Stream<List<Tune>> watchAllTunes() => select(tunes).watch();
  Stream<Tune?> watchTune(int id) =>
      (select(tunes)..where((t) => t.id.equals(id))).watchSingleOrNull();

  // update
  Future<int> updateTune(TunesCompanion updatedTune) => (update(
    tunes,
  )..where((t) => t.id.equals(updatedTune.id.value))).write(updatedTune);

  // delete
  Future deleteTune(int id) =>
      (delete(tunes)..where((t) => t.id.equals(id))).go();
}
