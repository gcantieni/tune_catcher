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
  double? _dragValue;
  bool _isLooping = false;
  double _loopStart = 0;
  double _loopEnd = 0;
  double _playbackRate = 1.0;

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
    await ref.read(musicKitProvider.notifier).play(MusicKitPlayParams(
      catalogId: id,
      startTime: _isLooping ? _loopStart : null,
    ));
  }

  void _toggleLoop(double duration) {
    setState(() {
      _isLooping = !_isLooping;
      if (_isLooping) {
        _loopStart = 0;
        _loopEnd = duration > 0 ? duration : 60;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<MusicKitState>>(musicKitProvider, (prev, next) {
      final prevPlayback = prev?.valueOrNull?.playback;
      final playback = next.valueOrNull?.playback;
      if (!_isLooping || playback?.catalogId != _catalogId) return;

      if (playback!.isPlaying) {
        final pos = playback.position;
        if (pos < _loopStart || pos >= _loopEnd) {
          ref.read(musicKitProvider.notifier).seek(_loopStart);
        }
      } else if (playback.isStopped && prevPlayback?.isPlaying == true) {
        _play();
      }
    });

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
        final duration = playback?.duration ?? 0;

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
                        Icons.repeat,
                        size: 22,
                        color: _isLooping
                            ? Theme.of(context).colorScheme.tertiary
                            : null,
                      ),
                      onPressed: () => _toggleLoop(duration),
                    ),
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
                  _buildPlaybackSlider(context, playback),
                  if (_isLooping) ...[
                    const SizedBox(height: 8),
                    _buildLoopRangeSlider(context, duration),
                  ],
                  const SizedBox(height: 8),
                  _buildSpeedSlider(context),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaybackSlider(
      BuildContext context, MusicKitPlaybackState playback) {
    final duration = playback.duration;
    final position = _dragValue ?? playback.position;
    final sliderValue = duration > 0 ? position.clamp(0.0, duration) : 0.0;
    final labelStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      fontFamily: 'monospace',
      fontSize: 11,
    );

    return Column(
      children: [
        Slider(
          value: duration > 0 ? sliderValue : 0.0,
          min: 0,
          max: duration > 0 ? duration : 1,
          onChanged: duration > 0
              ? (v) => setState(() => _dragValue = v)
              : null,
          onChangeEnd: duration > 0
              ? (v) {
                  ref.read(musicKitProvider.notifier).seek(v);
                  setState(() => _dragValue = null);
                }
              : null,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatTime(position), style: labelStyle),
              Text(_formatTime(duration), style: labelStyle),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoopRangeSlider(BuildContext context, double duration) {
    if (duration <= 0) return const SizedBox.shrink();
    final tertiary = Theme.of(context).colorScheme.tertiary;
    final labelStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      fontFamily: 'monospace',
      fontSize: 11,
      color: tertiary,
    );

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: tertiary,
            thumbColor: tertiary,
            inactiveTrackColor: tertiary.withValues(alpha: 0.24),
            overlayColor: tertiary.withValues(alpha: 0.12),
          ),
          child: RangeSlider(
          values: RangeValues(
            _loopStart.clamp(0.0, duration),
            _loopEnd.clamp(0.0, duration),
          ),
          min: 0,
          max: duration,
          onChanged: (values) => setState(() {
            _loopStart = values.start;
            _loopEnd = values.end;
          }),
        ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatTime(_loopStart), style: labelStyle),
              Text(_formatTime(_loopEnd), style: labelStyle),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpeedSlider(BuildContext context) {
    final pct = (_playbackRate * 100).round();
    final scheme = Theme.of(context).colorScheme;
    final labelStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      fontFamily: 'monospace',
      fontSize: 11,
    );
    final dimStyle = labelStyle?.copyWith(
      color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
    );

    return Column(
      children: [
        Slider(
          value: _playbackRate,
          min: 0.5,
          max: 1.5,
          onChanged: (v) => setState(() => _playbackRate = v),
          onChangeEnd: (v) =>
              ref.read(musicKitProvider.notifier).setPlaybackRate(v),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Text('50%', style: dimStyle),
              Expanded(
                child: Text(
                  '$pct%',
                  textAlign: TextAlign.center,
                  style: labelStyle,
                ),
              ),
              Text('150%', style: dimStyle),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTime(double seconds) {
    final s = seconds.round();
    final m = s ~/ 60;
    final sec = (s % 60).toString().padLeft(2, '0');
    return '$m:$sec';
  }
}
