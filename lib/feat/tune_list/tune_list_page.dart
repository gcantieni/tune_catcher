import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tune_catcher/feat/tune_list/tune_list_item.dart';
import 'package:tune_catcher/shared_widgets/tune_picker_dialog.dart';
import 'package:tune_catcher/model/database.dart';
import 'package:tune_catcher/model/database_provider.dart';
import 'package:tune_catcher/model/providers/tunes_provider.dart';

class TuneListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tune list')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(children: [TuneListWidget()]),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add tune',
        onPressed: () => _showAddTuneDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTuneDialog(BuildContext context, WidgetRef ref) {
    final dao = ref.read(databaseProvider).tuneDao;
    showDialog<void>(
      context: context,
      builder: (_) => TunePickerDialog(
        title: 'Add tune',
        onLibraryTune: (tune) {
          // Already in the library — jump to its detail page.
          context.push('/tune_list/${tune.id}');
        },
        onThesessionTune: (companion) {
          dao.insertTune(
            companion.copyWith(createdAt: drift.Value(DateTime.now())),
          );
        },
        onCreateNew: (name) {
          dao.insertTune(
            TunesCompanion.insert(name: name, createdAt: DateTime.now()),
          );
        },
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
