import '../features/program/data/datasources/program_local_data_source.dart';
import '../features/program/data/repositories/program_repository_impl.dart';
import '../features/program/domain/repositories/program_repository.dart';
import '../features/program/presentation/bloc/program_bloc.dart';
import '../features/program/presentation/bloc/session_bloc.dart';
import '../core/notifications/notifications_service.dart';
import '../core/ticker.dart';

ProgramRepository? _programRepository;

ProgramRepository programRepository() {
  return _programRepository ??= ProgramRepositoryImpl(local: ProgramLocalDataSource());
}

ProgramBloc createProgramBloc() {
  return ProgramBloc(repository: programRepository());
}

NotificationsService? _notificationsService;
NotificationsService notificationsService() {
  return _notificationsService ??= NotificationsService();
}

SessionBloc createSessionBloc() {
  final notifier = notificationsService();
  return SessionBloc(
    ticker: Ticker(),
    onStepChange: (i) => notifier.showStepChange(i),
    onSessionComplete: () => notifier.showStepChange(999, title: 'Session finished', body: 'You are done!'),
  );
}


