import 'package:flutter/material.dart';
import 'package:tune_catcher/model/database.dart';
import 'package:tune_catcher/model/tables/tunes.dart';

String tuneStatusToString(TuneStatus? status) {
  if (status == null) {
    return "";
  }

  switch (status) {
    case TuneStatus.todo:
      return "Todo";
    case TuneStatus.canPlay:
      return "Can play";
    case TuneStatus.canStart:
      return "Can start";
    case TuneStatus.inSet:
      return "In set";
    case TuneStatus.mastered:
      return "Mastered";
  }
}

class TuneListItem extends StatelessWidget {
  const TuneListItem({required this.tune});

  final Tune tune;

  @override
  Widget build(BuildContext context) {
    var subtitleString = "";

    // Build subtitle
    if (tune.key != null) {
      subtitleString += tune.key!;
    }

    if (tune.type != null) {
      if (tune.key != null) {
        subtitleString += " ";
      }
      subtitleString += tune.type!.name;
    }

    if (tune.from != null && tune.from!.isNotEmpty) {
      if (subtitleString.isNotEmpty) subtitleString += " ";

      subtitleString += "from ${tune.from}";
    }

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(tune.name),
                if (tune.status != null)
                  Text("Status: ${tuneStatusToString(tune.status)}"),
              ],
            ),
            subtitle: Text(subtitleString),
          ),
        ],
      ),
    );
  }
}
