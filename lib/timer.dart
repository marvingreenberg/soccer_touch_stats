// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import './touch_page.dart';
import './game.dart';

const oneSecond = Duration(seconds: 1);

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
  Timer? dartTimer;

  _TimerState();

  int get half {
    return game.half;
  }

  set half(value) {
    setState(() {
      game.half = value;
    });
  }

  List<TimeBounds> get periods {
    return game.periods;
  }

  @override
  void dispose() {
    if (dartTimer != null) {
      dartTimer!.cancel();
      dartTimer = null;
    }
    super.dispose();
  }

  void _stopTimer() {
    print('_stopTimer');
    dartTimer?.cancel();
    dartTimer = null;
    if (half > 1) return;
    widget.touchPageState.isRunning = false;
    periods[half].end();
    half += 1;
  }

  void startUpdating() {
    print('startUpdating');
    if (dartTimer != null || !widget.touchPageState.isRunning) return;
    dartTimer = Timer.periodic(oneSecond, (Timer t) {
      updateTimerDisplay();
    });
  }

  // repeatedly pressing start changes the start
  void _startTimer() {
    print('_startTimer');
    periods[half].start();
    startUpdating();
    widget.touchPageState.isRunning = true;
  }

  void halfTransition() {
    print('halfTransition');
    if (half > 1) return;
    setState(() {
      if (widget.touchPageState.isRunning) {
        _stopTimer();
      } else {
        _startTimer();
      }
    });
  }

  String get timerDisplay {
    Duration elapsed = periods[0].duration + periods[1].duration;
    int minutes = (elapsed.inSeconds / 60).floor();
    int seconds = elapsed.inSeconds.remainder(60);
    return '${pad(minutes)}:${pad(seconds)}';
  }

  void updateTimerDisplay() {
    // redraw timer every second, when running
    setState(() {
      print(timerDisplay);
    });
  }

  static final red = Colors.redAccent;
  static final grey = Colors.grey[300] ?? Colors.grey;
  static final blue = Colors.blue.shade900;
  static final black = Colors.black54;
  static final green = Colors.lightGreenAccent[400] ?? Colors.green;

  static List<Color> colorSequence = [red, black, grey, black, blue];

  static final _halfIconColors = [
    [grey, grey],
    [green, grey],
    [red, grey],
    [red, green],
    [red, red],
  ];

  List<Icon> halfIcons() {
    var index = half * 2 + (widget.touchPageState.isRunning ? 1 : 0);
    var _colors = _halfIconColors[index];
    return [
      Icon(Icons.looks_one, size: 18, color: _colors[0]),
      Icon(Icons.looks_two, size: 18, color: _colors[1])
    ];
  }

  Color buttonColor() {
    var index = half * 2 + (widget.touchPageState.isRunning ? 1 : 0);
    return colorSequence[index];
  }

  @override
  Widget build(BuildContext context) {
    startUpdating();
    TextStyle _bodyText =
        Theme.of(context).textTheme.headline4 ?? const TextStyle(fontFamily: 'Courier');
    var timerStyle = _bodyText.copyWith(fontFeatures: [
      const FontFeature.tabularFigures(),
    ]);

    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
      Column(children: [
        Row(children: [Text(timerDisplay, style: timerStyle)]),
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
