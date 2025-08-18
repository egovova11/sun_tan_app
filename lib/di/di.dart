import '../features/program/data/datasources/program_local_data_source.dart';
import '../features/program/data/repositories/program_repository_impl.dart';
import '../features/program/domain/repositories/program_repository.dart';
import '../features/program/presentation/bloc/program_bloc.dart';

ProgramRepository? _programRepository;

ProgramRepository programRepository() {
  return _programRepository ??= ProgramRepositoryImpl(local: ProgramLocalDataSource());
}

ProgramBloc createProgramBloc() {
  return ProgramBloc(repository: programRepository());
}


