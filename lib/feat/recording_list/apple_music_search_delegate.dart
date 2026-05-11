import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tune_catcher/feat/music_kit/music_kit_models.dart';
import 'package:tune_catcher/feat/music_kit/music_kit_notifier.dart';

class AppleMusicSearchDelegate extends SearchDelegate<MusicKitSearchResult?> {
  final WidgetRef ref;

  AppleMusicSearchDelegate(this.ref);

  @override
  String get searchFieldLabel => 'Search Apple Music…';

  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () => query = '',
    ),
  ];

  @override
  Widget buildLeading(BuildContext context) =>
      BackButton(onPressed: () => close(context, null));

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(musicKitProvider.notifier).search(query.trim());
      });
    }
    return _ResultList(onPick: (result) => close(context, result));
  }

  @override
  Widget buildSuggestions(BuildContext context) => const SizedBox.shrink();
}

class _ResultList extends ConsumerWidget {
  final void Function(MusicKitSearchResult) onPick;

  const _ResultList({required this.onPick});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(musicKitProvider);
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (state) {
        if (state.isSearching) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.searchResults.isEmpty) {
          return const Center(child: Text('No results'));
        }
        return ListView.builder(
          itemCount: state.searchResults.length,
          itemBuilder: (context, i) {
            final result = state.searchResults[i];
            return ListTile(
              leading: result.artworkUrl.isNotEmpty
                  ? Image.network(
                      result.artworkUrl,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          const Icon(Icons.library_music),
                    )
                  : const Icon(Icons.library_music),
              title: Text(result.title),
              subtitle: Text('${result.artistName} · ${result.kind}'),
              onTap: () => onPick(result),
            );
          },
        );
      },
    );
  }
}
