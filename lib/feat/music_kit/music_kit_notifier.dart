import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tune_catcher/feat/music_kit/music_kit_models.dart';
import 'package:tune_catcher/feat/music_kit/music_kit_service.dart';

class MusicKitState {
  final String authStatus;
  final MusicKitPlaybackState? playback;
  final List<MusicKitSearchResult> searchResults;
  final bool isSearching;

  const MusicKitState({
    required this.authStatus,
    this.playback,
    this.searchResults = const [],
    this.isSearching = false,
  });

  MusicKitState copyWith({
    String? authStatus,
    MusicKitPlaybackState? playback,
    List<MusicKitSearchResult>? searchResults,
    bool? isSearching,
  }) => MusicKitState(
    authStatus: authStatus ?? this.authStatus,
    playback: playback ?? this.playback,
    searchResults: searchResults ?? this.searchResults,
    isSearching: isSearching ?? this.isSearching,
  );
}

class MusicKitNotifier extends AsyncNotifier<MusicKitState> {
  StreamSubscription<MusicKitPlaybackState>? _playbackSub;

  @override
  Future<MusicKitState> build() async {
    final service = ref.watch(musicKitServiceProvider);
    final authStatus = await service.authorizationStatus();

    _playbackSub?.cancel();
    _playbackSub = service.playbackState.listen((playback) {
      final current = state.valueOrNull;
      if (current != null) {
        state = AsyncData(current.copyWith(playback: playback));
      }
    });

    ref.onDispose(() => _playbackSub?.cancel());

    return MusicKitState(authStatus: authStatus);
  }

  Future<void> authorize() async {
    final service = ref.read(musicKitServiceProvider);
    final status = await service.authorize();
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncData(current.copyWith(authStatus: status));
    }
  }

  Future<void> search(String query) async {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(isSearching: true, searchResults: []));
    try {
      final results = await ref.read(musicKitServiceProvider).search(query);
      state = AsyncData(state.valueOrNull!.copyWith(isSearching: false, searchResults: results));
    } catch (_) {
      state = AsyncData(state.valueOrNull!.copyWith(isSearching: false));
      rethrow;
    }
  }

  Future<void> play(MusicKitPlayParams params) =>
      ref.read(musicKitServiceProvider).play(params);

  Future<void> pause() => ref.read(musicKitServiceProvider).pause();
  Future<void> resume() => ref.read(musicKitServiceProvider).resume();
  Future<void> stop() => ref.read(musicKitServiceProvider).stop();

  Future<void> seek(double position) =>
      ref.read(musicKitServiceProvider).seek(position);

  Future<void> setPlaybackRate(double rate) =>
      ref.read(musicKitServiceProvider).setPlaybackRate(rate);

  Future<void> setRepeatMode(String mode) =>
      ref.read(musicKitServiceProvider).setRepeatMode(mode);
}

final musicKitProvider =
    AsyncNotifierProvider<MusicKitNotifier, MusicKitState>(MusicKitNotifier.new);
