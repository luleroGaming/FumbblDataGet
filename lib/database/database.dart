import 'dart:convert';
import 'dart:io';

import 'package:fumbblDataGet/serverAPI/serverRequests.dart';

class Database {
  static const String matchesFolder = 'matches/';
  static const String replayFolder = 'replays/';

  final String _rootFolder;
  late bool _online;

  Database(this._rootFolder, {bool online: false}) {
    _online = online;
    final Directory root = Directory(_rootFolder);
    if (!(root.existsSync())) {
      throw Exception("Data root (${root.absolute.uri}) does not exist");
    }
  }

  Future<String> _get(String fileName, ServerRequest request, List<String> args,
      bool compressed) async {
    final File file = File(fileName);
    List<int> bytes;
    if (await file.exists()) {
      bytes = await file.readAsBytes();
    } else if (_online) {
      bytes = await request.send(args);
      await file.create(recursive: true);
      await file.writeAsBytes(bytes, flush: true);
    } else {
      throw Exception("Could not find data on disk while offline.");
    }
    if (bytes.isNotEmpty && compressed) {
      bytes = gzip.decode(bytes);
    }
    return utf8.decode(bytes);
  }

  Future<String> getMatch(int id) async {
    final String fileName = '$_rootFolder$matchesFolder/match$id.json';
    return await _get(fileName, ServerRequest.matchGet, ['$id'], false);
  }

  Future<String> getReplay(int id) async {
    final String fileName = '$_rootFolder$replayFolder/replay$id.gz';
    return await _get(fileName, ServerRequest.replayGet, ['$id'], true);
  }
}
