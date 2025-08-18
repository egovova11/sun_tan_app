import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/rules/goltis_rules.dart';
import '../bloc/program_bloc.dart';
import '../bloc/program_event.dart';
import '../bloc/program_state.dart';
import '../bloc/session_bloc.dart';
import '../bloc/session_event.dart';
import 'level_picker_page.dart';
import 'session_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sun Tan — Goltis Scheme')),
      body: BlocBuilder<ProgramBloc, ProgramState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.progress == null) {
            return Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Program'),
                onPressed: () => context.read<ProgramBloc>().add(const StartProgram()),
              ),
            );
          }
          final progress = state.progress!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Current level: ${progress.currentLevelId}', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text('Completed sessions: ${progress.history.length}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.timer),
                  label: const Text('Start Session'),
                  onPressed: () {
                    final level = getLevelById(progress.currentLevelId);
                    // Reset any existing session and start anew
                    final sessionBloc = context.read<SessionBloc>();
                    sessionBloc.add(StartSession(level));
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SessionPage()),
                    );
                  },
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  icon: const Icon(Icons.tune),
                  label: const Text('Override Level'),
                  onPressed: () async {
                    final selected = await Navigator.of(context).push<int>(
                      MaterialPageRoute(builder: (_) => const LevelPickerPage()),
                    );
                    if (!context.mounted) return;
                    if (selected != null) {
                      context.read<ProgramBloc>().add(OverrideLevel(selected));
                    }
                  },
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Reset Program'),
                  onPressed: () => context.read<ProgramBloc>().add(const ResetProgram()),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


