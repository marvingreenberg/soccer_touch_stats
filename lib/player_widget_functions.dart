import 'package:flutter/material.dart';
import './player.dart';

DragTarget onFieldTarget(Player p, TextStyle style, {void Function()? trigger}) {
  return DragTarget<DraggableData>(
    builder: (BuildContext context, List<dynamic> accepted, List<dynamic> rejected) {
      return playerAsText(p, style);
    },
    onAccept: (DraggableData dropped) {
      // setState(() { print('${p.number} was dropped'); })
      int inPosition = p.position;
      p.position = dropped.player.position;
      dropped.player.position = inPosition;
      print('${dropped.player.number} was dropped onto ${p.number}');
      if (trigger != null) trigger();
      if (dropped.trigger != null) dropped.trigger!();
    },
  );
}

Widget paddedText(String text, TextStyle? style) {
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Container(
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
              child: Text(text, style: style)),
          decoration: BoxDecoration(color: style?.backgroundColor),
        ),
      ));
}

Widget playerAsText(Player p, TextStyle? style) {
  return ClipRRect(
      borderRadius: BorderRadius.circular(3.0),
      child: Tooltip(message: p.nickname, child: paddedText(p.toString(), style)));
}

Widget Function(Player, {void Function()? trigger}) playerAsDragTarget(BuildContext context) {
  Color background = Theme.of(context).colorScheme.background;
  TextStyle backgroundStyle = TextStyle(fontSize: 30, backgroundColor: background);
  TextStyle h4 = Theme.of(context).textTheme.headline4 ?? backgroundStyle;

  return (Player p, {void Function()? trigger}) {
    return onFieldTarget(p, h4.merge(backgroundStyle), trigger: trigger);
  };
}

class DraggableData {
  Player player;
  void Function()? trigger;

  DraggableData(this.player, this.trigger);
}

Widget Function(Player) playerAsDraggable(BuildContext context, {void Function()? trigger}) {
  Color background = Theme.of(context).colorScheme.background;
  TextStyle backgroundStyle = TextStyle(fontSize: 30, backgroundColor: background);
  TextStyle h4 = Theme.of(context).textTheme.headline4 ?? backgroundStyle;

  return (Player p) {
    return Draggable(
      data: DraggableData(p, trigger),
      child: playerAsText(p, h4.merge(backgroundStyle)),
      onDragStarted: () {
        print('drag started $p');
      },
      onDragEnd: (details) {
        print('drag started $p $details');
      },
      feedback: Container(
        color: Colors.teal[100],
        height: 30,
        width: 30,
        child: Text('$p', textAlign: TextAlign.center, textScaleFactor: 0.3),
      ),
    );
  };
}
