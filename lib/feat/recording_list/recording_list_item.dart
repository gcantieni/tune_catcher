import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tune_catcher/feat/recording_list/recording_link_kind.dart';
import 'package:tune_catcher/model/database.dart';

class RecordingListItem extends StatelessWidget {
  const RecordingListItem({required this.recording, super.key});

  final Recording recording;

  @override
  Widget build(BuildContext context) {
    final kind = recordingLinkKindOf(recording.url);
    return Card(
      child: ListTile(
        onTap: () => context.push('/recording_list/${recording.id}'),
        leading: Icon(iconForLinkKind(kind)),
        title: Text(recording.name),
        subtitle: Text(
          recording.url,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
