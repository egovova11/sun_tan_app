import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/program_progress.dart';
import '../../domain/entities/position.dart';
import '../../domain/repositories/program_repository.dart';
import '../../domain/rules/goltis_rules.dart';
import 'program_event.dart';
import 'program_state.dart';

class ProgramBloc extends Bloc<ProgramEvent, ProgramState> {
  final ProgramRepository repository;

  ProgramBloc({required this.repository}) : super(const ProgramState(isLoading: true)) {
    on<LoadRequested>(_onLoad);
    on<StartProgram>(_onStart);
    on<CompleteCurrentLevel>(_onCompleteCurrent);
    on<OverrideLevel>(_onOverride);
    on<ResetProgram>(_onReset);
  }

  Future<void> _onLoad(LoadRequested event, Emitter<ProgramState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final saved = await repository.loadProgress();
      emit(ProgramState(isLoading: false, progress: saved));
    } catch (e) {
      emit(ProgramState(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onStart(StartProgram event, Emitter<ProgramState> emit) async {
    final progress = ProgramProgress(currentLevelId: minLevelId, history: const []);
    await repository.saveProgress(progress);
    emit(state.copyWith(isLoading: false, progress: progress, error: null));
  }

  Future<void> _onCompleteCurrent(
    CompleteCurrentLevel event,
    Emitter<ProgramState> emit,
  ) async {
    final current = state.progress;
    if (current == null) return;

    final level = getLevelById(current.currentLevelId);
    // Next level follows LevelService.next after finishing SHADE position
    final next = nextLevelForPosition(level, Position.shade);

    final updatedHistory = List<LevelCompletion>.from(current.history)
      ..add(LevelCompletion(levelId: current.currentLevelId, completedAtUtc: event.completedAtUtc.toUtc()));
    final newProgress = ProgramProgress(currentLevelId: next.id, history: updatedHistory);
    await repository.saveProgress(newProgress);
    emit(state.copyWith(progress: newProgress, error: null));
  }

  Future<void> _onOverride(OverrideLevel event, Emitter<ProgramState> emit) async {
    final current = state.progress;
    if (current == null) return;
    final clamped = event.levelId.clamp(minLevelId, maxLevelId);
    final newProgress = current.copyWith(currentLevelId: clamped);
    await repository.saveProgress(newProgress);
    emit(state.copyWith(progress: newProgress, error: null));
  }

  Future<void> _onReset(ResetProgram event, Emitter<ProgramState> emit) async {
    await repository.clear();
    emit(const ProgramState(isLoading: false, progress: null));
  }
}


