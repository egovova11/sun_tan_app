import 'package:equatable/equatable.dart';

import 'position.dart';

class Level extends Equatable {
  final int id; // 1..12
  final double frontMinutes;
  final double backMinutes;
  final double leftMinutes;
  final double rightMinutes;
  final double shadeMinutes;

  const Level({
    required this.id,
    required this.frontMinutes,
    required this.backMinutes,
    required this.leftMinutes,
    required this.rightMinutes,
    required this.shadeMinutes,
  });

  double minutesFor(Position position) {
    switch (position) {
      case Position.front:
        return frontMinutes;
      case Position.back:
        return backMinutes;
      case Position.left:
        return leftMinutes;
      case Position.right:
        return rightMinutes;
      case Position.shade:
        return shadeMinutes;
    }
  }

  @override
  List<Object?> get props => [
        id,
        frontMinutes,
        backMinutes,
        leftMinutes,
        rightMinutes,
        shadeMinutes,
      ];
}


