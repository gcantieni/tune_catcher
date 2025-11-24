// package imports
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
// local references
import 'package:tune_catcher/model/accessors/tune_dao.dart';
import 'package:tune_catcher/model/tables/recordings.dart';
import 'package:tune_catcher/model/tables/tune_recording.dart';
import 'package:tune_catcher/model/tables/tunes.dart';

// generated code
part 'database.g.dart';

@DriftDatabase(tables: [Recordings, Tunes, TuneRecording], daos: [TuneDao])
class AppDatabase extends _$AppDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/setup/
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'my_database',
      native: const DriftNativeOptions(
        // By default, `driftDatabase` from `package:drift_flutter` stores the
        // database files in `getApplicationDocumentsDirectory()`.
        databaseDirectory: getApplicationSupportDirectory,
      ),
      // If you need web support, see https://drift.simonbinder.eu/platforms/web/
    );
  }
}
