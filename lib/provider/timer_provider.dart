import 'dart:async';

import 'package:flutter/material.dart';

class TimerProvider with ChangeNotifier {
  Timer _overallTimer;
  int _overallTimeInSeconds = 0;

  String get overallTimeInString {
    Duration timeLeft = Duration(seconds: _overallTimeInSeconds);
    String minuteLeft = timeLeft.inMinutes.toString().padLeft(2, '0');
    String secondLeft =
        timeLeft.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minuteLeft:$secondLeft';
  }

  bool get hasOverallTimeFinish => _overallTimeInSeconds == 0;

  setOverallTime(int timeLeftInSeconds) {
    _overallTimeInSeconds = timeLeftInSeconds;
    notifyListeners();
  }

  startOverallTimer({int overallTimeInSeconds, bool overwrite: false}) {
    // if there is an active timer and did not set for overwrite, skip it
    if (_overallTimer != null && _overallTimer.isActive) {
      if (overwrite == false) {
        return;
      } else {
        stopOverallTimer();
      }
    }

    if (overallTimeInSeconds != null) {
      _overallTimeInSeconds = overallTimeInSeconds;
    }

    _overallTimer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        // if is 0, just stop the timer then
        if (_overallTimeInSeconds == 0) {
          stopOverallTimer();
          return;
        }

        setOverallTime(_overallTimeInSeconds - 1);
      },
    );
  }

  pauseOverallTimer() {
    // take the current pause time
    // due to calling stopOverallTimer will reset the time
    // need to set the overallTimeInSeconds with the current pause time so that it able to resume later
    int _pausedTime = _overallTimeInSeconds;
    stopOverallTimer();
    _overallTimeInSeconds = _pausedTime;
  }
  
  resumeOverallTimer() {
    startOverallTimer(
      overallTimeInSeconds: _overallTimeInSeconds,
    );
  }

  stopOverallTimer() {
    _overallTimer?.cancel();
    _overallTimeInSeconds = 0;
    notifyListeners();
  }
}
