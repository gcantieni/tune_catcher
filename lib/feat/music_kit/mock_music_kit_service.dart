import 'dart:async';

import 'package:tune_catcher/feat/music_kit/music_kit_models.dart';
import 'package:tune_catcher/feat/music_kit/music_kit_service.dart';

// Fake catalog entries for testing without the MusicKit entitlement.
const _fakeResults = [
  MusicKitSearchResult(
    kind: 'song',
    id: 'mock-001',
    title: 'The Morning Dew',
    artistName: 'Planxty',
    albumTitle: 'Cold Blow and the Rainy Night',
    durationMs: 214000,
    artworkUrl: '',
  ),
  MusicKitSearchResult(
    kind: 'song',
    id: 'mock-002',
    title: 'The Bucks of Oranmore',
    artistName: 'The Chieftains',
    albumTitle: 'The Chieftains 2',
    durationMs: 182000,
    artworkUrl: '',
  ),
  MusicKitSearchResult(
    kind: 'album',
    id: 'mock-003',
    title: 'Prosperous',
    artistName: 'Christy Moore',
    albumTitle: 'Prosperous',
    durationMs: 0,
    artworkUrl: '',
  ),
  MusicKitSearchResult(
    kind: 'artist',
    id: 'mock-004',
    title: 'The Dubliners',
    artistName: 'The Dubliners',
    albumTitle: '',
    durationMs: 0,
    artworkUrl: '',
  ),
];

class MockMusicKitService implements MusicKitService {
  final _stateController = StreamController<MusicKitPlaybackState>.broadcast();
  Timer? _positionTimer;
  double _position = 0;
  String _status = 'stopped';
  MusicKitSearchResult? _currentTrack;

  @override
  Future<String> authorize() async => 'authorized';

  @override
  Future<String> authorizationStatus() async => 'authorized';

  @override
  Future<List<MusicKitSearchResult>> search(
    String query, {
    List<String> types = const ['songs', 'albums', 'artists'],
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (query.trim().isEmpty) return [];
    return _fakeResults
        .where((r) => types.contains('${r.kind}s') || types.contains(r.kind))
        .toList();
  }

  @override
  Future<void> play(MusicKitPlayParams params) async {
    _currentTrack = _fakeResults.firstWhere(
      (r) => r.id == params.catalogId,
      orElse: () => _fakeResults.first,
    );
    _position = params.startTime ?? 0;
    _status = 'playing';
    _emitStatus();
    _startTimer(endTime: params.endTime);
  }

  @override
  Future<void> pause() async {
    _status = 'paused';
    _positionTimer?.cancel();
    _emitStatus();
  }

  @override
  Future<void> resume() async {
    _status = 'playing';
    _emitStatus();
    _startTimer();
  }

  @override
  Future<void> stop() async {
    _positionTimer?.cancel();
    _status = 'stopped';
    _position = 0;
    _emitStatus();
  }

  @override
  Future<void> seek(double positionSeconds) async {
    _position = positionSeconds;
    _emitPosition();
  }

  @override
  Future<void> setPlaybackRate(double rate) async {}

  @override
  Future<void> setRepeatMode(String mode) async {}

  @override
  Stream<MusicKitPlaybackState> get playbackState => _stateController.stream;

  @override
  void dispose() {
    _positionTimer?.cancel();
    _stateController.close();
  }

  void _startTimer({double? endTime}) {
    _positionTimer?.cancel();
    final trackDuration = (_currentTrack?.durationMs ?? 0) / 1000.0;
    _positionTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      _position += 0.1;
      final limit = endTime ?? (trackDuration > 0 ? trackDuration : null);
      if (limit != null && _position >= limit) {
        stop();
        return;
      }
      _emitPosition();
    });
  }

  void _emitStatus() {
    _stateController.add(MusicKitPlaybackState(
      event: 'statusChanged',
      status: _status,
      position: _position,
      duration: (_currentTrack?.durationMs ?? 0) / 1000.0,
      catalogId: _currentTrack?.id ?? '',
      title: _currentTrack?.title ?? '',
      artistName: _currentTrack?.artistName ?? '',
    ));
  }

  void _emitPosition() {
    _stateController.add(MusicKitPlaybackState(
      event: 'positionUpdate',
      status: _status,
      position: _position,
      duration: (_currentTrack?.durationMs ?? 0) / 1000.0,
      catalogId: _currentTrack?.id ?? '',
      title: _currentTrack?.title ?? '',
      artistName: _currentTrack?.artistName ?? '',
    ));
  }
}
