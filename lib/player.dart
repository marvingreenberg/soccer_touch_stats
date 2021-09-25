import './common.dart';

class Player {
  final String firstName;
  final String lastName;
  final String nickname;
  final int jersey;
  final int number;

  int passes = 0;
  var counts = {
    EndCondition.shot: 0,
    EndCondition.goal: 0,
    EndCondition.turnOver: 0
  };

  // Set playTime on subout
  var playTime = {Half.first: 0.0, Half.second: 0.0};
  double secondHalfPlayTime = 0.0;

  double timeIn = 0.0;
  double timeOut = 0.0;

  Player(this.firstName, this.lastName, this.number,
      {int? jersey, String? nickname})
      : jersey = jersey ?? number,
        nickname = nickname ?? firstName;

  String header() {
    return 'number,firstName,lastName,passes,shots,goals,turnovers';
  }

  String stats() {
    var statString = ([passes] + counts.values.toList()).join(',');
    return '$number,$firstName,$lastName,$statString';
  }

  subIn(double timeIn, Half half) {
    timeIn = timeIn;
  }

  subOut(double timeIn) {
    timeOut = timeIn;
  }

  addPass() {
    passes += 1;
  }

  addEndCondition(EndCondition kind) {
    if (kind == EndCondition.stopPlay) return;
    counts[kind] = (counts[kind] ?? 0) + 1;
  }
}
