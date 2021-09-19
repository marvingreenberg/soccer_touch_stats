import 'package:flutter/material.dart';
import './game.dart';

// 20% longer than the half to account for stop time
// Start warning three minutes before end of half
const int totalTimerRunTimeSeconds = (lengthOfHalfMinutes + 10) * 60;
const int startWarningAfterSeconds = (lengthOfHalfMinutes - 3) * 60;

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

String padSeconds(int seconds) {
  return (seconds + 100).toString().substring(1, 3);
}

class _TimerState extends State<GameTimer> with TickerProviderStateMixin {
  late AnimationController _controller;
  Duration? offset;
  int targetTimeSeconds = totalTimerRunTimeSeconds;
  Half? currentHalf;

  _TimerState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: totalTimerRunTimeSeconds),
    );
  }
  void stop() {
    if (_controller.duration != null) {
      offset = _controller.duration! * _controller.value;
    }
    _controller.stop(canceled: false);
  }

  void start(Half half) {
    offset = _controller.duration;
    _controller.reset();
  }

  String get timerDisplayString {
    Duration elapsed = _controller.duration ?? const Duration(seconds: 0);

    int minutes = (elapsed.inSeconds / 60).floor();
    int seconds = elapsed.inSeconds.remainder(60);
    return '$minutes:${padSeconds(seconds)}';
  }

  @override
  void initState() {
    super.initState();
    _controller.reverse();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        if (widget.warnNearEndOfHalf != null) {
          widget.warnNearEndOfHalf!();
        }
      }
    });
  }

  @override
  void didUpdateWidget(GameTimer oldWidget) {
    print('something happened');
    super.didUpdateWidget(oldWidget);
    // if (widget.secondsRemaining != oldWidget.secondsRemaining) {
    //   setState(() {
    //     duration = new Duration(seconds: widget.secondsRemaining);
    //     _controller.dispose();
    //     _controller = new AnimationController(
    //       vsync: this,
    //       duration: duration,
    //     );
    //     _controller.reverse(from: widget.secondsRemaining.toDouble());
    //     _controller.addStatusListener((status) {
    //       if (status == AnimationStatus.completed) {
    //         widget.whenTimeExpires();
    //       } else if (status == AnimationStatus.dismissed) {
    //         print("Animation Complete");
    //       }
    //     });
    //   });
    // }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: AnimatedBuilder(
            animation: _controller,
            builder: (_, Widget? child) {
              return TextButton(
                onPressed: () => _controller.reset(),
                child: Text(timerDisplayString, style: widget.timerStyle),
              );
            }));
  }
}
