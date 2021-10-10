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
  void activate() {
    super.activate();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void didUpdateWidget(covariant OffFieldLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void redraw() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ...game.offField().map((playerList) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [...playerList.map(playerAsDraggable(context, trigger: redraw))])),
        ],
      ),
    );
  }
}
