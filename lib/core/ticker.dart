import 'dart:async';

class Ticker {
  /// Emits a tick each second for [totalSeconds] seconds.
  Stream<int> tick({required int totalSeconds}) {
    return Stream.periodic(const Duration(seconds: 1), (i) => i + 1)
        .take(totalSeconds);
  }
}


