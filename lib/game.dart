// In the future this should have information about the game,
//  like the date, venue, opponent, maybe

import './player.dart';
import './constants.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

var arlington2005RedPlayers = [
  Player(firstName: 'Oliver', lastName: 'Svenburg', number: 4, positions: []),
  Player(firstName: 'Xavier', lastName: 'Johnston', number: 9, positions: []),
  Player(firstName: 'Daniel', lastName: 'Bollman', number: 11, positions: []),
  Player(firstName: 'Zachary', lastName: 'Rader', number: 13, positions: []),
  Player(firstName: 'Tai', lastName: 'Bhalla', number: 15, positions: []),
  Player(firstName: 'Thomas', lastName: 'Wilson', number: 17, nickname: 'Mac', positions: []),
  Player(firstName: 'Harrison', lastName: 'Greenberg', number: 19, positions: []),
  Player(firstName: 'Peter', lastName: 'Kalitka', number: 21, positions: []),
  Player(firstName: 'Logan', lastName: 'Graham', number: 24, positions: []),
  Player(firstName: 'Charles', lastName: 'Russell', number: 25, positions: []),
  Player(firstName: 'Tyler', lastName: 'Foti', number: 26, positions: []),
  Player(firstName: 'Charlie', lastName: 'Taylor', number: 27, positions: []),
  Player(firstName: 'Griffin', lastName: 'Lusk', number: 29, positions: []),
  Player(firstName: 'Alexander', lastName: 'Perine', number: 30, positions: []),
  Player(firstName: 'Jack', lastName: 'Garwood', number: 31, positions: []),
  Player(firstName: 'Oliver', lastName: 'Frandano', number: 33, positions: []),
  Player(firstName: 'Lucas', lastName: 'Wendel', number: 36, positions: []),
  Player(firstName: 'David', lastName: "O'Malley", number: 42, positions: []),
  Player(firstName: 'Noah', lastName: 'Gropper', number: 43, positions: []),
  Player(firstName: 'Elias', lastName: 'Homer', number: 48, positions: []),
  Player(firstName: 'John', lastName: 'Biggle', number: 55, nickname: 'Harrison', positions: []),
  Player(firstName: 'Mohamed', lastName: 'Ahmed', number: 57, positions: []),
  Player(firstName: 'Mr Jersey', lastName: '67', number: 98, jersey: 67, positions: []),
  Player(firstName: 'Mr Jersey', lastName: '13', number: 99, jersey: 13, positions: [])
];

var playerMap = Map.fromEntries(arlington2005RedPlayers.map((Player e) => MapEntry(e.number, e)));

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/counter.txt');
}

const formation = [
  [P7, P9, P11],
  [P6, P10, P8],
  [P2, P4, P5, P3],
  [P1]
];

class Game {
  String description;
  Map<int, Player> playerInfo = {};

  Game(this.description) {
    for (var p in arlington2005RedPlayers) {
      playerInfo[p.number] = p;
    }
  }

  Game init() {
    var players = playerInfo.values.iterator;
    for (var row in formation) {
      for (var position in row) {
        players.moveNext();
        players.current.position = position;
      }
    }
    return this;
  }

  Iterable<Iterable<Player>> onField() {
    return formation.map((rowOfPositions) => rowOfPositions.map((position) => playerInfo.values
        .firstWhere((player) => player.position == position,
            orElse: () => Player.empty(position))));
  }

  Player? getPlayer(int number) {
    return playerInfo[number];
  }

  Future<File> write() async {
    final file = await _localFile;

    var stats = (playerInfo.values).map((player) => player.stats()).followedBy(['']).join('\n');
    // Write the file
    return file.writeAsString(stats);
  }
}
