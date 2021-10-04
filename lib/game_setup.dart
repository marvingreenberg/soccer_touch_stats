import 'package:flutter/material.dart';

import './game.dart';
import './player.dart';
import './on_field_layout.dart';
import './off_field_layout.dart';

import './player_widget_functions.dart';

class GameSetupPage extends StatefulWidget {
  const GameSetupPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<GameSetupPage> createState() => GameSetupPageState();
}

class GameSetupPageState extends State<GameSetupPage> {
  void writeStats() async {
    await game.write();
  }

  @override
  Widget build(BuildContext context) {
    Widget Function(Player) makeDragTarget = playerAsDragTarget(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          OnFieldLayout(playerWidgetFactory: makeDragTarget),
          const OffFieldLayout(),
        ],
      ),
    );
  }
}