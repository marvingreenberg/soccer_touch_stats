// child: Padding(
//   padding: EdgeInsets.all(32.0),
//   child: Container(
//     width: 40.0,
//     height: 40.0,

// return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(
//           horizontal: 6.0,
//         ),
//         child: DragTarget<Item>(
//           builder: (context, candidateItems, rejectedItems) {
//             return CustomerCart(
//               hasItems: customer.items.isNotEmpty,
//               highlighted: candidateItems.isNotEmpty,
//               customer: customer,
//             );
//           },
//           onAccept: (item) {
//             _itemDroppedOnCustomerCart(
//               item: item,
//               customer: customer,
//             );
//           },
//         ),

// (stats not used for rendeting)
// ignore: must_be_immutable
// import 'package:flutter/material.dart';

class Player {
  final String firstName;
  final String lastName;
  final String nickname;
  final int jersey;
  final int number;
  Set<int> preferredPositions;

  int position = -1;
  int passes = 0;
  int shots = 0;
  int goals = 0;
  int turnovers = 0;

  var playTime = const [Duration(seconds: 0), Duration(seconds: 0)]; // Two halfs

  int? timeIn;

  @override
  String toString() {
    return number.toString();
  }

  String header() {
    return 'number,firstName,lastName,passes,shots,goals,turnovers,firstHalfTime,secondHalfTime';
  }

  subIn(int half) {
    timeIn = DateTime.now().millisecondsSinceEpoch;
  }

  subOut(int half) {
    if (timeIn == null) return; // Should not be able to subOut without subIn

    playTime[half] =
        playTime[half] + Duration(milliseconds: DateTime.now().millisecondsSinceEpoch - timeIn!);
  }

  String stats() {
    var times = [...playTime.map((d) => d.inMinutes)];
    var statString = ([passes, shots, goals, turnovers] + times).join(',');

    return '$number,$firstName,$lastName,$statString';
  }

  Player.empty(int position)
      : this(firstName: '', lastName: '', number: -position, position: position, positions: []);

  static var noPossession = Player.empty(-1);

  Player(
      {required this.firstName,
      required this.lastName,
      required this.number,
      required List<int> positions,
      this.position = -1,
      int? jersey,
      String? nickname})
      : jersey = jersey ?? number,
        preferredPositions = Set.from(positions),
        nickname = nickname ?? firstName;
}
