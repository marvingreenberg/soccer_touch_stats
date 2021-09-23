// ignore_for_file: avoid_print
import 'dart:async';
import 'package:flutter/material.dart';
import './common.dart';

const oneSecond = Duration(seconds: 1);

// Start warning three minutes before end of half
const int totalTimerRunTimeSeconds = (lengthOfHalfMinutes + 10) * 60;
const int startWarningAfterSeconds = (lengthOfHalfMinutes - 3) * 60;
const zeroDuration = Duration(seconds: 0);

class TimeBounds {
  DateTime? _start;
  DateTime? _end;

  void start() {
    _start = DateTime.now();
  }

  void end() {
    _end = DateTime.now();
  }

  Duration get duration {
    if (_start == null) return zeroDuration;
    return (_end ?? DateTime.now()).difference(_start!);
  }
}

String padSeconds(int seconds) {
  return (seconds + 100).toString().substring(1, 3);
}

class GameTimer extends StatefulWidget {
  final Function? warnNearEndOfHalf;
  final TextStyle timerStyle;

  const GameTimer({
    Key? key,
    required this.timerStyle,
    this.warnNearEndOfHalf,
  }) : super(key: key);

  @override
  State createState() => _TimerState();
}

class _TimerState extends State<GameTimer> {
  Map<Half, TimeBounds> periods = {
    Half.first: TimeBounds(),
    Half.second: TimeBounds(),
  };
  Half gameHalf = Half.first;
  String _timerDisplay = '00:00';
  bool isRunning = false;

  _TimerState();
  void stop() {
    isRunning = false;
    var tb = periods[gameHalf];
    if (tb == null) return;
    tb.end();
    gameHalf = Half.second;
  }

  // repeatedly pressing start changes the start
  void startTimer() {
    if (isRunning) return;
    print('******** starting ********');
    TimeBounds tb =
        periods.containsKey(gameHalf) ? periods[gameHalf]! : TimeBounds();
    tb.start();
    periods[gameHalf] = tb;

    Timer.periodic(oneSecond, (Timer t) {
      print('******** timer tick ********');
      if (!isRunning) t.cancel();
      updateTimerDisplay();
    });

    setState(() {
      isRunning = true;
    });
  }

  void updateTimerDisplay() {
    Duration elapsed = periods.values
        .fold(zeroDuration, (Duration d, TimeBounds tb) => d + tb.duration);
    int minutes = (elapsed.inSeconds / 60).floor();
    int seconds = elapsed.inSeconds.remainder(60);
    setState(() {
      _timerDisplay = '$minutes:${padSeconds(seconds)}';
    });
  }

  @override
  void didUpdateWidget(GameTimer oldWidget) {
    print('something happened');
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    print('*********** $_timerDisplay ***********');
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            onPressed: startTimer,
            color: isRunning ? Colors.black : Colors.red,
            iconSize: 24.0,
            icon: const Icon(Icons.play_circle),
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
          ),
          Text(_timerDisplay, style: widget.timerStyle)
        ]);
  }
}
