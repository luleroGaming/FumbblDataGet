import 'dart:convert';
import 'dart:io';

import 'package:fumbblDataGet/database/database.dart';

const bool online = false;
const int matchId = 4000001;

void main(List<String> arguments) async {
  final Database database = Database('../data/fumbbl/', online: online);

  // Fetch match data
  final String matchString = await database.getMatch(matchId);
  if (matchString.isEmpty) {
    print("Empty match");
    if (!online) print("Friendly reminder that database is offline");
    exit(0);
  }

  // Read replayId from match data
  final matchObject = jsonDecode(matchString);
  final int replayId = matchObject["replayId"];
  if (replayId == 0) {
    print("No replay");
    exit(0);
  }

  // Fetch corresponding replay data
  final String replayString = await database.getReplay(replayId);
  if (replayString.isEmpty) {
    print("Empty replay");
    if (!online) print("Friendly reminder that database is offline");
    exit(0);
  }

  // Print game related entries from the replay
  final replayObject = jsonDecode(replayString);
  print(replayObject["game"]);
}
