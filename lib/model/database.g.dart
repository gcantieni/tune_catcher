// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $RecordingsTable extends Recordings
    with TableInfo<$RecordingsTable, Recording> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecordingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _modifiedAtMeta = const VerificationMeta(
    'modifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> modifiedAt = GeneratedColumn<DateTime>(
    'modified_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _performersMeta = const VerificationMeta(
    'performers',
  );
  @override
  late final GeneratedColumn<String> performers = GeneratedColumn<String>(
    'performers',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    filePath,
    createdAt,
    modifiedAt,
    performers,
    location,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recordings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Recording> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('modified_at')) {
      context.handle(
        _modifiedAtMeta,
        modifiedAt.isAcceptableOrUnknown(data['modified_at']!, _modifiedAtMeta),
      );
    }
    if (data.containsKey('performers')) {
      context.handle(
        _performersMeta,
        performers.isAcceptableOrUnknown(data['performers']!, _performersMeta),
      );
    } else if (isInserting) {
      context.missing(_performersMeta);
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    } else if (isInserting) {
      context.missing(_locationMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Recording map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Recording(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      modifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}modified_at'],
      ),
      performers: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}performers'],
      )!,
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      )!,
    );
  }

  @override
  $RecordingsTable createAlias(String alias) {
    return $RecordingsTable(attachedDatabase, alias);
  }
}

class Recording extends DataClass implements Insertable<Recording> {
  final int id;
  final String filePath;
  final DateTime? createdAt;
  final DateTime? modifiedAt;
  final String performers;
  final String location;
  const Recording({
    required this.id,
    required this.filePath,
    this.createdAt,
    this.modifiedAt,
    required this.performers,
    required this.location,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['file_path'] = Variable<String>(filePath);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || modifiedAt != null) {
      map['modified_at'] = Variable<DateTime>(modifiedAt);
    }
    map['performers'] = Variable<String>(performers);
    map['location'] = Variable<String>(location);
    return map;
  }

  RecordingsCompanion toCompanion(bool nullToAbsent) {
    return RecordingsCompanion(
      id: Value(id),
      filePath: Value(filePath),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      modifiedAt: modifiedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(modifiedAt),
      performers: Value(performers),
      location: Value(location),
    );
  }

  factory Recording.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Recording(
      id: serializer.fromJson<int>(json['id']),
      filePath: serializer.fromJson<String>(json['filePath']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      modifiedAt: serializer.fromJson<DateTime?>(json['modifiedAt']),
      performers: serializer.fromJson<String>(json['performers']),
      location: serializer.fromJson<String>(json['location']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'filePath': serializer.toJson<String>(filePath),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'modifiedAt': serializer.toJson<DateTime?>(modifiedAt),
      'performers': serializer.toJson<String>(performers),
      'location': serializer.toJson<String>(location),
    };
  }

  Recording copyWith({
    int? id,
    String? filePath,
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> modifiedAt = const Value.absent(),
    String? performers,
    String? location,
  }) => Recording(
    id: id ?? this.id,
    filePath: filePath ?? this.filePath,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    modifiedAt: modifiedAt.present ? modifiedAt.value : this.modifiedAt,
    performers: performers ?? this.performers,
    location: location ?? this.location,
  );
  Recording copyWithCompanion(RecordingsCompanion data) {
    return Recording(
      id: data.id.present ? data.id.value : this.id,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      modifiedAt: data.modifiedAt.present
          ? data.modifiedAt.value
          : this.modifiedAt,
      performers: data.performers.present
          ? data.performers.value
          : this.performers,
      location: data.location.present ? data.location.value : this.location,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Recording(')
          ..write('id: $id, ')
          ..write('filePath: $filePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('performers: $performers, ')
          ..write('location: $location')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, filePath, createdAt, modifiedAt, performers, location);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recording &&
          other.id == this.id &&
          other.filePath == this.filePath &&
          other.createdAt == this.createdAt &&
          other.modifiedAt == this.modifiedAt &&
          other.performers == this.performers &&
          other.location == this.location);
}

class RecordingsCompanion extends UpdateCompanion<Recording> {
  final Value<int> id;
  final Value<String> filePath;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> modifiedAt;
  final Value<String> performers;
  final Value<String> location;
  const RecordingsCompanion({
    this.id = const Value.absent(),
    this.filePath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.modifiedAt = const Value.absent(),
    this.performers = const Value.absent(),
    this.location = const Value.absent(),
  });
  RecordingsCompanion.insert({
    this.id = const Value.absent(),
    required String filePath,
    this.createdAt = const Value.absent(),
    this.modifiedAt = const Value.absent(),
    required String performers,
    required String location,
  }) : filePath = Value(filePath),
       performers = Value(performers),
       location = Value(location);
  static Insertable<Recording> custom({
    Expression<int>? id,
    Expression<String>? filePath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? modifiedAt,
    Expression<String>? performers,
    Expression<String>? location,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (filePath != null) 'file_path': filePath,
      if (createdAt != null) 'created_at': createdAt,
      if (modifiedAt != null) 'modified_at': modifiedAt,
      if (performers != null) 'performers': performers,
      if (location != null) 'location': location,
    });
  }

  RecordingsCompanion copyWith({
    Value<int>? id,
    Value<String>? filePath,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? modifiedAt,
    Value<String>? performers,
    Value<String>? location,
  }) {
    return RecordingsCompanion(
      id: id ?? this.id,
      filePath: filePath ?? this.filePath,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      performers: performers ?? this.performers,
      location: location ?? this.location,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (modifiedAt.present) {
      map['modified_at'] = Variable<DateTime>(modifiedAt.value);
    }
    if (performers.present) {
      map['performers'] = Variable<String>(performers.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecordingsCompanion(')
          ..write('id: $id, ')
          ..write('filePath: $filePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('performers: $performers, ')
          ..write('location: $location')
          ..write(')'))
        .toString();
  }
}

class $TunesTable extends Tunes with TableInfo<$TunesTable, Tune> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TunesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modifiedAtMeta = const VerificationMeta(
    'modifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> modifiedAt = GeneratedColumn<DateTime>(
    'modified_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genreMeta = const VerificationMeta('genre');
  @override
  late final GeneratedColumn<String> genre = GeneratedColumn<String>(
    'genre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    createdAt,
    modifiedAt,
    genre,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tunes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tune> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('modified_at')) {
      context.handle(
        _modifiedAtMeta,
        modifiedAt.isAcceptableOrUnknown(data['modified_at']!, _modifiedAtMeta),
      );
    }
    if (data.containsKey('genre')) {
      context.handle(
        _genreMeta,
        genre.isAcceptableOrUnknown(data['genre']!, _genreMeta),
      );
    } else if (isInserting) {
      context.missing(_genreMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tune map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tune(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      modifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}modified_at'],
      ),
      genre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}genre'],
      )!,
    );
  }

  @override
  $TunesTable createAlias(String alias) {
    return $TunesTable(attachedDatabase, alias);
  }
}

class Tune extends DataClass implements Insertable<Tune> {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime? modifiedAt;
  final String genre;
  const Tune({
    required this.id,
    required this.name,
    required this.createdAt,
    this.modifiedAt,
    required this.genre,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || modifiedAt != null) {
      map['modified_at'] = Variable<DateTime>(modifiedAt);
    }
    map['genre'] = Variable<String>(genre);
    return map;
  }

  TunesCompanion toCompanion(bool nullToAbsent) {
    return TunesCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
      modifiedAt: modifiedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(modifiedAt),
      genre: Value(genre),
    );
  }

  factory Tune.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tune(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      modifiedAt: serializer.fromJson<DateTime?>(json['modifiedAt']),
      genre: serializer.fromJson<String>(json['genre']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'modifiedAt': serializer.toJson<DateTime?>(modifiedAt),
      'genre': serializer.toJson<String>(genre),
    };
  }

  Tune copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
    Value<DateTime?> modifiedAt = const Value.absent(),
    String? genre,
  }) => Tune(
    id: id ?? this.id,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
    modifiedAt: modifiedAt.present ? modifiedAt.value : this.modifiedAt,
    genre: genre ?? this.genre,
  );
  Tune copyWithCompanion(TunesCompanion data) {
    return Tune(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      modifiedAt: data.modifiedAt.present
          ? data.modifiedAt.value
          : this.modifiedAt,
      genre: data.genre.present ? data.genre.value : this.genre,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tune(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('genre: $genre')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt, modifiedAt, genre);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tune &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.modifiedAt == this.modifiedAt &&
          other.genre == this.genre);
}

class TunesCompanion extends UpdateCompanion<Tune> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<DateTime?> modifiedAt;
  final Value<String> genre;
  const TunesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.modifiedAt = const Value.absent(),
    this.genre = const Value.absent(),
  });
  TunesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required DateTime createdAt,
    this.modifiedAt = const Value.absent(),
    required String genre,
  }) : name = Value(name),
       createdAt = Value(createdAt),
       genre = Value(genre);
  static Insertable<Tune> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? modifiedAt,
    Expression<String>? genre,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (modifiedAt != null) 'modified_at': modifiedAt,
      if (genre != null) 'genre': genre,
    });
  }

  TunesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
    Value<DateTime?>? modifiedAt,
    Value<String>? genre,
  }) {
    return TunesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      genre: genre ?? this.genre,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (modifiedAt.present) {
      map['modified_at'] = Variable<DateTime>(modifiedAt.value);
    }
    if (genre.present) {
      map['genre'] = Variable<String>(genre.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TunesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('genre: $genre')
          ..write(')'))
        .toString();
  }
}

class $Tunes2RecordingsTable extends Tunes2Recordings
    with TableInfo<$Tunes2RecordingsTable, Tunes2Recording> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $Tunes2RecordingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tuneIdMeta = const VerificationMeta('tuneId');
  @override
  late final GeneratedColumn<int> tuneId = GeneratedColumn<int>(
    'tune_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordingIdMeta = const VerificationMeta(
    'recordingId',
  );
  @override
  late final GeneratedColumn<int> recordingId = GeneratedColumn<int>(
    'recording_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<int> startTime = GeneratedColumn<int>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<int> endTime = GeneratedColumn<int>(
    'end_time',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _keySignatureMeta = const VerificationMeta(
    'keySignature',
  );
  @override
  late final GeneratedColumn<String> keySignature = GeneratedColumn<String>(
    'key_signature',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _performersMeta = const VerificationMeta(
    'performers',
  );
  @override
  late final GeneratedColumn<String> performers = GeneratedColumn<String>(
    'performers',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    tuneId,
    recordingId,
    startTime,
    endTime,
    keySignature,
    performers,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tunes2_recordings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tunes2Recording> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('tune_id')) {
      context.handle(
        _tuneIdMeta,
        tuneId.isAcceptableOrUnknown(data['tune_id']!, _tuneIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tuneIdMeta);
    }
    if (data.containsKey('recording_id')) {
      context.handle(
        _recordingIdMeta,
        recordingId.isAcceptableOrUnknown(
          data['recording_id']!,
          _recordingIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recordingIdMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('key_signature')) {
      context.handle(
        _keySignatureMeta,
        keySignature.isAcceptableOrUnknown(
          data['key_signature']!,
          _keySignatureMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_keySignatureMeta);
    }
    if (data.containsKey('performers')) {
      context.handle(
        _performersMeta,
        performers.isAcceptableOrUnknown(data['performers']!, _performersMeta),
      );
    } else if (isInserting) {
      context.missing(_performersMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Tunes2Recording map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tunes2Recording(
      tuneId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tune_id'],
      )!,
      recordingId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recording_id'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_time'],
      )!,
      keySignature: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key_signature'],
      )!,
      performers: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}performers'],
      )!,
    );
  }

  @override
  $Tunes2RecordingsTable createAlias(String alias) {
    return $Tunes2RecordingsTable(attachedDatabase, alias);
  }
}

class Tunes2Recording extends DataClass implements Insertable<Tunes2Recording> {
  final int tuneId;
  final int recordingId;

  /// Start timestamp in seconds
  final int startTime;

  /// End timestamp in seconds
  final int endTime;

  /// Key signature of this recording
  final String keySignature;

  /// Free text for names of performers if known
  final String performers;
  const Tunes2Recording({
    required this.tuneId,
    required this.recordingId,
    required this.startTime,
    required this.endTime,
    required this.keySignature,
    required this.performers,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['tune_id'] = Variable<int>(tuneId);
    map['recording_id'] = Variable<int>(recordingId);
    map['start_time'] = Variable<int>(startTime);
    map['end_time'] = Variable<int>(endTime);
    map['key_signature'] = Variable<String>(keySignature);
    map['performers'] = Variable<String>(performers);
    return map;
  }

  Tunes2RecordingsCompanion toCompanion(bool nullToAbsent) {
    return Tunes2RecordingsCompanion(
      tuneId: Value(tuneId),
      recordingId: Value(recordingId),
      startTime: Value(startTime),
      endTime: Value(endTime),
      keySignature: Value(keySignature),
      performers: Value(performers),
    );
  }

  factory Tunes2Recording.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tunes2Recording(
      tuneId: serializer.fromJson<int>(json['tuneId']),
      recordingId: serializer.fromJson<int>(json['recordingId']),
      startTime: serializer.fromJson<int>(json['startTime']),
      endTime: serializer.fromJson<int>(json['endTime']),
      keySignature: serializer.fromJson<String>(json['keySignature']),
      performers: serializer.fromJson<String>(json['performers']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tuneId': serializer.toJson<int>(tuneId),
      'recordingId': serializer.toJson<int>(recordingId),
      'startTime': serializer.toJson<int>(startTime),
      'endTime': serializer.toJson<int>(endTime),
      'keySignature': serializer.toJson<String>(keySignature),
      'performers': serializer.toJson<String>(performers),
    };
  }

  Tunes2Recording copyWith({
    int? tuneId,
    int? recordingId,
    int? startTime,
    int? endTime,
    String? keySignature,
    String? performers,
  }) => Tunes2Recording(
    tuneId: tuneId ?? this.tuneId,
    recordingId: recordingId ?? this.recordingId,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    keySignature: keySignature ?? this.keySignature,
    performers: performers ?? this.performers,
  );
  Tunes2Recording copyWithCompanion(Tunes2RecordingsCompanion data) {
    return Tunes2Recording(
      tuneId: data.tuneId.present ? data.tuneId.value : this.tuneId,
      recordingId: data.recordingId.present
          ? data.recordingId.value
          : this.recordingId,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      keySignature: data.keySignature.present
          ? data.keySignature.value
          : this.keySignature,
      performers: data.performers.present
          ? data.performers.value
          : this.performers,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tunes2Recording(')
          ..write('tuneId: $tuneId, ')
          ..write('recordingId: $recordingId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('keySignature: $keySignature, ')
          ..write('performers: $performers')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    tuneId,
    recordingId,
    startTime,
    endTime,
    keySignature,
    performers,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tunes2Recording &&
          other.tuneId == this.tuneId &&
          other.recordingId == this.recordingId &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.keySignature == this.keySignature &&
          other.performers == this.performers);
}

class Tunes2RecordingsCompanion extends UpdateCompanion<Tunes2Recording> {
  final Value<int> tuneId;
  final Value<int> recordingId;
  final Value<int> startTime;
  final Value<int> endTime;
  final Value<String> keySignature;
  final Value<String> performers;
  final Value<int> rowid;
  const Tunes2RecordingsCompanion({
    this.tuneId = const Value.absent(),
    this.recordingId = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.keySignature = const Value.absent(),
    this.performers = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  Tunes2RecordingsCompanion.insert({
    required int tuneId,
    required int recordingId,
    required int startTime,
    required int endTime,
    required String keySignature,
    required String performers,
    this.rowid = const Value.absent(),
  }) : tuneId = Value(tuneId),
       recordingId = Value(recordingId),
       startTime = Value(startTime),
       endTime = Value(endTime),
       keySignature = Value(keySignature),
       performers = Value(performers);
  static Insertable<Tunes2Recording> custom({
    Expression<int>? tuneId,
    Expression<int>? recordingId,
    Expression<int>? startTime,
    Expression<int>? endTime,
    Expression<String>? keySignature,
    Expression<String>? performers,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tuneId != null) 'tune_id': tuneId,
      if (recordingId != null) 'recording_id': recordingId,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (keySignature != null) 'key_signature': keySignature,
      if (performers != null) 'performers': performers,
      if (rowid != null) 'rowid': rowid,
    });
  }

  Tunes2RecordingsCompanion copyWith({
    Value<int>? tuneId,
    Value<int>? recordingId,
    Value<int>? startTime,
    Value<int>? endTime,
    Value<String>? keySignature,
    Value<String>? performers,
    Value<int>? rowid,
  }) {
    return Tunes2RecordingsCompanion(
      tuneId: tuneId ?? this.tuneId,
      recordingId: recordingId ?? this.recordingId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      keySignature: keySignature ?? this.keySignature,
      performers: performers ?? this.performers,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tuneId.present) {
      map['tune_id'] = Variable<int>(tuneId.value);
    }
    if (recordingId.present) {
      map['recording_id'] = Variable<int>(recordingId.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<int>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<int>(endTime.value);
    }
    if (keySignature.present) {
      map['key_signature'] = Variable<String>(keySignature.value);
    }
    if (performers.present) {
      map['performers'] = Variable<String>(performers.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('Tunes2RecordingsCompanion(')
          ..write('tuneId: $tuneId, ')
          ..write('recordingId: $recordingId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('keySignature: $keySignature, ')
          ..write('performers: $performers, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RecordingsTable recordings = $RecordingsTable(this);
  late final $TunesTable tunes = $TunesTable(this);
  late final $Tunes2RecordingsTable tunes2Recordings = $Tunes2RecordingsTable(
    this,
  );
  late final TuneDao tuneDao = TuneDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    recordings,
    tunes,
    tunes2Recordings,
  ];
}

typedef $$RecordingsTableCreateCompanionBuilder =
    RecordingsCompanion Function({
      Value<int> id,
      required String filePath,
      Value<DateTime?> createdAt,
      Value<DateTime?> modifiedAt,
      required String performers,
      required String location,
    });
typedef $$RecordingsTableUpdateCompanionBuilder =
    RecordingsCompanion Function({
      Value<int> id,
      Value<String> filePath,
      Value<DateTime?> createdAt,
      Value<DateTime?> modifiedAt,
      Value<String> performers,
      Value<String> location,
    });

class $$RecordingsTableFilterComposer
    extends Composer<_$AppDatabase, $RecordingsTable> {
  $$RecordingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get performers => $composableBuilder(
    column: $table.performers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecordingsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecordingsTable> {
  $$RecordingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get performers => $composableBuilder(
    column: $table.performers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecordingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecordingsTable> {
  $$RecordingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get performers => $composableBuilder(
    column: $table.performers,
    builder: (column) => column,
  );

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);
}

class $$RecordingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecordingsTable,
          Recording,
          $$RecordingsTableFilterComposer,
          $$RecordingsTableOrderingComposer,
          $$RecordingsTableAnnotationComposer,
          $$RecordingsTableCreateCompanionBuilder,
          $$RecordingsTableUpdateCompanionBuilder,
          (
            Recording,
            BaseReferences<_$AppDatabase, $RecordingsTable, Recording>,
          ),
          Recording,
          PrefetchHooks Function()
        > {
  $$RecordingsTableTableManager(_$AppDatabase db, $RecordingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecordingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecordingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecordingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> modifiedAt = const Value.absent(),
                Value<String> performers = const Value.absent(),
                Value<String> location = const Value.absent(),
              }) => RecordingsCompanion(
                id: id,
                filePath: filePath,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                performers: performers,
                location: location,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String filePath,
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> modifiedAt = const Value.absent(),
                required String performers,
                required String location,
              }) => RecordingsCompanion.insert(
                id: id,
                filePath: filePath,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                performers: performers,
                location: location,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecordingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecordingsTable,
      Recording,
      $$RecordingsTableFilterComposer,
      $$RecordingsTableOrderingComposer,
      $$RecordingsTableAnnotationComposer,
      $$RecordingsTableCreateCompanionBuilder,
      $$RecordingsTableUpdateCompanionBuilder,
      (Recording, BaseReferences<_$AppDatabase, $RecordingsTable, Recording>),
      Recording,
      PrefetchHooks Function()
    >;
typedef $$TunesTableCreateCompanionBuilder =
    TunesCompanion Function({
      Value<int> id,
      required String name,
      required DateTime createdAt,
      Value<DateTime?> modifiedAt,
      required String genre,
    });
typedef $$TunesTableUpdateCompanionBuilder =
    TunesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DateTime> createdAt,
      Value<DateTime?> modifiedAt,
      Value<String> genre,
    });

class $$TunesTableFilterComposer extends Composer<_$AppDatabase, $TunesTable> {
  $$TunesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get genre => $composableBuilder(
    column: $table.genre,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TunesTableOrderingComposer
    extends Composer<_$AppDatabase, $TunesTable> {
  $$TunesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get genre => $composableBuilder(
    column: $table.genre,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TunesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TunesTable> {
  $$TunesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get genre =>
      $composableBuilder(column: $table.genre, builder: (column) => column);
}

class $$TunesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TunesTable,
          Tune,
          $$TunesTableFilterComposer,
          $$TunesTableOrderingComposer,
          $$TunesTableAnnotationComposer,
          $$TunesTableCreateCompanionBuilder,
          $$TunesTableUpdateCompanionBuilder,
          (Tune, BaseReferences<_$AppDatabase, $TunesTable, Tune>),
          Tune,
          PrefetchHooks Function()
        > {
  $$TunesTableTableManager(_$AppDatabase db, $TunesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TunesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TunesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TunesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> modifiedAt = const Value.absent(),
                Value<String> genre = const Value.absent(),
              }) => TunesCompanion(
                id: id,
                name: name,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                genre: genre,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required DateTime createdAt,
                Value<DateTime?> modifiedAt = const Value.absent(),
                required String genre,
              }) => TunesCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
                modifiedAt: modifiedAt,
                genre: genre,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TunesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TunesTable,
      Tune,
      $$TunesTableFilterComposer,
      $$TunesTableOrderingComposer,
      $$TunesTableAnnotationComposer,
      $$TunesTableCreateCompanionBuilder,
      $$TunesTableUpdateCompanionBuilder,
      (Tune, BaseReferences<_$AppDatabase, $TunesTable, Tune>),
      Tune,
      PrefetchHooks Function()
    >;
typedef $$Tunes2RecordingsTableCreateCompanionBuilder =
    Tunes2RecordingsCompanion Function({
      required int tuneId,
      required int recordingId,
      required int startTime,
      required int endTime,
      required String keySignature,
      required String performers,
      Value<int> rowid,
    });
typedef $$Tunes2RecordingsTableUpdateCompanionBuilder =
    Tunes2RecordingsCompanion Function({
      Value<int> tuneId,
      Value<int> recordingId,
      Value<int> startTime,
      Value<int> endTime,
      Value<String> keySignature,
      Value<String> performers,
      Value<int> rowid,
    });

class $$Tunes2RecordingsTableFilterComposer
    extends Composer<_$AppDatabase, $Tunes2RecordingsTable> {
  $$Tunes2RecordingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get tuneId => $composableBuilder(
    column: $table.tuneId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordingId => $composableBuilder(
    column: $table.recordingId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keySignature => $composableBuilder(
    column: $table.keySignature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get performers => $composableBuilder(
    column: $table.performers,
    builder: (column) => ColumnFilters(column),
  );
}

class $$Tunes2RecordingsTableOrderingComposer
    extends Composer<_$AppDatabase, $Tunes2RecordingsTable> {
  $$Tunes2RecordingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get tuneId => $composableBuilder(
    column: $table.tuneId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordingId => $composableBuilder(
    column: $table.recordingId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keySignature => $composableBuilder(
    column: $table.keySignature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get performers => $composableBuilder(
    column: $table.performers,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$Tunes2RecordingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $Tunes2RecordingsTable> {
  $$Tunes2RecordingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get tuneId =>
      $composableBuilder(column: $table.tuneId, builder: (column) => column);

  GeneratedColumn<int> get recordingId => $composableBuilder(
    column: $table.recordingId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<int> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<String> get keySignature => $composableBuilder(
    column: $table.keySignature,
    builder: (column) => column,
  );

  GeneratedColumn<String> get performers => $composableBuilder(
    column: $table.performers,
    builder: (column) => column,
  );
}

class $$Tunes2RecordingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $Tunes2RecordingsTable,
          Tunes2Recording,
          $$Tunes2RecordingsTableFilterComposer,
          $$Tunes2RecordingsTableOrderingComposer,
          $$Tunes2RecordingsTableAnnotationComposer,
          $$Tunes2RecordingsTableCreateCompanionBuilder,
          $$Tunes2RecordingsTableUpdateCompanionBuilder,
          (
            Tunes2Recording,
            BaseReferences<
              _$AppDatabase,
              $Tunes2RecordingsTable,
              Tunes2Recording
            >,
          ),
          Tunes2Recording,
          PrefetchHooks Function()
        > {
  $$Tunes2RecordingsTableTableManager(
    _$AppDatabase db,
    $Tunes2RecordingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$Tunes2RecordingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$Tunes2RecordingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$Tunes2RecordingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> tuneId = const Value.absent(),
                Value<int> recordingId = const Value.absent(),
                Value<int> startTime = const Value.absent(),
                Value<int> endTime = const Value.absent(),
                Value<String> keySignature = const Value.absent(),
                Value<String> performers = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => Tunes2RecordingsCompanion(
                tuneId: tuneId,
                recordingId: recordingId,
                startTime: startTime,
                endTime: endTime,
                keySignature: keySignature,
                performers: performers,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int tuneId,
                required int recordingId,
                required int startTime,
                required int endTime,
                required String keySignature,
                required String performers,
                Value<int> rowid = const Value.absent(),
              }) => Tunes2RecordingsCompanion.insert(
                tuneId: tuneId,
                recordingId: recordingId,
                startTime: startTime,
                endTime: endTime,
                keySignature: keySignature,
                performers: performers,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$Tunes2RecordingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $Tunes2RecordingsTable,
      Tunes2Recording,
      $$Tunes2RecordingsTableFilterComposer,
      $$Tunes2RecordingsTableOrderingComposer,
      $$Tunes2RecordingsTableAnnotationComposer,
      $$Tunes2RecordingsTableCreateCompanionBuilder,
      $$Tunes2RecordingsTableUpdateCompanionBuilder,
      (
        Tunes2Recording,
        BaseReferences<_$AppDatabase, $Tunes2RecordingsTable, Tunes2Recording>,
      ),
      Tunes2Recording,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RecordingsTableTableManager get recordings =>
      $$RecordingsTableTableManager(_db, _db.recordings);
  $$TunesTableTableManager get tunes =>
      $$TunesTableTableManager(_db, _db.tunes);
  $$Tunes2RecordingsTableTableManager get tunes2Recordings =>
      $$Tunes2RecordingsTableTableManager(_db, _db.tunes2Recordings);
}
