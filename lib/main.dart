import 'package:flutter/material.dart';
import './player_info.dart';
import './timer.dart';

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

const playersOnField = [
  [15, 21, 57],
  [33, 11, 19],
  [98, 25, 33, 98],
  [13]
];

enum EndCondition { shot, goal, turnOver, stopPlay }

class _TouchPageState extends State<TouchPage> {
  final _touches = [];
  String _possession = '';

  void _touchedBy(int playerNumber) {
    setState(() {
      _touches.add(playerNumber);
      _possession = playerInfo[playerNumber]?.nickname ?? '$playerNumber';
    });
  }

  void _endedWith(EndCondition kind) {
    // TODO: add stats
    setState(() {
      _touches.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the TouchPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
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
                          fontSize: 26,
                          color: Colors.white),
                    ),
                  ],
                )),
            ...playersOnField.map((numberList) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ...numberList.map((playerNum) => ElevatedButton(
                            onPressed: () => _touchedBy(playerNum),
                            child: Text(
                              playerNum.toString(),
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          ))
                    ])),
            Text(
              'Possession $_possession',
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
