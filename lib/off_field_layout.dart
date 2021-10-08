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
    print('off field layout activate $mounted');
  }

  @override
  void deactivate() {
    super.deactivate();
    print('off field layout deactivate $mounted');
  }

  @override
  void didUpdateWidget(covariant OffFieldLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('off field layout didUpdateWidget $mounted');
  }

  void redraw() {
    print('off field layout redraw $mounted');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print('off field layout build $mounted');
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
