import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tune_catcher/feat/tune_list/tune_list_form.dart';
import 'package:tune_catcher/feat/tune_list/tune_list_item.dart';
import 'package:tune_catcher/model/database.dart';
import 'package:tune_catcher/model/providers/tunes_provider.dart';

class TuneListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter tune name')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const TuneFormWidget(),
            const SizedBox(height: 10),
            TuneListWidget(),
          ],
        ),
      ),
    );
  }
}

class TuneListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const fontSize = 19.0;
    final AsyncValue<List<Tune>> allTunesAsync = ref.watch(allTunesProvider);

    return allTunesAsync.when(
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
      data: (allTunes) => Column(
        mainAxisSize: MainAxisSize.min,
        children: allTunes.isEmpty
            ? [
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      'No tunes saved',
                      style: TextStyle(fontSize: fontSize),
                    ),
                  ),
                ),
              ]
            : [for (final Tune t in allTunes) TuneListItem(tune: t)],
      ),
    );
  }
}
