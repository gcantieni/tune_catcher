import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tune_catcher/feat/audio_player/audio_player_backend.dart';
import 'package:tune_catcher/feat/audio_player/audio_player_state.dart';
import 'package:tune_catcher/feat/music_kit/music_kit_constants.dart';
import 'package:tune_catcher/feat/music_kit/music_kit_models.dart';
import 'package:tune_catcher/feat/music_kit/music_kit_service.dart';

class MusicKitBackend implements AudioPlayerBackend {
  final MusicKitService _service;
  final _controller = StreamController<AudioPlayerState>.broadcast();
  StreamSubscription<MusicKitPlaybackState>? _sub;

  MusicKitBackend(this._service) {
    _sub = _service.playbackState.listen(
      (mk) => _controller.add(_toState(mk)),
      onError: _controller.addError,
    );
  }

  AudioPlayerState _toState(MusicKitPlaybackState mk) {
    return AudioPlayerState(
      trackUri: '$kAppleMusicCatalogScheme:${mk.catalogId}',
      status: _toStatus(mk.status),
      position: mk.position,
      duration: mk.duration,
      title: mk.title,
      subtitle: mk.artistName.isEmpty ? null : mk.artistName,
    );
  }

  AudioPlaybackStatus _toStatus(String status) {
    switch (status) {
      case 'playing':
        return AudioPlaybackStatus.playing;
      case 'paused':
        return AudioPlaybackStatus.paused;
      default:
        return AudioPlaybackStatus.stopped;
    }
  }

  @override
  Stream<AudioPlayerState> get stateStream => _controller.stream;

  @override
  Future<void> play(String trackUri, {double? startTime}) {
    final catalogId = catalogIdFromUrl(trackUri) ?? trackUri;
    return _service.play(MusicKitPlayParams(
      catalogId: catalogId,
      startTime: startTime,
    ));
  }

  @override
  Future<void> pause() => _service.pause();

  @override
  Future<void> resume() => _service.resume();

  @override
  Future<void> stop() => _service.stop();

  @override
  Future<void> seek(double positionSeconds) => _service.seek(positionSeconds);

  @override
  Future<void> setPlaybackRate(double rate) => _service.setPlaybackRate(rate);

  @override
  void dispose() {
    _sub?.cancel();
    _controller.close();
  }
}

final musicKitBackendProvider = Provider<MusicKitBackend>((ref) {
  final backend = MusicKitBackend(ref.watch(musicKitServiceProvider));
  ref.onDispose(backend.dispose);
  return backend;
});
