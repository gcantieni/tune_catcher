import 'dart:convert';
import 'dart:io';

import 'package:html/parser.dart' as html;
import 'package:http/http.dart' as http;

Future<void> main() async {
  final results = <Map<String, dynamic>>[];

  const baseUrl = 'https://thesession.org/tunes/';
  const startId = 1;
  const endId = 27000;

  for (var id = startId; id <= endId; id++) {
    final url = '$baseUrl$id';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Parse the HTML document
      final document = html.parse(response.body);

      // Each abc is wrapped in a "notes div". It then has a bunch of attributes.
      final firstSetting = document.querySelector('div.notes');

      if (firstSetting == null) {
        print("Could not locate tune");
        continue;
      }

      final tuneAbc = firstSetting.text;

      var idx = tuneAbc.indexOf('T: ');
      var end = tuneAbc.indexOf('\n', idx);
      final tuneTitle = tuneAbc.substring(idx + 3, end);

      idx = tuneAbc.indexOf('R: ');
      end = tuneAbc.indexOf('\n', idx);
      final tuneType = tuneAbc.substring(idx + 3, end);

      idx = tuneAbc.indexOf('K: ');
      end = tuneAbc.indexOf('\n', idx);
      final tuneKey = tuneAbc.substring(idx + 3, end);

      results.add({
        'id': id,
        'abc': tuneAbc,
        'name': tuneTitle,
        'type': tuneType,
        'key': tuneKey,
      });

      print("Saved tune $tuneTitle with id $id");
    } else if (response.statusCode == 404) {
      print('Skipped $url (not found)');
    } else {
      print('Error ${response.statusCode} on $url');
    }
  }

  // Save results to JSON file
  final file = File('../data/tunes.json');
  await file.writeAsString(
    const JsonEncoder.withIndent('  ').convert(results),
    mode: FileMode.write,
  );

  print('Saved ${results.length} items to ../data/tunes.json');
}
