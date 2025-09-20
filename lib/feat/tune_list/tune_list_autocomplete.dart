import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tune_catcher/model/database.dart';
import 'package:tune_catcher/remote_tune_sources/thesession_tune_source.dart';

class TuneMatcher {
  final List<TunesCompanion> tuneData;
  final Duration timeout;
  TuneMatcher(this.tuneData, this.timeout);

  Timer? _debounceTimer;

  // This is debounced to improve performance, meaning that it won't
  // attempt to do the string comparison until the user has stopped
  // typing for the timeout.
  Future<Iterable<TunesCompanion>> match(TextEditingValue val) {
    final completer = Completer<Iterable<TunesCompanion>>();
    _debounceTimer?.cancel();

    _debounceTimer = Timer(timeout, () {
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

class TuneNameAutoComplete extends StatefulWidget {
  final void Function(TunesCompanion) onTuneSelected;
  final Duration timeout;

  const TuneNameAutoComplete({
    super.key,
    required this.onTuneSelected,
    this.timeout = const Duration(milliseconds: 200),
  });

  @override
  State<TuneNameAutoComplete> createState() => TuneNameAutoCompleteState();
}

class TuneNameAutoCompleteState extends State<TuneNameAutoComplete> {
  TextEditingController? _controller;

  void clearName() {
    setState(() {
      _controller?.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final tuneData = ref.watch(thesessionTuneProvider);

        return tuneData.when(
          loading: () => TextFormField(
            decoration: const InputDecoration(labelText: 'Tune name'),
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Required' : null,
          ),
          error: (err, stack) => Text('Error: $err'),
          data: (tuneData) {
            final matcher = TuneMatcher(tuneData, widget.timeout);

            return Autocomplete<TunesCompanion>(
              optionsBuilder: (TextEditingValue textEditingValue) async {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<TunesCompanion>.empty();
                }

                return matcher.match(textEditingValue);
              },
              onSelected: (option) {
                widget.onTuneSelected(option);
              },
              displayStringForOption: (option) => option.name.value,
              fieldViewBuilder:
                  (
                    context,
                    textEditingController,
                    focusNode,
                    onFieldSubmitted,
                  ) {
                    _controller ??= textEditingController;
                    return TextFormField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      decoration: const InputDecoration(labelText: 'Tune name'),
                      validator: (value) =>
                          (value == null || value.isEmpty) ? 'Required' : null,
                    );
                  },
            );
          },
        );
      },
    );
  }
}
