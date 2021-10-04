import 'package:flutter/material.dart';

import './player.dart';
import './game.dart';

Widget paddedText(String text, TextStyle? style) {
  return Container(
      child: Text(text, style: style),
      decoration: BoxDecoration(color: Colors.blue.shade600),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7));
}

Widget playerAsText(Player p, TextStyle? style) {
  return ClipRRect(
      borderRadius: BorderRadius.circular(3.0),
      child: Tooltip(message: p.nickname, child: paddedText(p.toString(), style)));
}

Widget Function(Player) playerAsDragTarget(BuildContext context) {
  Color background = Theme.of(context).colorScheme.background;
  TextStyle backgroundStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, backgroundColor: background);
  TextStyle h4 = Theme.of(context).textTheme.headline4 ?? backgroundStyle;

  return (Player p) {
    print('playerAsDragTarget ${p.nickname}');
    return playerAsText(p, h4.merge(backgroundStyle));
  };
}

Widget Function(Player) playerAsDraggable(BuildContext context) {
  Color background = Theme.of(context).colorScheme.background;
  TextStyle backgroundStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, backgroundColor: background);
  TextStyle h4 = Theme.of(context).textTheme.headline4 ?? backgroundStyle;

  return (Player p) {
    print('playerAsDraggable ${p.nickname}');
    return playerAsText(p, h4.merge(backgroundStyle));
  };
}

Widget Function(Player) playerAsButtonFn(BuildContext context) {
  return (Player p) {
    print('playerAsButtonFn ${p.nickname}');
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
        child: ElevatedButton(
          onPressed: game.possession == p
              ? null
              : () {
                  game.possession = p;
                },
          child: Tooltip(
              message: p.nickname,
              child: Text(
                p.toString(),
                style: Theme.of(context).textTheme.headline4,
              )),
        ));
  };
}
