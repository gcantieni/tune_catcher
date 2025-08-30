import 'package:flutter/material.dart';
import 'package:tune_catcher/model/database.dart';

class RecordingListTile extends StatelessWidget {
  final Recording recording;

  const RecordingListTile({required this.recording, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(recording.createdAt.toString()),
        Text(recording.filePath),
      ],
    );
  }
}
