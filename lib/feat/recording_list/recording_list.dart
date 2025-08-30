import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tune_catcher/feat/recording_list/recording_list_tile.dart';
import 'package:tune_catcher/model/providers/recordings_provider.dart';
import 'package:tune_catcher/model/providers/sort_provider.dart';

class RecordingList extends ConsumerWidget {
  const RecordingList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordings = ref.watch(sortedRecordingsProvider);
    final sort = ref.watch(sortProvider);

    return Column(
      children: [
        DropdownButton<Sort>(
          value: sort,
          onChanged: (newValue) {
            if (newValue != null) {
              ref.read(sortProvider.notifier).state = newValue;
            }
          },
          items: Sort.values.map((s) {
            return DropdownMenuItem(value: s, child: Text(sortName(s)));
          }).toList(),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: recordings.length,
            itemBuilder: (context, index) {
              final recording = recordings[index];
              return RecordingListTile(recording: recording);
            },
          ),
        ),
      ],
    );
  }
}
