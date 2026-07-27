class ScanSignal {
  bool _stopped = false;

  bool get stopped => _stopped;

  void stop() {
    _stopped = true;
  }

  void throwIfStopped() {
    if (_stopped) {
      throw const ScanStopped();
    }
  }
}

class ScanStopped implements Exception {
  const ScanStopped();
}
