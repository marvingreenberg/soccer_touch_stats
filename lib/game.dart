// In the future this should have information about the game,
//  like the date, venue, opponent, maybe

import './player.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

const playersOnField = [
  [15, 21, 57],
  [33, 11, 19],
  [98, 25, 33, 99],
  [13]
];

var arlington2005RedPlayers = [
  Player('Oliver', 'Svenburg', 4),
  Player('Xavier', 'Johnston', 9),
  Player('Daniel', 'Bollman', 11),
  Player('Zachary', 'Rader', 13),
  Player('Tai', 'Bhalla', 15),
  Player('Thomas', 'Wilson', 17, nickname: 'Mac'),
  Player('Harrison', 'Greenberg', 19, nickname: 'Hendo'),
  Player('Peter', 'Kalitka', 21),
  Player('Logan', 'Graham', 24),
  Player('Charles', 'Russell', 25),
  Player('Tyler', 'Foti', 26),
  Player('Charlie', 'Taylor', 27),
  Player('Griffin', 'Lusk', 29),
  Player('Alexander', 'Perine', 30),
  Player('Jack', 'Garwood', 31),
  Player('Oliver', 'Frandano', 33),
  Player('Lucas', 'Wendel', 36),
  Player('David', "O'Malley", 42),
  Player('Noah', 'Gropper', 43),
  Player('Elias', 'Homer', 48),
  Player('John', 'Biggle', 55, nickname: 'Harrison'),
  Player('Mohamed', 'Ahmed', 57),
  Player('Mr Jersey', '67', 98, jersey: 67),
  Player('Mr Jersey', '13', 99, jersey: 13)
];

var activePlayers = playersOnField.expand((l) => l).toList();
var players = <Player>[];

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/counter.txt');
}

class Game {
  String description;
  Map<int, Player> playerInfo = {};
  List<Player> players;

  Game(this.description, this.players) {
    for (var p in players) {
      playerInfo[p.number] = p;
    }
  }

  Player? getPlayer(int number) {
    return playerInfo[number];
  }

  Future<File> write() async {
    final file = await _localFile;

    var stats =
        (players).map((player) => player.stats()).followedBy(['']).join('\n');
    // Write the file
    print('--- write $file');
    return file.writeAsString(stats);
  }
  // void setPlayerOnField(int row, int index);
}
