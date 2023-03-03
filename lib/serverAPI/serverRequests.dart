// https://fumbbl.com/apidoc/#/
// The present file only exposes some of the API capabilities
// Only "Get", and mostly database related
// Also includes "get replay" that is not documented

import 'package:fumbblDataGet/serverAPI/throttle.dart';
import 'package:requests/requests.dart';

enum ServerRequest {
  boxTrophyStandings,
  boxTrophyRecent,
  coachGet,
  coachSearch,
  coachTeams,
  groupTournaments,
  groupUpcoming,
  matchCurrent,
  matchGet,
  matchList,
  playerGet,
  positionGet,
  rosterGet,
  rulesetList,
  rulesetGet,
  skillList,
  teamGet,
  teamMatches,
  tournamentSchedule,
  tournamentGet,
  replayGet;

  static const String serverUrl = 'https://fumbbl.com/api';
  static const Duration _shortDelay = Duration(milliseconds: 250);
  static const Duration _longDelay = Duration(milliseconds: 1000);

  List<String> getArgumentsHelp() {
    switch (this) {
      case ServerRequest.boxTrophyStandings:
        return [];
      case ServerRequest.boxTrophyRecent:
        return [];
      case ServerRequest.coachGet:
        return ["coachId"];
      case ServerRequest.coachSearch:
        return ["term"];
      case ServerRequest.coachTeams:
        return ["coachName"];
      case ServerRequest.groupTournaments:
        return ["groupId"];
      case ServerRequest.groupUpcoming:
        return ["groupId"];
      case ServerRequest.matchCurrent:
        return [];
      case ServerRequest.matchGet:
        return ["matchId"];
      case ServerRequest.matchList:
        return ["lastMatchId"];
      case ServerRequest.playerGet:
        return ["playerId"];
      case ServerRequest.positionGet:
        return ["positionId"];
      case ServerRequest.rosterGet:
        return ["rosterId"];
      case ServerRequest.rulesetList:
        return [];
      case ServerRequest.rulesetGet:
        return ["rulesetId"];
      case ServerRequest.skillList:
        return [];
      case ServerRequest.teamGet:
        return ["teamId"];
      case ServerRequest.teamMatches:
        return ["teamId", "latestMatch"];
      case ServerRequest.tournamentSchedule:
        return ["tournamentId"];
      case ServerRequest.tournamentGet:
        return ["tournamentId"];
      case ServerRequest.replayGet:
        return ["replayId"];
    }
  }

  String getRequestString(List<String> args) {
    final List<String> expectedArguments = getArgumentsHelp();
    if (args.length != expectedArguments.length) {
      throw Exception(
          "$this expects $expectedArguments as arguments, got $args.");
    }
    const String serverUrl = ServerRequest.serverUrl;
    switch (this) {
      case ServerRequest.boxTrophyStandings:
        return '$serverUrl/boxtrophy/standings';
      case ServerRequest.boxTrophyRecent:
        return '$serverUrl/boxtrophy/recent';
      case ServerRequest.coachGet:
        return '$serverUrl/coach/get/${args[0]}';
      case ServerRequest.coachSearch:
        return '$serverUrl/coach/search/${args[0]}';
      case ServerRequest.coachTeams:
        return '$serverUrl/coach/teams/${args[0]}';
      case ServerRequest.groupTournaments:
        return '$serverUrl/group/tournaments/${args[0]}';
      case ServerRequest.groupUpcoming:
        return '$serverUrl/group/upcoming/${args[0]}';
      case ServerRequest.matchCurrent:
        return '$serverUrl/match/current';
      case ServerRequest.matchGet:
        return '$serverUrl/match/get/${args[0]}';
      case ServerRequest.matchList:
        return '$serverUrl/match/list/${args[0]}';
      case ServerRequest.playerGet:
        return '$serverUrl/player/get/${args[0]}';
      case ServerRequest.positionGet:
        return '$serverUrl/position/get/${args[0]}';
      case ServerRequest.rosterGet:
        return '$serverUrl/roster/get/${args[0]}';
      case ServerRequest.rulesetList:
        return '$serverUrl/ruleset/list';
      case ServerRequest.rulesetGet:
        return '$serverUrl/ruleset/get/${args[0]}';
      case ServerRequest.skillList:
        return '$serverUrl/skill/list';
      case ServerRequest.teamGet:
        return '$serverUrl/team/get/${args[0]}';
      case ServerRequest.teamMatches:
        return '$serverUrl/team/matches/${args[0]}/${args[1]}';
      case ServerRequest.tournamentSchedule:
        return '$serverUrl/tournament/schedule/${args[0]}';
      case ServerRequest.tournamentGet:
        return '$serverUrl/tournament/get/${args[0]}';
      case ServerRequest.replayGet:
        return '$serverUrl/replay/get/${args[0]}/gz';
    }
  }

  bool _longerDelay() {
    return this == ServerRequest.replayGet;
  }

  Future<List<int>> send(List<String> args) async {
    await Throttler.instance.throttle(_longerDelay() ? _longDelay : _shortDelay);
    return (await Requests.get(getRequestString(args))).bodyBytes;
  }

}