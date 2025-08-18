import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sun_tan_app/features/program/domain/entities/program_progress.dart';
import 'package:sun_tan_app/features/program/domain/repositories/program_repository.dart';
import 'package:sun_tan_app/features/program/domain/rules/goltis_rules.dart';
import 'package:sun_tan_app/features/program/presentation/bloc/program_bloc.dart';
import 'package:sun_tan_app/features/program/presentation/bloc/program_event.dart';
import 'package:sun_tan_app/features/program/presentation/bloc/program_state.dart';

class MockProgramRepository extends Mock implements ProgramRepository {}

void main() {
  late MockProgramRepository repo;

  setUp(() {
    repo = MockProgramRepository();
  });

  setUpAll(() {
    registerFallbackValue(const ProgramProgress(currentLevelId: 1, history: []));
  });

  group('ProgramBloc', () {
    blocTest<ProgramBloc, ProgramState>(
      'LoadRequested loads saved progress',
      build: () {
        when(() => repo.loadProgress()).thenAnswer((_) async => ProgramProgress(currentLevelId: 3, history: const []));
        return ProgramBloc(repository: repo);
      },
      act: (bloc) => bloc.add(const LoadRequested()),
      expect: () => [
        isA<ProgramState>().having((s) => s.isLoading, 'loading', true),
        isA<ProgramState>()
            .having((s) => s.isLoading, 'loading', false)
            .having((s) => s.progress?.currentLevelId, 'level', 3),
      ],
      verify: (_) {
        verify(() => repo.loadProgress()).called(1);
      },
    );

    blocTest<ProgramBloc, ProgramState>(
      'StartProgram initializes at level 1 and saves',
      build: () {
        when(() => repo.saveProgress(any())).thenAnswer((_) async {});
        return ProgramBloc(repository: repo);
      },
      act: (bloc) => bloc.add(const StartProgram()),
      expect: () => [
        isA<ProgramState>().having((s) => s.progress?.currentLevelId, 'level', minLevelId),
      ],
      verify: (_) {
        verify(() => repo.saveProgress(any(that: isA<ProgramProgress>().having((p) => p.currentLevelId, 'level', minLevelId)))).called(1);
      },
    );

    blocTest<ProgramBloc, ProgramState>(
      'CompleteCurrentLevel moves from N to N+1 (via shade) and saves',
      build: () {
        when(() => repo.saveProgress(any())).thenAnswer((_) async {});
        return ProgramBloc(repository: repo);
      },
      seed: () => ProgramState(progress: const ProgramProgress(currentLevelId: 2, history: [])),
      act: (bloc) => bloc.add(CompleteCurrentLevel(DateTime.utc(2025, 6, 23))),
      expect: () => [
        isA<ProgramState>().having((s) => s.progress?.currentLevelId, 'level', 3)
            .having((s) => s.progress!.history.length, 'historyLen', 1),
      ],
      verify: (_) {
        verify(() => repo.saveProgress(any())).called(1);
      },
    );

    blocTest<ProgramBloc, ProgramState>(
      'OverrideLevel clamps within 1..12 and saves',
      build: () {
        when(() => repo.saveProgress(any())).thenAnswer((_) async {});
        return ProgramBloc(repository: repo);
      },
      seed: () => ProgramState(progress: const ProgramProgress(currentLevelId: 5, history: [])),
      act: (bloc) => bloc.add(const OverrideLevel(20)),
      expect: () => [
        isA<ProgramState>().having((s) => s.progress?.currentLevelId, 'level', maxLevelId),
      ],
      verify: (_) {
        verify(() => repo.saveProgress(any())).called(1);
      },
    );

    blocTest<ProgramBloc, ProgramState>(
      'ResetProgram clears repo and sets progress to null',
      build: () {
        when(() => repo.clear()).thenAnswer((_) async {});
        return ProgramBloc(repository: repo);
      },
      seed: () => ProgramState(progress: const ProgramProgress(currentLevelId: 5, history: [])),
      act: (bloc) => bloc.add(const ResetProgram()),
      expect: () => [
        isA<ProgramState>().having((s) => s.progress, 'progress', null),
      ],
      verify: (_) {
        verify(() => repo.clear()).called(1);
      },
    );
  });
}


