import 'package:flutter/material.dart';
import './player.dart';

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

Widget Function(Player) playerAsDragTarget(BuildContext context) {
  Color background = Theme.of(context).colorScheme.background;
  TextStyle backgroundStyle = TextStyle(fontSize: 30, backgroundColor: background);
  TextStyle h4 = Theme.of(context).textTheme.headline4 ?? backgroundStyle;

  return (Player p) {
    return playerAsText(p, h4.merge(backgroundStyle));
  };
}

Widget Function(Player) playerAsDraggable(BuildContext context) {
  Color background = Theme.of(context).colorScheme.background;
  TextStyle backgroundStyle = TextStyle(fontSize: 30, backgroundColor: background);
  TextStyle h4 = Theme.of(context).textTheme.headline4 ?? backgroundStyle;

  return (Player p) {
    return playerAsText(p, h4.merge(backgroundStyle));
  };
}
