import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:tune_catcher/feat/recording_list/apple_music_search_delegate.dart';
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
  bool _pickingFile = false;

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _performersController.dispose();
    super.dispose();
  }

  Future<void> _searchAppleMusic(BuildContext context) async {
    final result = await showSearch(
      context: context,
      delegate: AppleMusicSearchDelegate(ref),
    );
    if (result == null) return;
    _nameController.text = '${result.title} – ${result.artistName}';
    _urlController.text = result.toRecordingUrl();
    _performersController.text = result.artistName;
  }

  Future<void> _pickLocalFile() async {
    setState(() => _pickingFile = true);
    try {
      final result = await FilePicker.pickFiles(type: FileType.audio);
      if (result == null || result.files.isEmpty) return;

      final picked = result.files.first;
      final sourcePath = picked.path;
      if (sourcePath == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'File is not available locally — download it first.',
              ),
            ),
          );
        }
        return;
      }

      // Copy file into the app's documents directory so the URI stays valid.
      final docsDir = await getApplicationDocumentsDirectory();
      final destDir = Directory(p.join(docsDir.path, 'audio_recordings'));
      await destDir.create(recursive: true);

      final filename = _uniqueFilename(destDir, picked.name);
      final destFile = await File(
        sourcePath,
      ).copy(p.join(destDir.path, filename));

      if (!mounted) return;
      final fileUri = 'file://${destFile.path}';
      _urlController.text = fileUri;
      if (_nameController.text.trim().isEmpty) {
        _nameController.text = p.basenameWithoutExtension(filename);
      }
    } finally {
      if (mounted) setState(() => _pickingFile = false);
    }
  }

  // Appends _2, _3, … if a file with the same name already exists.
  String _uniqueFilename(Directory dir, String name) {
    final ext = p.extension(name);
    final base = p.basenameWithoutExtension(name);
    var candidate = name;
    var counter = 2;
    while (File(p.join(dir.path, candidate)).existsSync()) {
      candidate = '${base}_$counter$ext';
      counter++;
    }
    return candidate;
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
            performers: drift.Value(performers.isEmpty ? null : performers),
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
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.library_music, size: 18),
                  label: const Text('Search Apple Music'),
                  onPressed: () => _searchAppleMusic(context),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  icon: _pickingFile
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.audio_file_outlined, size: 18),
                  label: const Text('Local File'),
                  onPressed: _pickingFile ? null : _pickLocalFile,
                ),
              ),
            ],
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
