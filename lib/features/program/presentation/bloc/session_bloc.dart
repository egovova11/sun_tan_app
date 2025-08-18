import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ticker.dart';
import '../../domain/entities/session_plan.dart';
import 'session_event.dart';
import 'session_state.dart';

typedef OnStepChange = Future<void> Function(int stepIndex);
typedef OnSessionComplete = Future<void> Function();

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final Ticker ticker;
  final OnStepChange? onStepChange;
  final OnSessionComplete? onSessionComplete;

  StreamSubscription<int>? _tickerSub;

  SessionBloc({required this.ticker, this.onStepChange, this.onSessionComplete})
      : super(const SessionState()) {
    on<StartSession>(_onStart);
    on<PauseSession>(_onPause);
    on<ResumeSession>(_onResume);
    on<Tick>(_onTick);
    on<FinishSession>(_onFinish);
  }

  Future<void> _onStart(StartSession event, Emitter<SessionState> emit) async {
    final plan = SessionPlan.fromLevel(event.level);
    emit(SessionState(plan: plan, stepIndex: 0, secondsElapsedInStep: 0, isActive: true));
    await _startTickerForCurrentStep(emit);
    if (onStepChange != null) await onStepChange!(0);
  }

  Future<void> _onPause(PauseSession event, Emitter<SessionState> emit) async {
    await _tickerSub?.cancel();
    emit(state.copyWith(isActive: false));
  }

  Future<void> _onResume(ResumeSession event, Emitter<SessionState> emit) async {
    if (state.plan == null || state.stepIndex < 0) return;
    if (state.isActive) return;
    emit(state.copyWith(isActive: true));
    await _startTickerForCurrentStep(emit);
  }

  Future<void> _onTick(Tick event, Emitter<SessionState> emit) async {
    if (state.plan == null || !state.isActive) return;
    final nextElapsed = state.secondsElapsedInStep + 1;
    final stepFinished = nextElapsed >= state.currentStepDuration!.inSeconds;
    if (!stepFinished) {
      emit(state.copyWith(secondsElapsedInStep: nextElapsed));
      return;
    }

    // Step finished → move to next step or finish session
    await _tickerSub?.cancel();
    final isLastStep = state.stepIndex >= state.plan!.steps.length - 1;
    if (isLastStep) {
      emit(state.copyWith(isActive: false));
      if (onSessionComplete != null) await onSessionComplete!();
      return;
    }

    final nextIndex = state.stepIndex + 1;
    emit(state.copyWith(stepIndex: nextIndex, secondsElapsedInStep: 0));
    await _startTickerForCurrentStep(emit);
    if (onStepChange != null) await onStepChange!(nextIndex);
  }

  Future<void> _onFinish(FinishSession event, Emitter<SessionState> emit) async {
    await _tickerSub?.cancel();
    emit(state.copyWith(isActive: false));
    if (onSessionComplete != null) await onSessionComplete!();
  }

  Future<void> _startTickerForCurrentStep(Emitter<SessionState> emit) async {
    final remaining = state.currentStepDuration!.inSeconds - state.secondsElapsedInStep;
    _tickerSub = ticker
        .tick(totalSeconds: remaining)
        .listen((_) => add(const Tick()));
  }

  @override
  Future<void> close() async {
    await _tickerSub?.cancel();
    return super.close();
  }
}


