import 'package:flutter/material.dart';
import './touch_page.dart';
import './game.dart';

Game game = Game('Today').init();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soccer Touch',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TouchPage(title: 'Soccer Touch Tracker', game: game),
    );
  }
}
