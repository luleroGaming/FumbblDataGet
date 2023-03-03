import 'package:fumbblDataGet/serverAPI/serverRequests.dart';
import 'package:test/test.dart';

// Note it doesn't test actual web features
// (obviously doesn't belong in unit testing)

void main(List<String> args) {
  test("Common requests", () {
    const String serverUrl = ServerRequest.serverUrl;
    expect(ServerRequest.replayGet.getRequestString(['42']),
        equals('$serverUrl/replay/get/42/gz'));
    expect(ServerRequest.matchGet.getRequestString(['666']),
        equals('$serverUrl/match/get/666'));
  });
}