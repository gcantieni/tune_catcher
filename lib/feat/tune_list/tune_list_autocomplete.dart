import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tune_catcher/model/database.dart';
import 'package:tune_catcher/remote_tune_sources/thesession_tune_source.dart';

class TuneNameAutoComplete extends ConsumerWidget {
  final void Function(TunesCompanion) onTuneSelected;
  final TextEditingController controller;

  const TuneNameAutoComplete({
    required this.onTuneSelected,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tuneData = ref.watch(thesessionTuneProvider);

    return tuneData.when(
      loading: () => TextFormField(
        controller: controller,
        decoration: const InputDecoration(labelText: 'Tune name'),
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Required' : null,
      ),
      error: (err, stack) => Text('Error: $err'),
      data: (tuneData) => Autocomplete<TunesCompanion>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return const Iterable<TunesCompanion>.empty();
          }

          return tuneData.where(
            (element) => element.toString().toLowerCase().contains(
              textEditingValue.text.toLowerCase(),
            ),
          );
        },
        onSelected: (option) {
          onTuneSelected(option);
        },
        displayStringForOption: (option) => option.name.value,
        fieldViewBuilder:
            (context, textEditingController, focusNode, onFieldSubmitted) =>
                TextFormField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: const InputDecoration(labelText: 'Tune name'),
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Required' : null,
                ),
      ),
    );
  }
}
