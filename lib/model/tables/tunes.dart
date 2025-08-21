import 'package:drift/drift.dart';

enum TuneStatus { todo, canPlay, canStart, inSet, mastered }

// TODO: expand
enum TuneType { reel, jig, polka, slide }

class Tunes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get from => text().nullable()(); // Who or where a tune is from
  TextColumn get status =>
      textEnum<TuneStatus>().nullable()(); // How well is a tune known

  TextColumn get type =>
      textEnum<TuneType>().nullable()(); // How well is a tune known
  TextColumn get genre => text().nullable()(); // e.g. Irish, oldtime, Scottish
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get modifiedAt => dateTime().nullable()();
}
