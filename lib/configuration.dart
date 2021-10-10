import 'package:flutter/material.dart';

import './game.dart';
// import './player.dart';

class Configuration extends StatefulWidget {
  const Configuration({Key? key}) : super(key: key);

  @override
  State<Configuration> createState() => ConfigurationState();
}

class ConfigurationState extends State<Configuration> {
  void writeStats() async {
    await game.write();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
              child: Row(children: const [Text('Nothing to see here')])),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
              child: Row(children: const [Text('Move along')])),
        ],
      ),
    );
  }
}
