import 'package:drift/drift.dart';

class Recordings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get filePath => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get modifiedAt => dateTime().nullable()();
  TextColumn get performers => text().nullable()();
  TextColumn get location => text().nullable()();
}
