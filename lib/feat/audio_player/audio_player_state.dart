enum AudioPlaybackStatus { stopped, playing, paused, loading, error }

class AudioPlayerState {
  final String? trackUri;
  final AudioPlaybackStatus status;
  final double position;
  final double duration;
  final double playbackRate;
  final bool isLooping;
  final double loopStart;
  final double loopEnd;
  final String title;
  final String? subtitle;

  const AudioPlayerState({
    this.trackUri,
    this.status = AudioPlaybackStatus.stopped,
    this.position = 0,
    this.duration = 0,
    this.playbackRate = 1.0,
    this.isLooping = false,
    this.loopStart = 0,
    this.loopEnd = 0,
    this.title = '',
    this.subtitle,
  });

  bool get isPlaying => status == AudioPlaybackStatus.playing;
  bool get isPaused => status == AudioPlaybackStatus.paused;
  bool get isStopped => status == AudioPlaybackStatus.stopped;

  AudioPlayerState copyWith({
    AudioPlaybackStatus? status,
    double? position,
    double? duration,
    double? playbackRate,
    bool? isLooping,
    double? loopStart,
    double? loopEnd,
    String? title,
    String? subtitle,
  }) {
    return AudioPlayerState(
      trackUri: trackUri,
      status: status ?? this.status,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      playbackRate: playbackRate ?? this.playbackRate,
      isLooping: isLooping ?? this.isLooping,
      loopStart: loopStart ?? this.loopStart,
      loopEnd: loopEnd ?? this.loopEnd,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
    );
  }
}
