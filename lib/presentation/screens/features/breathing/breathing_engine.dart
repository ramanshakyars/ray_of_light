import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'breathing_model.dart';

enum BreathingPhase { inhale, hold1, exhale, hold2, ready }

class BreathingEngine extends ChangeNotifier {
  BreathingModel pattern;

  Timer? _phaseTimer;
  Timer? _elapsedTimer;

  BreathingPhase _phase = BreathingPhase.ready;
  int _secondsLeft = 4;
  bool _isRunning = false;
  int _completedCycles = 0;
  int _totalSecondsElapsed = 0;

  // Audio Player & Settings (Pure Background Music)
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isMusicPlaying = false;
  bool isSoundEnabled = true;
  double volume = 0.30; // Volume swell (0.30 -> 0.85)

  BreathingEngine({BreathingModel? initialPattern})
      : pattern = initialPattern ?? BreathingModel.defaultExercises.first {
    _secondsLeft = pattern.inhale;
    _initAudioPlayer();
  }

  void _initAudioPlayer() {
    try {
      _audioPlayer.setReleaseMode(ReleaseMode.loop);
    } catch (e) {
      debugPrint("AudioPlayer init error: $e");
    }
  }

  BreathingPhase get phase => _phase;
  int get secondsLeft => _secondsLeft;
  bool get isRunning => _isRunning;
  int get completedCycles => _completedCycles;
  int get totalSecondsElapsed => _totalSecondsElapsed;

  void setPattern(BreathingModel newPattern) {
    reset();
    pattern = newPattern;
    _secondsLeft = pattern.inhale;
    notifyListeners();
  }

  void toggleSound() {
    isSoundEnabled = !isSoundEnabled;
    if (!isSoundEnabled) {
      _audioPlayer.pause();
      isMusicPlaying = false;
    } else if (_isRunning) {
      _startMusic();
    }
    notifyListeners();
  }

  Future<void> _startMusic() async {
    if (!isSoundEnabled || isMusicPlaying) return;
    try {
      await _audioPlayer.setSource(AssetSource(pattern.audioAsset));
      await _audioPlayer.setVolume(volume);
      await _audioPlayer.resume();
      isMusicPlaying = true;
    } catch (e) {
      debugPrint("Error starting music asset: ${pattern.audioAsset} - $e");
    }
  }

  Future<void> _stopMusic() async {
    try {
      await _audioPlayer.pause();
      isMusicPlaying = false;
    } catch (_) {}
  }

  void start() {
    if (_isRunning) return;
    _isRunning = true;
    _startElapsedTimer();
    _startMusic();
    _runPhase(BreathingPhase.inhale);
    notifyListeners();
  }

  void pause() {
    _phaseTimer?.cancel();
    _elapsedTimer?.cancel();
    _isRunning = false;
    _stopMusic();
    volume = 0.30;
    notifyListeners();
  }

  void reset() {
    _phaseTimer?.cancel();
    _elapsedTimer?.cancel();
    _isRunning = false;
    _stopMusic();
    _phase = BreathingPhase.ready;
    _secondsLeft = pattern.inhale;
    _completedCycles = 0;
    _totalSecondsElapsed = 0;
    volume = 0.30;
    notifyListeners();
  }

  void _startElapsedTimer() {
    _elapsedTimer?.cancel();
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_isRunning) {
        _totalSecondsElapsed++;
        notifyListeners();
      }
    });
  }

  void _runPhase(BreathingPhase phase) {
    _phase = phase;
    final maxSecs = _getPhaseDuration(phase);
    _secondsLeft = maxSecs;

    _updateVolumeForPhase(phase, 1.0);
    notifyListeners();

    _phaseTimer?.cancel();
    _phaseTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!_isRunning) {
        t.cancel();
        return;
      }

      if (_secondsLeft > 1) {
        _secondsLeft--;
        final progress = 1.0 - (_secondsLeft / maxSecs);
        _updateVolumeForPhase(phase, progress);
        notifyListeners();
      } else {
        t.cancel();
        _nextPhase();
      }
    });
  }

  void _updateVolumeForPhase(BreathingPhase phase, double progress) {
    switch (phase) {
      case BreathingPhase.inhale:
        // Dynamic volume swell from 0.30 up to 0.85 on Breathe In
        volume = 0.30 + (0.55 * progress);
        break;
      case BreathingPhase.hold1:
      case BreathingPhase.hold2:
        // Hold volume steady at 0.85
        volume = 0.85;
        break;
      case BreathingPhase.exhale:
        // Dynamic volume fade from 0.85 down to 0.30 on Breathe Out
        volume = 0.85 - (0.55 * progress);
        break;
      case BreathingPhase.ready:
        volume = 0.30;
        break;
    }

    if (isSoundEnabled && isMusicPlaying) {
      try {
        _audioPlayer.setVolume(volume.clamp(0.0, 1.0));
      } catch (_) {}
    }
  }

  int _getPhaseDuration(BreathingPhase phase) {
    switch (phase) {
      case BreathingPhase.inhale:
        return pattern.inhale;
      case BreathingPhase.hold1:
        return pattern.hold1;
      case BreathingPhase.exhale:
        return pattern.exhale;
      case BreathingPhase.hold2:
        return pattern.hold2;
      case BreathingPhase.ready:
        return pattern.inhale;
    }
  }

  void _nextPhase() {
    switch (_phase) {
      case BreathingPhase.inhale:
        if (pattern.hold1 > 0) {
          _runPhase(BreathingPhase.hold1);
        } else {
          _runPhase(BreathingPhase.exhale);
        }
        break;

      case BreathingPhase.hold1:
        _runPhase(BreathingPhase.exhale);
        break;

      case BreathingPhase.exhale:
        if (pattern.hold2 > 0) {
          _runPhase(BreathingPhase.hold2);
        } else {
          _completedCycles++;
          _runPhase(BreathingPhase.inhale);
        }
        break;

      case BreathingPhase.hold2:
        _completedCycles++;
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
        return "Breathe In";
      case BreathingPhase.hold1:
      case BreathingPhase.hold2:
        return "Hold";
      case BreathingPhase.exhale:
        return "Breathe Out";
      case BreathingPhase.ready:
        return "Ready";
    }
  }

  String get formattedTotalTime {
    final m = (_totalSecondsElapsed ~/ 60).toString().padLeft(2, '0');
    final s = (_totalSecondsElapsed % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  void disposeEngine() {
    _phaseTimer?.cancel();
    _elapsedTimer?.cancel();
    try {
      _audioPlayer.stop();
      _audioPlayer.dispose();
    } catch (_) {}
  }
}
