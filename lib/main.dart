import 'package:flutter/material.dart';
import 'package:soccer_touch_stats/configuration.dart';
import 'package:soccer_touch_stats/game_setup.dart';
import './touch_page.dart';

void main() => runApp(const GameApp());

/// This is the main application widget.
class GameApp extends StatelessWidget {
  const GameApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soccer Touch',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AppPageSelectionWidget(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class AppPageSelectionWidget extends StatefulWidget {
  const AppPageSelectionWidget({Key? key}) : super(key: key);

  @override
  State<AppPageSelectionWidget> createState() => _AppPageSelectionWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _AppPageSelectionWidgetState extends State<AppPageSelectionWidget> {
  int _selectedIndex = 0;
  static const List<Widget> _appWidgetPanes = <Widget>[
    GameSetupPage(title: 'Setup and Substitutions'),
    TouchPage(),
    Configuration(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soccer Touch Stats'),
      ),
      body: Center(
        child: _appWidgetPanes.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horizontal_circle),
            label: 'OnField',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle),
            label: 'Play',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setup',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
