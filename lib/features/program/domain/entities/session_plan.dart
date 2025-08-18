import 'package:equatable/equatable.dart';

import 'level.dart';
import 'position.dart';

class SessionStep extends Equatable {
  final Position position;
  final Duration duration;

  const SessionStep({required this.position, required this.duration});

  @override
  List<Object?> get props => [position, duration.inMilliseconds];
}

class SessionPlan extends Equatable {
  final Level level;
  final List<SessionStep> steps; // ordered FRONT -> BACK -> LEFT -> RIGHT -> SHADE

  const SessionPlan({required this.level, required this.steps});

  factory SessionPlan.fromLevel(Level level) {
    Duration minutes(double m) {
      final seconds = (m * 60).ceil();
      return Duration(seconds: seconds < 1 ? 1 : seconds);
    }
    return SessionPlan(
      level: level,
      steps: [
        SessionStep(position: Position.front, duration: minutes(level.frontMinutes)),
        SessionStep(position: Position.back, duration: minutes(level.backMinutes)),
        SessionStep(position: Position.left, duration: minutes(level.leftMinutes)),
        SessionStep(position: Position.right, duration: minutes(level.rightMinutes)),
        SessionStep(position: Position.shade, duration: minutes(level.shadeMinutes)),
      ],
    );
  }

  @override
  List<Object?> get props => [level, steps];
}


