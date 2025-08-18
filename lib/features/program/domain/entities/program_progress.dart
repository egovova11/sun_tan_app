import 'package:equatable/equatable.dart';

class LevelCompletion extends Equatable {
  final int levelId;
  final DateTime completedAtUtc;

  const LevelCompletion({required this.levelId, required this.completedAtUtc});

  @override
  List<Object?> get props => [levelId, completedAtUtc.millisecondsSinceEpoch];
}

class ProgramProgress extends Equatable {
  final int currentLevelId; // 1..12
  final List<LevelCompletion> history;

  const ProgramProgress({required this.currentLevelId, required this.history});

  DateTime? get lastCompletedAtUtc =>
      history.isEmpty ? null : history.last.completedAtUtc;

  ProgramProgress completeLevel(int levelId, DateTime whenUtc) {
    final newHistory = List<LevelCompletion>.from(history)
      ..add(LevelCompletion(levelId: levelId, completedAtUtc: whenUtc));
    return ProgramProgress(currentLevelId: currentLevelId, history: newHistory);
  }

  ProgramProgress copyWith({int? currentLevelId, List<LevelCompletion>? history}) {
    return ProgramProgress(
      currentLevelId: currentLevelId ?? this.currentLevelId,
      history: history ?? this.history,
    );
  }

  @override
  List<Object?> get props => [currentLevelId, history];
}


