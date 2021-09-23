import 'package:flutter/material.dart';

class GameTimer extends StatefulWidget {
  final TextStyle timerStyle;
  const GameTimer({Key? key, required this.timerStyle}) : super(key: key);
  @override
  State createState() => _TimerState();
}

class _TimerState extends State<GameTimer> {
  final startedAt = DateTime.now();

  // Initial value of Text
  String _timerDisplay = '0';

  void updateTimerDisplay() {
    int minutes = (DateTime.now().difference(startedAt).inSeconds / 60).floor();

    // Update value of Text
    setState(() {
      _timerDisplay = minutes.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    //const Text displayText = timerDisplayText(widget.timerStyle);
    var displayText = Text(_timerDisplay, style: widget.timerStyle);
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Icon(Icons.play_circle),
          displayText,
        ]);
  }
}
