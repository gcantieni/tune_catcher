import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tune_catcher/model/database.dart';
import 'package:tune_catcher/model/database_provider.dart';

class RecordingFormWidget extends ConsumerStatefulWidget {
  final VoidCallback? onSubmitted;

  const RecordingFormWidget({super.key, this.onSubmitted});

  @override
  ConsumerState<RecordingFormWidget> createState() =>
      _RecordingFormWidgetState();
}

class _RecordingFormWidgetState extends ConsumerState<RecordingFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  final _performersController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _performersController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final performers = _performersController.text.trim();

    await ref
        .read(databaseProvider)
        .recordingDao
        .insertRecording(
          RecordingsCompanion.insert(
            name: _nameController.text.trim(),
            url: _urlController.text.trim(),
            createdAt: DateTime.now(),
            performers: drift.Value(
              performers.isEmpty ? null : performers,
            ),
          ),
        );

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('"${_nameController.text}" saved!')));

    _formKey.currentState!.reset();
    _nameController.clear();
    _urlController.clear();
    _performersController.clear();

    widget.onSubmitted?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _urlController,
            decoration: const InputDecoration(
              labelText: 'URL',
              hintText: 'https://… or spotify:…',
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _performersController,
            decoration: const InputDecoration(labelText: 'Performers'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Save recording'),
          ),
        ],
      ),
    );
  }
}
