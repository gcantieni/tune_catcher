import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tune_catcher/model/tables/tunes.dart' show TuneType;
import 'package:tune_catcher/remote_tune_sources/thesession_tune_source.dart';

void main() {
  test('parse tune json', () {
    final fakeJson =
        json.decode(
              '[{"id":1,"name":"Cooley\'s","key":"Em","type":"reel","abc":"asdf"},{"id":2,"name":"Lark in the Morning","key":"D","type":"jig","abc":"asdf"}]',
            )
            as List<dynamic>;
    final tunes = parseTunes(fakeJson);
    expect(tunes[0].name.value, "Cooley's");
    expect(tunes[0].tsId.value, 1);
    expect(tunes[0].abc.value, "asdf");
    expect(tunes[0].type.value, TuneType.reel);

    expect(tunes[1].name.value, "Lark in the Morning");
    expect(tunes[1].tsId.value, 2);
    expect(tunes[1].abc.value, "asdf");
    expect(tunes[1].type.value, TuneType.jig);
  });

  test('parse all tunes', () async {
    final file = File('./test/test_data/test_tunes.json');
    final contents = await file.readAsString();

    final tunesJson = json.decode(contents) as List<dynamic>;
    final tunes = parseTunes(tunesJson);

    expect(tunes[0].name.value, "Cooley's");
    expect(tunes[0].tsId.value, 1);
    expect(tunes[0].abc.value, contains("EBBA"));
    expect(tunes[0].type.value, TuneType.reel);
  });
}
