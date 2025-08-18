import '../entities/program_progress.dart';

abstract class ProgramRepository {
  Future<ProgramProgress?> loadProgress();

  Future<void> saveProgress(ProgramProgress progress);

  Future<void> clear();
}


