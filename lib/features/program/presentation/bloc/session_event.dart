import 'package:equatable/equatable.dart';

import '../../domain/entities/level.dart';

abstract class SessionEvent extends Equatable {
  const SessionEvent();
}

class StartSession extends SessionEvent {
  final Level level;
  const StartSession(this.level);

  @override
  List<Object?> get props => [level.id];
}

class PauseSession extends SessionEvent {
  const PauseSession();

  @override
  List<Object?> get props => [];
}

class ResumeSession extends SessionEvent {
  const ResumeSession();

  @override
  List<Object?> get props => [];
}

class Tick extends SessionEvent {
  const Tick();

  @override
  List<Object?> get props => [];
}

class FinishSession extends SessionEvent {
  const FinishSession();

  @override
  List<Object?> get props => [];
}


