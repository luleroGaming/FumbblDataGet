import 'package:fumbblDataGet/serverAPI/throttle.dart';
import 'package:test/test.dart';

void main() {
  test("Throttling", () async {
    final Throttler throttler = Throttler.instance;
    const List<int> delays = [25, 50, 75, 100];

    final DateTime start = DateTime.now();
    for (int delay in delays) {
      await throttler.throttle(Duration(milliseconds: delay));
    }
    await throttler.throttle(Duration(milliseconds: 0));
    final DateTime end = DateTime.now();

    final int expected = delays.fold(0, (sum, delay) => sum + delay);
    final int observed = end.difference(start).inMilliseconds;

    expect(observed, greaterThanOrEqualTo(expected));
  });
}
