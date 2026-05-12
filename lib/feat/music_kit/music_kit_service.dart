import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tune_catcher/feat/music_kit/mock_music_kit_service.dart';
import 'package:tune_catcher/feat/music_kit/music_kit_models.dart';
import 'package:tune_catcher/feat/music_kit/platform_music_kit_service.dart';

// Activate with: flutter run --dart-define=MOCK_MUSICKIT=true
const _useMock = bool.fromEnvironment('MOCK_MUSICKIT');

abstract class MusicKitService {
  Future<String> authorize();
  Future<String> authorizationStatus();

  Future<List<MusicKitSearchResult>> search(
    String query, {
    List<String> types = const ['songs', 'albums', 'artists'],
  });

  Future<void> play(MusicKitPlayParams params);
  Future<void> pause();
  Future<void> resume();
  Future<void> stop();
  Future<void> seek(double positionSeconds);
  Future<void> setPlaybackRate(double rate);
  Future<void> setRepeatMode(String mode);

  Stream<MusicKitPlaybackState> get playbackState;

  void dispose();
}

final musicKitServiceProvider = Provider<MusicKitService>((ref) {
  final service = _useMock ? MockMusicKitService() : PlatformMusicKitService();
  ref.onDispose(service.dispose);
  return service;
});
