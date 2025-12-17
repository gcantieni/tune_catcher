import 'dart:convert';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tune_catcher/model/database.dart';
import 'package:tune_catcher/model/tables/tunes.dart';

final thesessionTuneProvider = FutureProvider<List<TunesCompanion>>((
  ref,
) async {
  final tuneJsonData =
      json.decode(
            await rootBundle.loadString('assets/data/thesession_tunes.json'),
          )
          as List<dynamic>;
  return parseTunes(tuneJsonData);
});

List<TunesCompanion> parseTunes(List<dynamic> data) {
  return data.map((entry) {
    return TunesCompanion.insert(
      name: entry['name'] as String,
      createdAt: DateTime.now(),
      from: const drift.Value(null),
      tsId: drift.Value(entry['id'] as int),
      abc: drift.Value(entry['abc'] as String),
      key: drift.Value(entry['key'] as String),
      type: drift.Value(stringToType(entry['type'] as String)),
    );
  }).toList();
}

TuneType stringToType(String s) {
  switch (s) {
    case "jig":
      return TuneType.jig;
    case "reel":
      return TuneType.reel;
    case "polka":
      return TuneType.polka;
    case "slide":
      return TuneType.slide;
    case "hornpipe":
      return TuneType.hornpipe;
    case "march":
      return TuneType.march;
    case "slip jig":
      return TuneType.slipJig;
    case "waltz":
      return TuneType.waltz;
    case "barndance":
      return TuneType.barndance;
    case "strathspey":
      return TuneType.strathspey;
    case "three-two":
      return TuneType.threeTwo;
    case "mazurka":
      return TuneType.mazurka;
    default:
      throw Exception("Unsupported tune type $s");
  }
}
