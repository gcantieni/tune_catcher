import 'package:tune_catcher/feat/audio_player/audio_player_state.dart';

abstract class AudioPlayerBackend {
  Stream<AudioPlayerState> get stateStream;
  Future<void> play(String trackUri, {double? startTime});
  Future<void> pause();
  Future<void> resume();
  Future<void> stop();
  Future<void> seek(double positionSeconds);
  Future<void> setPlaybackRate(double rate);
  void dispose();
}
