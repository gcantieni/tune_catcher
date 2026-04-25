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
      appBar: AppBar(title: const Text('Tune list')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(children: [TuneListWidget()]),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add tune',
        onPressed: () => _showAddTuneDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTuneDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        child: SizedBox(
          width: 600,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add tune',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TuneFormWidget(
                    onSubmitted: () => Navigator.of(dialogContext).pop(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TuneListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const fontSize = 19.0;
    // https://pub.dev/documentation/riverpod/latest/riverpod/StreamProvider-class.html
    final AsyncValue<List<Tune>> allTunesAsync = ref.watch(allTunesProvider);

    return allTunesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
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
