import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tune_catcher/feat/tune_list/tune_list_item.dart';
import 'package:tune_catcher/model/database.dart';
import 'package:tune_catcher/model/database_provider.dart';
import 'package:tune_catcher/model/providers/tunes_provider.dart';
import 'package:tune_catcher/model/tables/tunes.dart';

class TuneDetailPage extends ConsumerStatefulWidget {
  final int tuneId;

  const TuneDetailPage({required this.tuneId, super.key});

  @override
  ConsumerState<TuneDetailPage> createState() => _TuneDetailPageState();
}

class _TuneDetailPageState extends ConsumerState<TuneDetailPage> {
  bool _editing = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _keyController = TextEditingController();
  final _fromController = TextEditingController();
  final _abcController = TextEditingController();
  TuneType? _type;
  TuneStatus? _status;

  @override
  void dispose() {
    _nameController.dispose();
    _keyController.dispose();
    _fromController.dispose();
    _abcController.dispose();
    super.dispose();
  }

  void _enterEdit(Tune tune) {
    _nameController.text = tune.name;
    _keyController.text = tune.key ?? '';
    _fromController.text = tune.from ?? '';
    _abcController.text = tune.abc ?? '';
    _type = tune.type;
    _status = tune.status;
    setState(() => _editing = true);
  }

  void _cancelEdit() {
    setState(() => _editing = false);
  }

  Future<void> _save(Tune tune) async {
    if (!_formKey.currentState!.validate()) return;

    final keyText = _keyController.text.trim();
    final fromText = _fromController.text.trim();
    final abcText = _abcController.text.trim();

    await ref
        .read(databaseProvider)
        .tuneDao
        .updateTune(
          TunesCompanion(
            id: drift.Value(tune.id),
            name: drift.Value(_nameController.text.trim()),
            key: drift.Value(keyText.isEmpty ? null : keyText),
            from: drift.Value(fromText.isEmpty ? null : fromText),
            abc: drift.Value(abcText.isEmpty ? null : abcText),
            type: drift.Value(_type),
            status: drift.Value(_status),
            modifiedAt: drift.Value(DateTime.now()),
          ),
        );

    if (!mounted) return;
    setState(() => _editing = false);
  }

  @override
  Widget build(BuildContext context) {
    final tuneAsync = ref.watch(singleTuneProvider(widget.tuneId));

    return Scaffold(
      appBar: AppBar(
        title: tuneAsync.maybeWhen(
          data: (tune) => Text(tune?.name ?? 'Tune'),
          orElse: () => const Text('Tune'),
        ),
        actions: tuneAsync.maybeWhen(
          data: (tune) {
            if (tune == null) return const <Widget>[];
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
                  onPressed: () => _save(tune),
                ),
              ];
            }
            return [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Edit',
                onPressed: () => _enterEdit(tune),
              ),
            ];
          },
          orElse: () => const <Widget>[],
        ),
      ),
      body: tuneAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (tune) {
          if (tune == null) {
            return const Center(child: Text('Tune not found'));
          }
          return _editing ? _buildEditForm(tune) : _buildReadView(tune);
        },
      ),
    );
  }

  Widget _buildReadView(Tune tune) {
    final statusLabel = tuneStatusToString(tune.status);
    final abc = tune.abc;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _readRow('Name', tune.name),
        _readRow('Key', tune.key ?? '—'),
        _readRow('Type', tune.type?.name ?? '—'),
        _readRow('Status', statusLabel.isEmpty ? '—' : statusLabel),
        _readRow('From', (tune.from?.isEmpty ?? true) ? '—' : tune.from!),
        const SizedBox(height: 16),
        const Text('ABC', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(6),
          ),
          child: SelectableText(
            (abc == null || abc.isEmpty) ? '—' : abc,
            style: const TextStyle(fontFamily: 'monospace'),
          ),
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

  Widget _buildEditForm(Tune tune) {
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
            controller: _keyController,
            decoration: const InputDecoration(labelText: 'Key'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<TuneType?>(
            initialValue: _type,
            decoration: const InputDecoration(labelText: 'Type'),
            items: [
              const DropdownMenuItem<TuneType?>(child: Text('—')),
              for (final t in TuneType.values)
                DropdownMenuItem<TuneType?>(value: t, child: Text(t.name)),
            ],
            onChanged: (v) => setState(() => _type = v),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<TuneStatus?>(
            initialValue: _status,
            decoration: const InputDecoration(labelText: 'Status'),
            items: [
              const DropdownMenuItem<TuneStatus?>(child: Text('—')),
              for (final s in TuneStatus.values)
                DropdownMenuItem<TuneStatus?>(
                  value: s,
                  child: Text(tuneStatusToString(s)),
                ),
            ],
            onChanged: (v) => setState(() => _status = v),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _fromController,
            decoration: const InputDecoration(labelText: 'From'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _abcController,
            decoration: const InputDecoration(
              labelText: 'ABC',
              alignLabelWithHint: true,
            ),
            minLines: 4,
            maxLines: 12,
            style: const TextStyle(fontFamily: 'monospace'),
          ),
        ],
      ),
    );
  }
}
