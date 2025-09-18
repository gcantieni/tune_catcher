import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tune_catcher/model/database.dart';
import 'package:tune_catcher/remote_tune_sources/thesession_tune_source.dart';

class TuneMatcher {
  final List<TunesCompanion> tuneData;
  TuneMatcher(this.tuneData);

  Timer? _debounceTimer;

  // This is debounced to improve performance, meaning that it won't
  // attempt to do the string comparison until the user has stopped
  // typing for the timeout.
  Future<Iterable<TunesCompanion>> match(TextEditingValue val) {
    final completer = Completer<Iterable<TunesCompanion>>();
    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 200), () {
      completer.complete(
        tuneData.where(
          (element) =>
              element.name.value.toLowerCase().contains(val.text.toLowerCase()),
        ),
      );
    });

    return completer.future;
  }
}

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
      data: (tuneData) {
        final matcher = TuneMatcher(tuneData);

        return Autocomplete<TunesCompanion>(
          optionsBuilder: (TextEditingValue textEditingValue) async {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<TunesCompanion>.empty();
            }

            return matcher.match(textEditingValue);
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
        );
      },
    );
  }
}
