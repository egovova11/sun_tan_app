import 'package:equatable/equatable.dart';

import '../../domain/entities/program_progress.dart';

class ProgramState extends Equatable {
  final bool isLoading;
  final ProgramProgress? progress; // null until started
  final String? error;

  const ProgramState({this.isLoading = false, this.progress, this.error});

  ProgramState copyWith({bool? isLoading, ProgramProgress? progress, String? error}) {
    return ProgramState(
      isLoading: isLoading ?? this.isLoading,
      progress: progress ?? this.progress,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, progress, error];
}


