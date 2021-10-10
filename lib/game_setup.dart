import 'package:flutter/material.dart';

import './game.dart';
import './player.dart';
import './on_field_layout.dart';
import './off_field_layout.dart';
import './player_widget_functions.dart';

DragTarget onFieldTarget(Player p, TextStyle style, {void Function()? trigger}) {
  return DragTarget<DraggableData>(
    builder: (BuildContext context, List<dynamic> accepted, List<dynamic> rejected) {
      var colorHighlight = Theme.of(context).highlightColor;
      var styleHighlight = style.merge(TextStyle(backgroundColor: colorHighlight.withAlpha(30)));
      var activeStyle = accepted.isEmpty ? style : styleHighlight;
      return playerAsText(p, activeStyle);
    },
    onAccept: (DraggableData dropped) {
      // setState(() { })
      int inPosition = p.position;
      p.position = dropped.player.position;
      dropped.player.position = inPosition;
      if (trigger != null) trigger();
      if (dropped.trigger != null) dropped.trigger!();
    },
  );
}

Widget Function(Player, {void Function()? trigger}) playerAsDragTarget(BuildContext context) {
  var onFieldStyle = defaultStyle(context);

  return (Player p, {void Function()? trigger}) {
    return onFieldTarget(p, onFieldStyle, trigger: trigger);
  };
}

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
    var makeDragTarget = playerAsDragTarget(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          OnFieldLayout(playerWidgetFactory: makeDragTarget),
          const OffFieldLayout(),
        ],
      ),
    );
  }
}
