import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sun_tan_app/core/ticker.dart';
import 'package:sun_tan_app/features/program/domain/entities/level.dart';
import 'package:sun_tan_app/features/program/presentation/bloc/session_bloc.dart';
import 'package:sun_tan_app/features/program/presentation/bloc/session_event.dart';
import 'package:sun_tan_app/features/program/presentation/bloc/session_state.dart';

class FakeTicker extends Fake implements Ticker {
  @override
  Stream<int> tick({required int totalSeconds}) {
    // Emit synchronously totalSeconds ticks
    final controller = StreamController<int>();
    Future(() async {
      for (int i = 0; i < totalSeconds; i++) {
        controller.add(i + 1);
        await Future<void>.delayed(Duration.zero);
      }
      await controller.close();
    });
    return controller.stream;
  }
}

void main() {
  group('SessionBloc', () {
    final shortLevel = const Level(
      id: 1,
      frontMinutes: 0.01, // ~0.6 sec → min 1 sec after ceil
      backMinutes: 0.01,
      leftMinutes: 0.01,
      rightMinutes: 0.01,
      shadeMinutes: 0.01,
    );

    blocTest<SessionBloc, SessionState>(
      'runs through all steps then completes',
      build: () => SessionBloc(ticker: FakeTicker()),
      act: (bloc) => bloc.add(StartSession(shortLevel)),
      wait: const Duration(seconds: 6),
      expect: () => [
        isA<SessionState>().having((s) => s.isActive, 'active', true).having((s) => s.stepIndex, 'step', 0),
        isA<SessionState>().having((s) => s.stepIndex, 'step', 1),
        isA<SessionState>().having((s) => s.stepIndex, 'step', 2),
        isA<SessionState>().having((s) => s.stepIndex, 'step', 3),
        isA<SessionState>().having((s) => s.stepIndex, 'step', 4),
        isA<SessionState>().having((s) => s.isActive, 'active', false),
      ],
    );
  });
}


