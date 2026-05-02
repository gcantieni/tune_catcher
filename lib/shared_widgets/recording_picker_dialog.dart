import 'dart:async';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;

import 'package:tune_catcher/model/database.dart';
import 'package:tune_catcher/model/providers/recordings_provider.dart';

const _debounceDelay = Duration(milliseconds: 100);
const _titleFetchTimeout = Duration(seconds: 5);

/// A search-driven recording picker. Lists recordings already in the
/// library and lets the caller link the chosen one. When the typed
/// query looks like a URL, the dialog swaps to an inline create form
/// (name + optional performers) so the user can name the recording in
/// context. For http(s) URLs we try to scrape the page title in the
/// background to seed the Name field; on any failure (offline, non-200,
/// non-http scheme) the field stays empty for the user to fill in.
class RecordingPickerDialog extends ConsumerStatefulWidget {
  final String title;
  final void Function(Recording recording) onPicked;
  final void Function(RecordingsCompanion recording) onCreateNew;

  const RecordingPickerDialog({
    required this.title,
    required this.onPicked,
    required this.onCreateNew,
    super.key,
  });

  @override
  ConsumerState<RecordingPickerDialog> createState() =>
      _RecordingPickerDialogState();
}

class _RecordingPickerDialogState extends ConsumerState<RecordingPickerDialog> {
  final _searchController = TextEditingController();
  String _debouncedQuery = '';
  Timer? _debounceTimer;

  // Set when the user commits to creating: switches the dialog into
  // create-form mode for that URL.
  String? _createUrl;
  final _nameController = TextEditingController();
  final _performersController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _fetchingTitle = false;
  // Tracks the in-flight fetch so a stale response can't clobber a
  // newer create-mode session or a name the user has typed.
  int _fetchSeq = 0;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _fetchSeq++; // invalidate any in-flight fetch
    _searchController.dispose();
    _nameController.dispose();
    _performersController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDelay, () {
      if (!mounted) return;
      setState(
        () => _debouncedQuery = _searchController.text.trim().toLowerCase(),
      );
    });
  }

  void _pick(Recording r) {
    Navigator.of(context).pop();
    widget.onPicked(r);
  }

  void _enterCreateMode(String url) {
    setState(() {
      _createUrl = url;
      _nameController.clear();
      _performersController.clear();
      _fetchingTitle = false;
    });
    _maybeFetchTitle(url);
  }

  void _cancelCreate() {
    _fetchSeq++; // ignore any in-flight fetch result
    setState(() {
      _createUrl = null;
      _fetchingTitle = false;
    });
  }

  Future<void> _maybeFetchTitle(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (uri.scheme != 'http' && uri.scheme != 'https') return;

    final mySeq = ++_fetchSeq;
    setState(() => _fetchingTitle = true);

    final title = await _fetchPageTitle(uri);

    if (!mounted || mySeq != _fetchSeq) return;
    setState(() => _fetchingTitle = false);
    // Don't clobber a name the user has already typed.
    if (title != null && title.isNotEmpty && _nameController.text.isEmpty) {
      _nameController.text = title;
    }
  }

  void _submitCreate() {
    if (!_formKey.currentState!.validate()) return;
    final url = _createUrl!;
    final performers = _performersController.text.trim();
    final companion = RecordingsCompanion.insert(
      name: _nameController.text.trim(),
      url: url,
      createdAt: DateTime.now(),
      performers: drift.Value(performers.isEmpty ? null : performers),
    );
    Navigator.of(context).pop();
    widget.onCreateNew(companion);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 600,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: _createUrl == null ? _buildSearchView() : _buildCreateForm(),
        ),
      ),
    );
  }

  Widget _buildSearchView() {
    final query = _debouncedQuery;
    final recordingsAsync = ref.watch(allRecordingsProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Recording name or URL',
            hintText: 'Type to search, or paste a URL…',
          ),
        ),
        const SizedBox(height: 12),
        Flexible(
          child: recordingsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Text('Error: $e'),
            data: (recordings) => _buildSuggestions(query, recordings),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestions(String query, List<Recording> all) {
    final raw = _searchController.text.trim();
    final matches = query.isEmpty
        ? all
        : all.where((r) => r.name.toLowerCase().contains(query)).toList();
    final urlToCreate = looksLikeUrl(raw) ? raw : null;

    if (matches.isEmpty && urlToCreate == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          query.isEmpty
              ? 'No recordings yet — paste a URL to add one.'
              : 'No matching recordings. Paste a URL to add a new one.',
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView(
      shrinkWrap: true,
      children: [
        for (final r in matches)
          _RecordingTile(recording: r, onTap: () => _pick(r)),
        if (urlToCreate != null) ...[
          if (matches.isNotEmpty) const SizedBox(height: 8),
          _CreateRecordingFromUrlTile(
            url: urlToCreate,
            onTap: () => _enterCreateMode(urlToCreate),
          ),
        ],
      ],
    );
  }

  Widget _buildCreateForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'New recording',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.link, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  _createUrl!,
                  style: const TextStyle(fontFamily: 'monospace'),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Name',
              suffixIcon: _fetchingTitle
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : null,
              helperText: _fetchingTitle ? 'Fetching page title…' : null,
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
            onFieldSubmitted: (_) => _submitCreate(),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _performersController,
            decoration: const InputDecoration(labelText: 'Performers'),
            onFieldSubmitted: (_) => _submitCreate(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _cancelCreate,
                child: const Text('Back'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _submitCreate,
                child: const Text('Create and link'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Treat as a URL anything Uri.parse accepts that has a non-empty scheme,
/// e.g. `https://…`, `spotify:…`, `app-data:…`. Keeps logic permissive so
/// the user isn't blocked on quirky scheme strings.
bool looksLikeUrl(String s) {
  if (s.isEmpty) return false;
  final uri = Uri.tryParse(s);
  return uri != null && uri.hasScheme && uri.scheme.isNotEmpty;
}

/// Best-effort scrape of an http(s) page title. Prefers OpenGraph
/// `og:title` (cleaner than `<title>` on most music/video sites), falls
/// back to `<title>`. Returns null on any failure — callers should
/// treat that as "leave the field empty".
Future<String?> _fetchPageTitle(Uri uri) async {
  try {
    final response = await http
        .get(
          uri,
          headers: const {
            // Some sites (YouTube etc.) gate metadata behind a UA check.
            'User-Agent':
                'Mozilla/5.0 (compatible; TuneCatcher/1.0; +https://tunecatcher.app)',
          },
        )
        .timeout(_titleFetchTimeout);
    if (response.statusCode != 200) return null;
    final document = html_parser.parse(response.body);
    final og = document
        .querySelector('meta[property="og:title"]')
        ?.attributes['content']
        ?.trim();
    if (og != null && og.isNotEmpty) return og;
    final title = document.querySelector('title')?.text.trim();
    if (title != null && title.isNotEmpty) return title;
    return null;
  } catch (_) {
    return null;
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

class _CreateRecordingFromUrlTile extends StatelessWidget {
  final String url;
  final VoidCallback onTap;
  const _CreateRecordingFromUrlTile({required this.url, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        leading: const Icon(Icons.add_link),
        title: const Text('Create new recording'),
        subtitle: Text(
          url,
          style: const TextStyle(fontFamily: 'monospace'),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: onTap,
      ),
    );
  }
}
