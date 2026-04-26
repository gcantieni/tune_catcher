// package imports
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
// local references
import 'package:tune_catcher/model/accessors/recording_dao.dart';
import 'package:tune_catcher/model/accessors/tune_dao.dart';
import 'package:tune_catcher/model/accessors/tune_recording_dao.dart';
import 'package:tune_catcher/model/database.steps.dart';
import 'package:tune_catcher/model/tables/recordings.dart';
import 'package:tune_catcher/model/tables/tune_recording.dart';
import 'package:tune_catcher/model/tables/tunes.dart';

// generated code
part 'database.g.dart';

@DriftDatabase(
  tables: [Recordings, Tunes, TuneRecording],
  daos: [TuneDao, RecordingDao, TuneRecordingDao],
)
class AppDatabase extends _$AppDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/setup/
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: stepByStep(
      from1To2: (m, schema) async {
        // The recordings table was reshaped: added name/url, dropped
        // file_path/location, performers became nullable. There is no
        // production data yet, so drop and recreate rather than reconcile
        // missing values for the new NOT NULL columns.
        await m.deleteTable('recordings');
        await m.createTable(schema.recordings);
      },
      from2To3: (m, schema) async {
        // tune_recording: start_time/end_time/performers became nullable
        // and key_signature was dropped. Lets a link be created with just
        // the two foreign keys; details can be filled in later.
        await m.alterTable(TableMigration(schema.tuneRecording));
      },
    ),
  );

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
