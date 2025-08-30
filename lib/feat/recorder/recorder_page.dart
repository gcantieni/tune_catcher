import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:tune_catcher/model/accessors/recording_dao.dart';
import 'package:tune_catcher/model/database.dart';

class RecorderPage extends StatelessWidget {
  final AppDatabase db = AppDatabase(
    drift.DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialButton(
        onPressed: createRecording,
        child: Text("Recorder Page"),
      ),
    );
  }

  createRecording() {
    final dao = RecordingDao(db);
    dao.insertRecording(
      RecordingsCompanion(
        createdAt: drift.Value(DateTime.now()),
        filePath: drift.Value('filePath'),
      ),
    );
  }
}
