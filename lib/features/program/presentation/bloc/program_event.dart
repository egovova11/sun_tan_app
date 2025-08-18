import 'package:equatable/equatable.dart';

abstract class ProgramEvent extends Equatable {
  const ProgramEvent();
}

class LoadRequested extends ProgramEvent {
  const LoadRequested();

  @override
  List<Object?> get props => [];
}

class StartProgram extends ProgramEvent {
  const StartProgram();

  @override
  List<Object?> get props => [];
}

class CompleteCurrentLevel extends ProgramEvent {
  final DateTime completedAtUtc;
  const CompleteCurrentLevel(this.completedAtUtc);

  @override
  List<Object?> get props => [completedAtUtc.millisecondsSinceEpoch];
}

class OverrideLevel extends ProgramEvent {
  final int levelId;
  const OverrideLevel(this.levelId);

  @override
  List<Object?> get props => [levelId];
}

class ResetProgram extends ProgramEvent {
  const ResetProgram();

  @override
  List<Object?> get props => [];
}


