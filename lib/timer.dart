// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:soccer_touch_stats/touch_page.dart';

const oneSecond = Duration(seconds: 1);

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

String pad(int timefield, {String padChar = '0'}) {
  return (padChar + timefield.toString()).substring(1, 3);
}

class GameTimer extends StatefulWidget {
  final TextStyle timerStyle;
  final TouchPageState touchPageState;

  const GameTimer({
    Key? key,
    required this.timerStyle,
    required this.touchPageState,
  }) : super(key: key);

  @override
  State createState() => _TimerState();
}

class _TimerState extends State<GameTimer> {
  var periods = [TimeBounds(), TimeBounds()];
  int half = 0;
  String _timerDisplay = '00:00';

  _TimerState();
  void stopTimer() {
    widget.touchPageState.isRunning = false;
    var tb = periods[half];
    tb.end();
    half = 1;
  }

  // repeatedly pressing start changes the start
  void startTimer() {
    if (widget.touchPageState.isRunning) return;
    periods[half].start();

    Timer.periodic(oneSecond, (Timer t) {
      if (!widget.touchPageState.isRunning) t.cancel();
      updateTimerDisplay();
    });

    setState(() {
      widget.touchPageState.isRunning = true;
    });
  }

  void updateTimerDisplay() {
    Duration elapsed = periods[0].duration + periods[1].duration;
    int minutes = (elapsed.inSeconds / 60).floor();
    int seconds = elapsed.inSeconds.remainder(60);
    setState(() {
      _timerDisplay = '${pad(minutes, padChar: ' ')}:${pad(seconds)}';
    });
  }

  @override
  void didUpdateWidget(GameTimer oldWidget) {
    print('something happened');
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _bodyText =
        Theme.of(context).textTheme.headline4 ?? const TextStyle(fontFamily: 'Courier');
    var timerStyle = _bodyText.copyWith(fontFeatures: [
      const FontFeature.tabularFigures(),
    ]);

    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
      IconButton(
        onPressed: startTimer,
        color: widget.touchPageState.isRunning ? Colors.black : Colors.red,
        iconSize: 24.0,
        icon: const Icon(Icons.play_circle),
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
      ),
      Text(_timerDisplay, style: timerStyle)
    ]);
  }
}
