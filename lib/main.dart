import 'package:flutter/material.dart';
import './timer.dart';
import './game.dart';
import './common.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soccer Touch',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TouchPage(title: 'Soccer Touch Stats'),
    );
  }
}

class TouchPage extends StatefulWidget {
  const TouchPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<TouchPage> createState() => _TouchPageState();
}

class _TouchPageState extends State<TouchPage> {
  final _touches = [];
  int? _possession;
  String _possessionDescription = '';
  bool _isRunning = false;
  var game = Game('aGame', arlington2005RedPlayers);

  void _touchedBy(int playerNumber) {
    setState(() {
      _isRunning = true;
      _possession = playerNumber;
      _touches.add(playerNumber);
      _possessionDescription =
          game.getPlayer(playerNumber)?.nickname ?? '$playerNumber';
    });
  }

  void _endedWith(EndCondition kind) async {
    _possession = null;
    if (_touches.isEmpty) return;

    for (var playerNumber in _touches.take(_touches.length - 1)) {
      game.getPlayer(playerNumber)?.addPass();
    }
    game.getPlayer(_touches.last)?.addEndCondition(kind);

    await game.write();

    setState(() {
      _touches.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                color: Colors.green,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FloatingActionButton(
                      onPressed: () => _endedWith(EndCondition.shot),
                      child: const Text('Shot'),
                    ),
                    FloatingActionButton(
                      onPressed: () => _endedWith(EndCondition.goal),
                      child: const Text('Goal'),
                    ),
                    const GameTimer(
                      timerStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 32,
                          color: Colors.white),
                    ),
                  ],
                )),
            ...playersOnField.map((numberList) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ...numberList.map((playerNum) => ElevatedButton(
                            onPressed: _possession == playerNum
                                ? null
                                : () => _touchedBy(playerNum),
                            child: Text(
                              playerNum.toString(),
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          ))
                    ])),
            Text(
              '=> $_possessionDescription',
              style: Theme.of(context).textTheme.headline3,
            ),
            Text(
              'touches: $_touches',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                color: Colors.amber,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FloatingActionButton(
                      onPressed: () => _endedWith(EndCondition.turnOver),
                      child: const Text('Turn\nover'),
                    ),
                    FloatingActionButton(
                      onPressed: () => _endedWith(EndCondition.stopPlay),
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
