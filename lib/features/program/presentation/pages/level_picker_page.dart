 import 'package:flutter/material.dart';

import '../../domain/rules/goltis_rules.dart';

class LevelPickerPage extends StatelessWidget {
  const LevelPickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick Level')),
      body: ListView.separated(
        itemCount: goltisLevels.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final level = goltisLevels[index];
          return ListTile(
            title: Text('Level ${level.id}'),
            subtitle: Text('Front ${level.frontMinutes}m, Back ${level.backMinutes}m, Shade ${level.shadeMinutes}m'),
            onTap: () => Navigator.of(context).pop(level.id),
          );
        },
      ),
    );
  }
}


