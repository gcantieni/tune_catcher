import 'package:flutter/material.dart';

/// Dialog that edits a (start, end) pair as `mm:ss` text fields. Returns
/// `({int? start, int? end})` on save, or `null` if cancelled. Either field
/// may be left blank to mean "unset".
class TimestampEditorDialog extends StatefulWidget {
  final int? initialStart;
  final int? initialEnd;

  const TimestampEditorDialog({this.initialStart, this.initialEnd, super.key});

  @override
  State<TimestampEditorDialog> createState() => _TimestampEditorDialogState();
}

class _TimestampEditorDialogState extends State<TimestampEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _startController;
  late final TextEditingController _endController;

  @override
  void initState() {
    super.initState();
    _startController = TextEditingController(
      text: widget.initialStart == null
          ? ''
          : formatSeconds(widget.initialStart),
    );
    _endController = TextEditingController(
      text: widget.initialEnd == null ? '' : formatSeconds(widget.initialEnd),
    );
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  String? _validate(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    return parseSeconds(raw) == null ? 'Use mm:ss or seconds' : null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop((
      start: parseSeconds(_startController.text),
      end: parseSeconds(_endController.text),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set timestamps'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _startController,
              decoration: const InputDecoration(
                labelText: 'Start',
                hintText: 'mm:ss (leave blank for none)',
              ),
              validator: _validate,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _endController,
              decoration: const InputDecoration(
                labelText: 'End',
                hintText: 'mm:ss (leave blank for none)',
              ),
              validator: _validate,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}

String formatSeconds(int? sec) {
  if (sec == null) return '—:—';
  final m = sec ~/ 60;
  final s = sec % 60;
  return '$m:${s.toString().padLeft(2, '0')}';
}

int? parseSeconds(String raw) {
  final s = raw.trim();
  if (s.isEmpty) return null;
  if (s.contains(':')) {
    final parts = s.split(':');
    if (parts.length != 2) return null;
    final m = int.tryParse(parts[0]);
    final sec = int.tryParse(parts[1]);
    if (m == null || sec == null || sec < 0 || sec >= 60 || m < 0) return null;
    return m * 60 + sec;
  }
  final n = int.tryParse(s);
  if (n == null || n < 0) return null;
  return n;
}
