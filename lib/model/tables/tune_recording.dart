import 'package:drift/drift.dart';

class TuneRecording extends Table {
  IntColumn get tuneId => integer()();
  IntColumn get recordingId => integer()();

  /// Start timestamp in seconds
  IntColumn get startTime => integer()();

  /// End timestamp in seconds
  IntColumn get endTime => integer()();

  /// Key signature of this recording
  TextColumn get keySignature => text()();

  /// Free text for names of performers if known
  TextColumn get performers => text()();
}
