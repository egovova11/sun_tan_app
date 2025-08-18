import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/program_bloc.dart';
import '../bloc/program_event.dart';
import '../bloc/session_bloc.dart';
import '../bloc/session_event.dart';
import '../bloc/session_state.dart';

class SessionPage extends StatelessWidget {
  const SessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Session')),
      body: BlocConsumer<SessionBloc, SessionState>(
        listener: (context, state) {
          if (!state.isActive && !state.isIdle) {
            // session completed
            context.read<ProgramBloc>().add(CompleteCurrentLevel(DateTime.now().toUtc()));
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state.isIdle) {
            return const Center(child: Text('No active session'));
          }
          final step = state.plan!.steps[state.stepIndex];
          final remaining = step.duration.inSeconds - state.secondsElapsedInStep;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Level ${state.plan!.level.id}', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text('Step ${state.stepIndex + 1} / ${state.plan!.steps.length}'),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text('Position: ${step.position.name.toUpperCase()}'),
                        const SizedBox(height: 8),
                        Text('Remaining: ${remaining}s'),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => context.read<SessionBloc>().add(const PauseSession()),
                        icon: const Icon(Icons.pause),
                        label: const Text('Pause'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => context.read<SessionBloc>().add(const ResumeSession()),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Resume'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


