import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tune_catcher/model/database.dart';
import 'package:tune_catcher/model/providers/tunes_provider.dart';
import 'package:tune_catcher/remote_tune_sources/thesession_tune_source.dart';

const _debounceDelay = Duration(milliseconds: 100);

/// A search-driven tune picker. Shows tunes already in the library
/// (visually distinct, friendly green) alongside thesession.org matches,
/// plus a "create new" affordance when there's typed text. Pops itself
/// before invoking the chosen callback.
class TunePickerDialog extends ConsumerStatefulWidget {
  final String title;
  final void Function(Tune tune) onLibraryTune;
  final void Function(TunesCompanion tune) onThesessionTune;
  final void Function(String name) onCreateNew;

  const TunePickerDialog({
    required this.title,
    required this.onLibraryTune,
    required this.onThesessionTune,
    required this.onCreateNew,
    super.key,
  });

  @override
  ConsumerState<TunePickerDialog> createState() => _TunePickerDialogState();
}

class _TunePickerDialogState extends ConsumerState<TunePickerDialog> {
  final _controller = TextEditingController();
  String _debouncedQuery = '';
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDelay, () {
      if (!mounted) return;
      setState(() => _debouncedQuery = _controller.text.trim().toLowerCase());
    });
  }

  void _pickLibrary(Tune tune) {
    Navigator.of(context).pop();
    widget.onLibraryTune(tune);
  }

  void _pickThesession(TunesCompanion tune) {
    Navigator.of(context).pop();
    widget.onThesessionTune(tune);
  }

  void _pickCreateNew(String name) {
    Navigator.of(context).pop();
    widget.onCreateNew(name);
  }

  @override
  Widget build(BuildContext context) {
    final query = _debouncedQuery;
    final localTunesAsync = ref.watch(allTunesProvider);
    final thesessionTunesAsync = ref.watch(thesessionTuneProvider);

    return Dialog(
      child: SizedBox(
        width: 600,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Tune name',
                  hintText: 'Type to search…',
                ),
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 420),
                child: query.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'Start typing to find a tune.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : localTunesAsync.when(
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        error: (e, s) => Text('Error: $e'),
                        data: (localTunes) => thesessionTunesAsync.when(
                          loading: () => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          error: (e, s) => Text('Error: $e'),
                          data: (thesessionTunes) => _buildSuggestions(
                            query,
                            localTunes,
                            thesessionTunes,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestions(
    String query,
    List<Tune> localTunes,
    List<TunesCompanion> thesessionTunes,
  ) {
    final matchingLocal = localTunes
        .where((t) => t.name.toLowerCase().contains(query))
        .toList();

    final localTsIds = localTunes
        .where((t) => t.tsId != null)
        .map((t) => t.tsId!)
        .toSet();
    final matchingThesession = thesessionTunes
        .where(
          (t) =>
              t.name.value.toLowerCase().contains(query) &&
              !(t.tsId.present && localTsIds.contains(t.tsId.value)),
        )
        .take(20)
        .toList();

    return ListView(
      shrinkWrap: true,
      children: [
        if (matchingLocal.isNotEmpty) ...[
          const _SectionHeader('In your library'),
          for (final t in matchingLocal)
            _LibraryTuneTile(tune: t, onTap: () => _pickLibrary(t)),
        ],
        if (matchingThesession.isNotEmpty) ...[
          if (matchingLocal.isNotEmpty) const SizedBox(height: 8),
          const _SectionHeader('From thesession.org'),
          for (final t in matchingThesession)
            _ThesessionTuneTile(tune: t, onTap: () => _pickThesession(t)),
        ],
        const SizedBox(height: 8),
        _CreateNewTile(
          name: _controller.text.trim(),
          onTap: () => _pickCreateNew(_controller.text.trim()),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
    );
  }
}

class _LibraryTuneTile extends StatelessWidget {
  final Tune tune;
  final VoidCallback onTap;
  const _LibraryTuneTile({required this.tune, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      if (tune.type != null) tune.type!.name,
      if (tune.key != null && tune.key!.isNotEmpty) tune.key!,
    ].join(' · ');

    return Card(
      color: Colors.green.shade50,
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        leading: Icon(Icons.check_circle, color: Colors.green.shade700),
        title: Text(tune.name),
        subtitle: subtitle.isEmpty ? null : Text(subtitle),
        trailing: Text(
          'In library',
          style: TextStyle(fontSize: 12, color: Colors.green.shade800),
        ),
        onTap: onTap,
      ),
    );
  }
}

class _ThesessionTuneTile extends StatelessWidget {
  final TunesCompanion tune;
  final VoidCallback onTap;
  const _ThesessionTuneTile({required this.tune, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final type = tune.type.value?.name;
    final key = tune.key.value;
    final subtitle = [
      if (type != null) type,
      if (key != null && key.isNotEmpty) key,
    ].join(' · ');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        leading: const Icon(Icons.public, color: Colors.blueGrey),
        title: Text(tune.name.value),
        subtitle: subtitle.isEmpty ? null : Text(subtitle),
        trailing: const Text(
          'thesession.org',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        onTap: onTap,
      ),
    );
  }
}

class _CreateNewTile extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  const _CreateNewTile({required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (name.isEmpty) return const SizedBox.shrink();
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        leading: const Icon(Icons.add_circle_outline),
        title: Text('Create new tune "$name"'),
        onTap: onTap,
      ),
    );
  }
}
