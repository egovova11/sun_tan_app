import '../../domain/entities/program_progress.dart';
import '../../domain/repositories/program_repository.dart';
import '../datasources/program_local_data_source.dart';
import '../models/program_models.dart';

class ProgramRepositoryImpl implements ProgramRepository {
  final ProgramLocalDataSource local;

  ProgramRepositoryImpl({required this.local});

  @override
  Future<void> clear() => local.clear();

  @override
  Future<ProgramProgress?> loadProgress() async {
    final dto = await local.readProgress();
    return dto?.toEntity();
  }

  @override
  Future<void> saveProgress(ProgramProgress progress) async {
    final dto = ProgramProgressDto.fromEntity(progress);
    await local.writeProgress(dto);
  }
}


