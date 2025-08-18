import 'package:equatable/equatable.dart';

import '../../domain/entities/position.dart';
import '../../domain/entities/session_plan.dart';

class SessionState extends Equatable {
  final SessionPlan? plan;
  final int stepIndex; // -1 when idle
  final int secondsElapsedInStep;
  final bool isActive;
  final bool isCompleted;

  const SessionState({
    this.plan,
    this.stepIndex = -1,
    this.secondsElapsedInStep = 0,
    this.isActive = false,
    this.isCompleted = false,
  });

  bool get isIdle => plan == null || stepIndex < 0;

  Position? get currentPosition =>
      isIdle ? null : plan!.steps[stepIndex].position;

  Duration? get currentStepDuration =>
      isIdle ? null : plan!.steps[stepIndex].duration;

  bool get isCurrentStepFinished =>
      currentStepDuration != null && secondsElapsedInStep >= currentStepDuration!.inSeconds;

  SessionState copyWith({
    SessionPlan? plan,
    int? stepIndex,
    int? secondsElapsedInStep,
    bool? isActive,
    bool? isCompleted,
  }) {
    return SessionState(
      plan: plan ?? this.plan,
      stepIndex: stepIndex ?? this.stepIndex,
      secondsElapsedInStep: secondsElapsedInStep ?? this.secondsElapsedInStep,
      isActive: isActive ?? this.isActive,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [plan, stepIndex, secondsElapsedInStep, isActive, isCompleted];
}


