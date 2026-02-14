import 'dart:async';
import 'package:flutter/material.dart';

enum BreathingPhase { inhale, hold, exhale, ready }

class BreathingEngine extends ChangeNotifier {
  Timer? _timer;

  BreathingPhase _phase = BreathingPhase.ready;
  int _secondsLeft = 4;
  bool _isRunning = false;

  BreathingPhase get phase => _phase;
  int get secondsLeft => _secondsLeft;
  bool get isRunning => _isRunning;

  // Sama Vritti = 4-4-4-4
  final int _cycleSeconds = 4;

  void start() {
    if (_isRunning) return;
    _isRunning = true;
    _runPhase(BreathingPhase.inhale);
    notifyListeners();
  }

  void pause() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void reset() {
    _timer?.cancel();
    _isRunning = false;
    _phase = BreathingPhase.ready;
    _secondsLeft = _cycleSeconds;
    notifyListeners();
  }

  void _runPhase(BreathingPhase phase) {
    _phase = phase;
    _secondsLeft = _cycleSeconds;
    notifyListeners();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft > 1) {
        _secondsLeft--;
        notifyListeners();
      } else {
        t.cancel();
        _nextPhase();
      }
    });
  }

  void _nextPhase() {
    switch (_phase) {
      case BreathingPhase.inhale:
        _runPhase(BreathingPhase.hold);
        break;
      case BreathingPhase.hold:
        _runPhase(BreathingPhase.exhale);
        break;
      case BreathingPhase.exhale:
        _runPhase(BreathingPhase.inhale);
        break;
      case BreathingPhase.ready:
        _runPhase(BreathingPhase.inhale);
        break;
    }
  }

  String get instruction {
    switch (_phase) {
      case BreathingPhase.inhale:
        return "Inhale";
      case BreathingPhase.hold:
        return "Hold";
      case BreathingPhase.exhale:
        return "Exhale";
      case BreathingPhase.ready:
        return "Ready";
    }
  }

  void disposeEngine() {
    _timer?.cancel();
  }
}
