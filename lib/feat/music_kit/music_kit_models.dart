import 'package:tune_catcher/feat/music_kit/music_kit_constants.dart';

class MusicKitSearchResult {
  final String kind; // "song" | "album" | "artist"
  final String id;
  final String title;
  final String artistName;
  final String albumTitle;
  final int durationMs;
  final String artworkUrl;

  const MusicKitSearchResult({
    required this.kind,
    required this.id,
    required this.title,
    required this.artistName,
    required this.albumTitle,
    required this.durationMs,
    required this.artworkUrl,
  });

  factory MusicKitSearchResult.fromMap(Map<Object?, Object?> map) {
    return MusicKitSearchResult(
      kind: map['kind'] as String? ?? '',
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      artistName: map['artistName'] as String? ?? '',
      albumTitle: map['albumTitle'] as String? ?? '',
      durationMs: map['durationMs'] as int? ?? 0,
      artworkUrl: map['artworkUrl'] as String? ?? '',
    );
  }

  String toRecordingUrl() => '$kAppleMusicCatalogScheme:$id';
}

class MusicKitPlaybackState {
  final String event; // "statusChanged" | "positionUpdate"
  final String status; // "playing" | "paused" | "stopped" | "interrupted" | "unknown"
  final double position; // seconds
  final double duration; // seconds
  final String catalogId;
  final String title;
  final String artistName;

  const MusicKitPlaybackState({
    required this.event,
    required this.status,
    required this.position,
    required this.duration,
    required this.catalogId,
    required this.title,
    required this.artistName,
  });

  factory MusicKitPlaybackState.fromMap(Map<Object?, Object?> map) {
    return MusicKitPlaybackState(
      event: map['event'] as String? ?? '',
      status: map['status'] as String? ?? 'unknown',
      position: (map['position'] as num?)?.toDouble() ?? 0.0,
      duration: ((map['durationMs'] as num?)?.toDouble() ?? 0.0) / 1000.0,
      catalogId: map['catalogId'] as String? ?? '',
      title: map['title'] as String? ?? '',
      artistName: map['artistName'] as String? ?? '',
    );
  }

  bool get isPlaying => status == 'playing';
  bool get isPaused => status == 'paused';
  bool get isStopped => status == 'stopped';
}

class MusicKitPlayParams {
  final String catalogId;
  final double? startTime;
  final double? endTime;
  final double playbackRate;
  final int loopCount; // 0 = no loop, -1 = infinite

  const MusicKitPlayParams({
    required this.catalogId,
    this.startTime,
    this.endTime,
    this.playbackRate = 1.0,
    this.loopCount = 0,
  });

  Map<String, Object?> toMap() => {
    'catalogId': catalogId,
    if (startTime != null) 'startTime': startTime,
    if (endTime != null) 'endTime': endTime,
    'playbackRate': playbackRate,
    'loopCount': loopCount,
  };
}
