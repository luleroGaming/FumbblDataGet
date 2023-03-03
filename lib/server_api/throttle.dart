class Throttler {
  DateTime _nextTime = DateTime(0);

  Throttler._();

  Future<void> throttle(Duration nextDelay) async {
    final DateTime now = DateTime.now();
    if (now.isBefore(_nextTime)) {
      await Future.delayed(_nextTime.difference(now));
    }
    _nextTime = DateTime.now().add(nextDelay);
  }

  static final Throttler instance = Throttler._();
}