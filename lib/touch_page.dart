import 'package:flutter/material.dart';
import './timer.dart';
import './game.dart';
import './player.dart';
import 'on_field_layout.dart';

class TouchPage extends StatefulWidget {
  const TouchPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<TouchPage> createState() => TouchPageState();
}

class TouchPageState extends State<TouchPage> {
  bool get isRunning {
    return game.isRunning;
  }

  set isRunning(bool v) {
    setState(() {
      game.isRunning = v;
    });
  }

  void startClock() {
    isRunning = true;
  }

  void _reset() {
    setState(() {
      game.possession = Player.noPossession;
    });
  }

  void _shot() {
    if (game.possession != Player.noPossession) game.possession.shots += 1;
    _reset();
  }

  void _stopPlay() {
    _reset();
  }

  void _goal() {
    if (game.possession != Player.noPossession) game.possession.goals += 1;
    _reset();
  }

  void _turnOver() {
    if (game.possession != Player.noPossession) game.possession.goals += 1;
    _reset();
  }

  void _touched(Player p) {
    setState(() {
      game.possession = p;
    });
  }

  void writeStats() async {
    await game.write();
  }

  Widget Function(Player) playerAsButton(BuildContext context) {
    return (Player p) {
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
          child: ElevatedButton(
            onPressed: game.possession == p || !isRunning
                ? null
                : () {
                    _touched(p);
                  },
            child: Tooltip(
                message: p.nickname,
                child: Text(
                  p.toString(),
                  style: Theme.of(context).textTheme.headline4,
                )),
          ));
    };
  }

  @override
  Widget build(BuildContext context) {
    Widget Function(Player) makeButton = playerAsButton(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
              color: Colors.teal[900],
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
          OnFieldLayout(playerWidgetFactory: makeButton),
          Text(
            game.possession == Player.noPossession ? '' : game.possession.nickname,
            style: Theme.of(context).textTheme.headline4,
          ),
          Container(
              padding: const EdgeInsets.fromLTRB(40.0, 5.0, 40.0, 5.0),
              color: Colors.deepOrange[900],
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
    );
  }
}
