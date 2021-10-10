import 'dart:ui';

import 'package:flutter/material.dart';
import './player.dart';

TextStyle defaultStyle(BuildContext context) {
  Color backgroundColor = Theme.of(context).colorScheme.background.withAlpha(150);
  const fontFeatures = [FontFeature.tabularFigures()];

  TextStyle style = Theme.of(context)
      .textTheme
      .headline4!
      .copyWith(backgroundColor: backgroundColor, fontFeatures: fontFeatures);

  return style;
}

TextStyle dragStyle(BuildContext context) {
  Color backgroundColor = Theme.of(context).colorScheme.background.withAlpha(120);
  TextStyle ts = defaultStyle(context)
      .copyWith(decoration: TextDecoration.underline, backgroundColor: backgroundColor);
  return ts;
}

TextStyle deemphasizedStyle(BuildContext context) {
  TextStyle ts = defaultStyle(context);
  Color backgroundColor = Theme.of(context).colorScheme.primary.withAlpha(20);
  Color? textColor = ts.color?.withAlpha(10);
  return ts.copyWith(backgroundColor: backgroundColor, color: textColor);
}

Widget playerAsText(Player p, TextStyle style) {
  var textTransparent = style.copyWith(backgroundColor: style.backgroundColor?.withAlpha(0));
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      child: Tooltip(
          message: p.nickname,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Container(
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
                  child: Text(p.toString(), style: textTransparent)),
              decoration: BoxDecoration(color: style.backgroundColor),
            ),
          )));
}

class DraggableData {
  Player player;
  void Function()? trigger;

  DraggableData(this.player, this.trigger);
}

Widget Function(Player) playerAsDraggable(BuildContext context, {void Function()? trigger}) {
  return (Player p) {
    return Draggable(
      data: DraggableData(p, trigger),
      child: playerAsText(p, defaultStyle(context)),
      onDragStarted: () {},
      onDragEnd: (details) {},
      feedback: Container(
        child: playerAsText(p, dragStyle(context)),
      ),
      childWhenDragging: playerAsText(p, deemphasizedStyle(context)),
    );
  };
}
