import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tune_catcher/model/database.dart';
import 'package:tune_catcher/model/providers/recordings_provider.dart';

const _debounceDelay = Duration(milliseconds: 100);

/// A search-driven recording picker. Lists recordings already in the
/// library and lets the caller link the chosen one. There is no remote
/// catalogue (recordings are user-created), and creating a new recording
/// requires a URL, so creation is not offered here — use the recordings
/// tab for that.
class RecordingPickerDialog extends ConsumerStatefulWidget {
  final String title;
  final void Function(Recording recording) onPicked;

  const RecordingPickerDialog({
    required this.title,
    required this.onPicked,
    super.key,
  });

  @override
  ConsumerState<RecordingPickerDialog> createState() =>
      _RecordingPickerDialogState();
}

class _RecordingPickerDialogState extends ConsumerState<RecordingPickerDialog> {
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

  void _pick(Recording r) {
    Navigator.of(context).pop();
    widget.onPicked(r);
  }

  @override
  Widget build(BuildContext context) {
    final query = _debouncedQuery;
    final recordingsAsync = ref.watch(allRecordingsProvider);

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
                  labelText: 'Recording name',
                  hintText: 'Type to search…',
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: recordingsAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, s) => Text('Error: $e'),
                  data: (recordings) => _buildSuggestions(query, recordings),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestions(String query, List<Recording> all) {
    final matches = query.isEmpty
        ? all
        : all.where((r) => r.name.toLowerCase().contains(query)).toList();

    if (matches.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text(
          'No matching recordings.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView(
      shrinkWrap: true,
      children: [
        for (final r in matches) _RecordingTile(recording: r, onTap: () => _pick(r)),
      ],
    );
  }
}

class _RecordingTile extends StatelessWidget {
  final Recording recording;
  final VoidCallback onTap;
  const _RecordingTile({required this.recording, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final performers = recording.performers;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        leading: const Icon(Icons.album),
        title: Text(recording.name),
        subtitle: (performers == null || performers.isEmpty)
            ? null
            : Text(performers),
        onTap: onTap,
      ),
    );
  }
}
