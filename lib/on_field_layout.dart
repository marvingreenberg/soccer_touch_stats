import 'package:flutter/material.dart';
import 'package:soccer_touch_stats/game.dart';
import './player.dart';

Widget dragTargetPlayer(Player p) {
  return const Text('hey');
}

typedef WidgetFactory = Widget Function(Player p);

class OnFieldLayout extends StatefulWidget {
  final WidgetFactory playerWidgetFactory;
  final Game game;

  const OnFieldLayout({Key? key, required this.playerWidgetFactory, required this.game})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _OnFieldPlayersState();
  }
}

class _OnFieldPlayersState extends State<OnFieldLayout> {
  void substitute(Player subIn, Player subOut) {
    var position = subOut.position;
    subOut.position = -1;
    subIn.position = position;

    setState(() {
      // redraw the thing
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ...widget.game
              .onField()
              .map((playerList) => Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                    ...playerList.map(
                      (player) => widget.playerWidgetFactory(player),
                    )
                  ])),
        ],
      ),
    );
  }
}

// Draggable<int>(
//           // Data is the value this Draggable stores.
//           data: 10,
//           child: Container(
//             height: 100.0,
//             width: 100.0,
//             color: Colors.lightGreenAccent,
//             child: const Center(
//               child: Text('Draggable'),
//             ),
//           )
