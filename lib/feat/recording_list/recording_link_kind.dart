import 'package:flutter/material.dart';

enum RecordingLinkKind { youtube, spotify, file, generic }

RecordingLinkKind recordingLinkKindOf(String url) {
  final trimmed = url.trim().toLowerCase();
  if (trimmed.isEmpty) return RecordingLinkKind.generic;
  if (trimmed.startsWith('app-data:') || trimmed.startsWith('file:')) {
    return RecordingLinkKind.file;
  }
  final uri = Uri.tryParse(trimmed);
  final host = uri?.host ?? '';
  if (host.contains('youtube.com') || host.contains('youtu.be')) {
    return RecordingLinkKind.youtube;
  }
  if (host.contains('spotify.com') || trimmed.startsWith('spotify:')) {
    return RecordingLinkKind.spotify;
  }
  return RecordingLinkKind.generic;
}

IconData iconForLinkKind(RecordingLinkKind kind) {
  switch (kind) {
    case RecordingLinkKind.youtube:
      return Icons.smart_display;
    case RecordingLinkKind.spotify:
      return Icons.music_note;
    case RecordingLinkKind.file:
      return Icons.audio_file_outlined;
    case RecordingLinkKind.generic:
      return Icons.link;
  }
}
