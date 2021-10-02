import 'package:flutter/material.dart';
import './timer.dart';
import './game.dart';
import './player.dart';
import 'on_field_layout.dart';

class TouchPage extends StatefulWidget {
  const TouchPage({Key? key, required this.game, required this.title}) : super(key: key);
  final String title;
  final Game game;

  @override
  State<TouchPage> createState() => TouchPageState();
}

class TouchPageState extends State<TouchPage> {
  Player? _lastTouch;
  int? _possession;
  String _possessionDescription = '';
  bool _isRunning = false;

  bool get isRunning {
    return _isRunning;
  }

  set isRunning(bool v) {
    setState(() {
      _isRunning = v;
    });
  }

  void startClock() {
    isRunning = true;
  }

  void _touchedBy(Player player) {
    setState(() {
      if (_lastTouch != null) _lastTouch!.passes += 1;
      _lastTouch = player;
      _possessionDescription = player.nickname;
    });
  }

  Widget Function(Player) playerAsButtonFn(BuildContext context) {
    return (Player p) {
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
          child: ElevatedButton(
            onPressed: _possession == p.number ? null : () => _touchedBy(p),
            child: Text(
              p.toString(),
              style: Theme.of(context).textTheme.headline4,
            ),
          ));
    };
  }

  void _reset() {
    if (_possession != null || _lastTouch != null) {
      setState(() {
        _lastTouch = null;
        _possession = null;
      });
    }
  }

  void _shot() {
    if (_lastTouch != null) _lastTouch!.shots += 1;
    _reset();
  }

  void _stopPlay() {
    _reset();
  }

  void _goal() {
    if (_lastTouch != null) _lastTouch!.goals += 1;
    _reset();
  }

  void _turnOver() {
    if (_lastTouch != null) _lastTouch!.turnovers += 1;
    _reset();
  }

  void writeStats() async {
    await widget.game.write();
  }

  @override
  Widget build(BuildContext context) {
    Widget Function(Player) makeButton = playerAsButtonFn(context);
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the TouchPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                color: Colors.greenAccent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FloatingActionButton(
                      onPressed: isRunning ? _shot : null,
                      child: const Text('Shot'),
                    ),
                    FloatingActionButton(
                      onPressed: isRunning ? _goal : null,
                      child: const Text('Goal'),
                    ),
                    GameTimer(
                      touchPageState: this,
                      timerStyle: const TextStyle(
                          fontStyle: FontStyle.italic, fontSize: 32, color: Colors.white),
                    ),
                  ],
                )),
            OnFieldLayout(playerWidgetFactory: makeButton, game: widget.game),
            Text(
              '> $_possessionDescription',
              style: Theme.of(context).textTheme.headline4,
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(40.0, 5.0, 40.0, 5.0),
                color: Colors.amber,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FloatingActionButton(
                      onPressed: isRunning ? _turnOver : null,
                      child: const Text('Turn\nover'),
                    ),
                    FloatingActionButton(
                      onPressed: isRunning ? _stopPlay : null,
                      child: const Text('Stop\nplay'),
                    )
                  ],
                )),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
