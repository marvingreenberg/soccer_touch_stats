// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import './touch_page.dart';

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
  var offset = timefield > 9 ? 1 : 0;
  return (padChar + timefield.toString()).substring(offset, offset + 2);
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
  Timer? dartTimer;

  _TimerState();

  @override
  void dispose() {
    if (dartTimer != null) {
      dartTimer!.cancel();
      dartTimer = null;
    }
    super.dispose();
  }

  void stopTimer() {
    dartTimer?.cancel();
    if (half > 1) return;
    widget.touchPageState.isRunning = false;
    periods[half].end();
    half += 1;
  }

  void halfTransition() {
    if (half > 1) return;
    setState(() {
      if (half == 0) {
        if (!widget.touchPageState.isRunning) {
          startTimer();
        } else {
          stopTimer();
        }
      } else {
        if (!widget.touchPageState.isRunning) {
          widget.touchPageState.isRunning = true;
        } else {
          widget.touchPageState.isRunning = false;
          half = 2;
        }
      }
    });
  }

  void startUpdating() {
    if (dartTimer != null) return;
    dartTimer = Timer.periodic(oneSecond, (Timer t) {
      if (!widget.touchPageState.isRunning) t.cancel();
      updateTimerDisplay();
    });
  }

  // repeatedly pressing start changes the start
  void startTimer() {
    periods[half].start();

    startUpdating();

    setState(() {
      widget.touchPageState.isRunning = true;
    });
  }

  void updateTimerDisplay() {
    Duration elapsed = periods[0].duration + periods[1].duration;
    int minutes = (elapsed.inSeconds / 60).floor();
    int seconds = elapsed.inSeconds.remainder(60);

    setState(() {
      _timerDisplay = '${pad(minutes)}:${pad(seconds)}';
    });
  }

  @override
  void didUpdateWidget(GameTimer oldWidget) {
    print('Restart updating');
    startUpdating();
    super.didUpdateWidget(oldWidget);
  }

  static var colorSequence = [
    Colors.red.shade900,
    Colors.black,
    Colors.grey,
    Colors.black,
    Colors.blue.shade900
  ];

  static final _halfIcons = [Icons.looks_one, Icons.looks_two];

  List<Icon> halfIcons() {
    return [0, 1]
        .map((i) => Icon(_halfIcons[i],
            size: 16,
            color: (i == half && widget.touchPageState.isRunning)
                ? Colors.lightGreenAccent[400]
                : Colors.grey[300]))
        .toList();
  }

  Color buttonColor() {
    var index = half * 2 + (widget.touchPageState.isRunning ? 1 : 0);
    return colorSequence[index];
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _bodyText =
        Theme.of(context).textTheme.headline4 ?? const TextStyle(fontFamily: 'Courier');
    var timerStyle = _bodyText.copyWith(fontFeatures: [
      const FontFeature.tabularFigures(),
    ]);

    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
      Column(children: [
        Row(children: [Text(_timerDisplay, style: timerStyle)]),
        Row(children: halfIcons())
      ]),
      IconButton(
        onPressed: halfTransition,
        color: buttonColor(),
        iconSize: 24.0,
        icon: const Icon(Icons.play_circle),
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
      ),
    ]);
  }
}
