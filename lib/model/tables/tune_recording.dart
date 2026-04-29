import 'package:drift/drift.dart';

class TuneRecording extends Table {
  IntColumn get tuneId => integer()();
  IntColumn get recordingId => integer()();

  /// Start timestamp in seconds
  IntColumn get startTime => integer().nullable()();

  /// End timestamp in seconds
  IntColumn get endTime => integer().nullable()();

  /// Free text for names of performers if known
  TextColumn get performers => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {tuneId, recordingId};
}
