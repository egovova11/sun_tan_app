import '../../domain/entities/program_progress.dart';

class LevelCompletionDto {
  final int levelId;
  final int completedAtMillis; // UTC millis

  LevelCompletionDto({required this.levelId, required this.completedAtMillis});

  factory LevelCompletionDto.fromEntity(LevelCompletion e) => LevelCompletionDto(
        levelId: e.levelId,
        completedAtMillis: e.completedAtUtc.millisecondsSinceEpoch,
      );

  LevelCompletion toEntity() => LevelCompletion(
        levelId: levelId,
        completedAtUtc: DateTime.fromMillisecondsSinceEpoch(completedAtMillis, isUtc: true),
      );

  Map<String, dynamic> toJson() => {
        'levelId': levelId,
        'completedAtMillis': completedAtMillis,
      };

  factory LevelCompletionDto.fromJson(Map<String, dynamic> json) => LevelCompletionDto(
        levelId: json['levelId'] as int,
        completedAtMillis: json['completedAtMillis'] as int,
      );
}

class ProgramProgressDto {
  final int currentLevelId;
  final List<LevelCompletionDto> history;

  ProgramProgressDto({required this.currentLevelId, required this.history});

  factory ProgramProgressDto.fromEntity(ProgramProgress e) => ProgramProgressDto(
        currentLevelId: e.currentLevelId,
        history: e.history.map(LevelCompletionDto.fromEntity).toList(),
      );

  ProgramProgress toEntity() => ProgramProgress(
        currentLevelId: currentLevelId,
        history: history.map((e) => e.toEntity()).toList(),
      );

  Map<String, dynamic> toJson() => {
        'currentLevelId': currentLevelId,
        'history': history.map((e) => e.toJson()).toList(),
      };

  factory ProgramProgressDto.fromJson(Map<String, dynamic> json) => ProgramProgressDto(
        currentLevelId: json['currentLevelId'] as int,
        history: (json['history'] as List<dynamic>)
            .map((e) => LevelCompletionDto.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}


