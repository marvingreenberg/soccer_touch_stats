import 'package:flutter/material.dart';
import 'package:soccer_touch_stats/player_widget_functions.dart';
import './game.dart';
import './player.dart';

typedef WidgetFactory = Widget Function(Player p);

class OffFieldLayout extends StatefulWidget {
  const OffFieldLayout({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _OffFieldLayoutsState();
  }
}

class _OffFieldLayoutsState extends State<OffFieldLayout> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ...game.offField().map((playerList) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [...playerList.map(playerAsDraggable(context))])),
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
