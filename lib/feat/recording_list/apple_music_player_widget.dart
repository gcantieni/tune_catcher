import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tune_catcher/feat/music_kit/music_kit_constants.dart';
import 'package:tune_catcher/feat/music_kit/music_kit_models.dart';
import 'package:tune_catcher/feat/music_kit/music_kit_notifier.dart';

class AppleMusicPlayerWidget extends ConsumerStatefulWidget {
  final String recordingUrl; // music-catalog:<catalogId>

  const AppleMusicPlayerWidget({required this.recordingUrl, super.key});

  @override
  ConsumerState<AppleMusicPlayerWidget> createState() =>
      _AppleMusicPlayerWidgetState();
}

class _AppleMusicPlayerWidgetState
    extends ConsumerState<AppleMusicPlayerWidget> {
  String? _catalogId;

  @override
  void initState() {
    super.initState();
    _catalogId = catalogIdFromUrl(widget.recordingUrl);
  }

  @override
  void dispose() {
    ref.read(musicKitProvider.notifier).stop();
    super.dispose();
  }

  Future<void> _play() async {
    final id = _catalogId;
    if (id == null) return;
    await ref
        .read(musicKitProvider.notifier)
        .play(MusicKitPlayParams(catalogId: id));
  }

  @override
  Widget build(BuildContext context) {
    final musicKit = ref.watch(musicKitProvider);

    return musicKit.when(
      loading: () => const SizedBox.shrink(),
      error: (e, _) => Text('Apple Music error: $e'),
      data: (state) {
        if (state.authStatus != 'authorized') {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: OutlinedButton.icon(
              icon: const Icon(Icons.library_music, size: 18),
              label: const Text('Allow Apple Music access'),
              onPressed: () =>
                  ref.read(musicKitProvider.notifier).authorize(),
            ),
          );
        }

        if (_catalogId == null) {
          return const Text('Invalid Apple Music URL');
        }

        final playback = state.playback;
        final isCurrentTrack =
            playback != null && playback.catalogId == _catalogId;
        final isPlaying = isCurrentTrack && playback.isPlaying;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.library_music, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Apple Music',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause_circle : Icons.play_circle,
                        size: 36,
                      ),
                      onPressed: () {
                        if (isPlaying) {
                          ref.read(musicKitProvider.notifier).pause();
                        } else if (isCurrentTrack && playback.isPaused) {
                          ref.read(musicKitProvider.notifier).resume();
                        } else {
                          _play();
                        }
                      },
                    ),
                  ],
                ),
                if (isCurrentTrack) ...[
                  const SizedBox(height: 4),
                  const LinearProgressIndicator(),
                  const SizedBox(height: 4),
                  Text(
                    _formatPosition(playback.position),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatPosition(double seconds) {
    final m = seconds ~/ 60;
    final s = (seconds % 60).toStringAsFixed(0).padLeft(2, '0');
    return '$m:$s';
  }
}
