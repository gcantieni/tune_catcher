import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tune_catcher/feat/recording_list/recording_link_kind.dart';
import 'package:tune_catcher/model/database.dart';
import 'package:tune_catcher/model/database_provider.dart';
import 'package:tune_catcher/model/providers/recordings_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RecordingDetailPage extends ConsumerStatefulWidget {
  final int recordingId;

  const RecordingDetailPage({required this.recordingId, super.key});

  @override
  ConsumerState<RecordingDetailPage> createState() =>
      _RecordingDetailPageState();
}

class _RecordingDetailPageState extends ConsumerState<RecordingDetailPage> {
  bool _editing = false;
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

  void _enterEdit(Recording r) {
    _nameController.text = r.name;
    _urlController.text = r.url;
    _performersController.text = r.performers ?? '';
    setState(() => _editing = true);
  }

  void _cancelEdit() {
    setState(() => _editing = false);
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not open $url')));
    }
  }

  Future<void> _save(Recording r) async {
    if (!_formKey.currentState!.validate()) return;

    final performersText = _performersController.text.trim();

    final updated = r.copyWith(
      name: _nameController.text.trim(),
      url: _urlController.text.trim(),
      performers: drift.Value(
        performersText.isEmpty ? null : performersText,
      ),
      modifiedAt: drift.Value(DateTime.now()),
    );

    await ref.read(databaseProvider).recordingDao.updateRecording(updated);

    if (!mounted) return;
    setState(() => _editing = false);
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(singleRecordingProvider(widget.recordingId));

    return Scaffold(
      appBar: AppBar(
        title: async.maybeWhen(
          data: (r) => Text(r?.name ?? 'Recording'),
          orElse: () => const Text('Recording'),
        ),
        actions: async.maybeWhen(
          data: (r) {
            if (r == null) return const <Widget>[];
            if (_editing) {
              return [
                IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: 'Cancel',
                  onPressed: _cancelEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.check),
                  tooltip: 'Save',
                  onPressed: () => _save(r),
                ),
              ];
            }
            return [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Edit',
                onPressed: () => _enterEdit(r),
              ),
            ];
          },
          orElse: () => const <Widget>[],
        ),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (r) {
          if (r == null) {
            return const Center(child: Text('Recording not found'));
          }
          return _editing ? _buildEditForm(r) : _buildReadView(r);
        },
      ),
    );
  }

  Widget _buildReadView(Recording r) {
    final kind = recordingLinkKindOf(r.url);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _readRow('Name', r.name),
        const SizedBox(height: 8),
        Row(
          children: [
            const SizedBox(
              width: 100,
              child: Text(
                'URL',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Icon(iconForLinkKind(kind), size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: SelectableText(
                r.url,
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.open_in_new, size: 18),
              tooltip: 'Open URL',
              onPressed: () => _openUrl(r.url),
            ),
            IconButton(
              icon: const Icon(Icons.copy, size: 18),
              tooltip: 'Copy URL',
              onPressed: () => Clipboard.setData(ClipboardData(text: r.url)),
            ),
          ],
        ),
        _readRow(
          'Performers',
          (r.performers?.isEmpty ?? true) ? '—' : r.performers!,
        ),
      ],
    );
  }

  Widget _readRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildEditForm(Recording r) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
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
            decoration: const InputDecoration(labelText: 'URL'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _performersController,
            decoration: const InputDecoration(labelText: 'Performers'),
          ),
        ],
      ),
    );
  }
}
