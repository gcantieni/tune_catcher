import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tune_catcher/feat/recording_list/recording_link_kind.dart';
import 'package:tune_catcher/model/accessors/tune_recording_dao.dart';
import 'package:tune_catcher/model/database.dart';
import 'package:tune_catcher/model/database_provider.dart';
import 'package:tune_catcher/model/providers/recordings_provider.dart';
import 'package:tune_catcher/model/providers/tune_recording_provider.dart';
import 'package:tune_catcher/shared_widgets/timestamp_editor_dialog.dart';
import 'package:tune_catcher/shared_widgets/tune_picker_dialog.dart';
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
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text(
              'Tunes',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const Spacer(),
            TextButton.icon(
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add tune'),
              onPressed: () => _showAddTuneDialog(r.id),
            ),
          ],
        ),
        const SizedBox(height: 4),
        _LinkedTunes(recordingId: r.id),
      ],
    );
  }

  void _showAddTuneDialog(int recordingId) {
    final dao = ref.read(databaseProvider).tuneRecordingDao;
    showDialog<void>(
      context: context,
      builder: (_) => TunePickerDialog(
        title: 'Add tune to recording',
        onLibraryTune: (tune) {
          dao.linkTuneToRecording(tune.id, recordingId);
        },
        onThesessionTune: (companion) {
          dao.createTuneAndLink(
            companion.copyWith(createdAt: drift.Value(DateTime.now())),
            recordingId,
          );
        },
        onCreateNew: (name) {
          dao.createTuneAndLink(
            TunesCompanion.insert(name: name, createdAt: DateTime.now()),
            recordingId,
          );
        },
      ),
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

class _LinkedTunes extends ConsumerWidget {
  final int recordingId;
  const _LinkedTunes({required this.recordingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(linksForRecordingProvider(recordingId));
    return async.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(8),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, s) => Text('Error: $e'),
      data: (links) {
        if (links.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'No tunes linked yet.',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }
        return Column(
          children: [for (final e in links) _LinkedTuneRow(entry: e)],
        );
      },
    );
  }
}

class _LinkedTuneRow extends ConsumerWidget {
  final RecordedTune entry;
  const _LinkedTuneRow({required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tune = entry.tune;
    final link = entry.link;
    final subtitle = [
      if (tune.type != null) tune.type!.name,
      if (tune.key != null && tune.key!.isNotEmpty) tune.key!,
    ].join(' · ');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        title: Text(tune.name),
        subtitle: subtitle.isEmpty ? null : Text(subtitle),
        onTap: () => context.push('/tune_list/${tune.id}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () => _editTimes(context, ref),
              child: Text(
                '${formatSeconds(link.startTime)} – ${formatSeconds(link.endTime)}',
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              tooltip: 'Remove from recording',
              onPressed: () => ref
                  .read(databaseProvider)
                  .tuneRecordingDao
                  .unlinkTuneFromRecording(link.tuneId, link.recordingId),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editTimes(BuildContext context, WidgetRef ref) async {
    final link = entry.link;
    final result = await showDialog<({int? start, int? end})>(
      context: context,
      builder: (_) => TimestampEditorDialog(
        initialStart: link.startTime,
        initialEnd: link.endTime,
      ),
    );
    if (result == null) return;
    final updated = link.copyWith(
      startTime: drift.Value(result.start),
      endTime: drift.Value(result.end),
    );
    await ref.read(databaseProvider).tuneRecordingDao.updateLink(updated);
  }
}
