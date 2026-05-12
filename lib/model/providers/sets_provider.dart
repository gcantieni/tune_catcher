import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tune_catcher/model/accessors/set_tune_dao.dart';
import 'package:tune_catcher/model/database.dart';
import 'package:tune_catcher/model/database_provider.dart';

final allSetsProvider = StreamProvider.autoDispose<List<TuneSet>>((ref) {
  return ref.watch(databaseProvider).setDao.watchAllSets();
});

final singleSetProvider = StreamProvider.family.autoDispose<TuneSet?, int>((
  ref,
  id,
) {
  return ref.watch(databaseProvider).setDao.watchSet(id);
});

final setTunesProvider = StreamProvider.family
    .autoDispose<List<SetTuneEntry>, int>((ref, setId) {
      return ref.watch(databaseProvider).setTuneDao.watchTunesInSet(setId);
    });

final setsForTuneProvider = StreamProvider.family
    .autoDispose<List<TuneSetEntry>, int>((ref, tuneId) {
      return ref.watch(databaseProvider).setTuneDao.watchSetsForTune(tuneId);
    });
