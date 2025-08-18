import 'dart:math';

import '../entities/level.dart';
import '../entities/position.dart';

/// Constants mirror LevelService in the bot
const int minLevelId = 1;
const int maxLevelId = 12;
const int levelReductionOnOverdue = 2;

/// The fixed Goltis scheme levels, ported from init.sql.
const List<Level> goltisLevels = [
  Level(id: 1, frontMinutes: 1.5, backMinutes: 1.5, leftMinutes: 1, rightMinutes: 1, shadeMinutes: 3),
  Level(id: 2, frontMinutes: 2, backMinutes: 2, leftMinutes: 1, rightMinutes: 1, shadeMinutes: 3),
  Level(id: 3, frontMinutes: 3, backMinutes: 3, leftMinutes: 1.5, rightMinutes: 1.5, shadeMinutes: 5),
  Level(id: 4, frontMinutes: 5, backMinutes: 5, leftMinutes: 2.5, rightMinutes: 2.5, shadeMinutes: 5),
  Level(id: 5, frontMinutes: 7, backMinutes: 7, leftMinutes: 3, rightMinutes: 3, shadeMinutes: 7),
  Level(id: 6, frontMinutes: 9, backMinutes: 9, leftMinutes: 5, rightMinutes: 5, shadeMinutes: 10),
  Level(id: 7, frontMinutes: 12, backMinutes: 12, leftMinutes: 7, rightMinutes: 7, shadeMinutes: 10),
  Level(id: 8, frontMinutes: 15, backMinutes: 15, leftMinutes: 10, rightMinutes: 10, shadeMinutes: 10),
  Level(id: 9, frontMinutes: 20, backMinutes: 20, leftMinutes: 15, rightMinutes: 15, shadeMinutes: 15),
  Level(id: 10, frontMinutes: 25, backMinutes: 25, leftMinutes: 20, rightMinutes: 20, shadeMinutes: 20),
  Level(id: 11, frontMinutes: 35, backMinutes: 35, leftMinutes: 25, rightMinutes: 25, shadeMinutes: 30),
  Level(id: 12, frontMinutes: 45, backMinutes: 45, leftMinutes: 30, rightMinutes: 30, shadeMinutes: 40),
];

Level getLevelById(int id) {
  return goltisLevels.firstWhere((l) => l.id == id);
}

Level getFirstLevel() => goltisLevels.first;

/// Mirrors LevelService.next(currentLevel, position)
Level nextLevelForPosition(Level currentLevel, Position position) {
  if (currentLevel.id == maxLevelId && position == Position.shade) {
    return getFirstLevel();
  }
  if (position == Position.shade) {
    return getLevelById(min(currentLevel.id + 1, maxLevelId));
  }
  return currentLevel;
}

/// Applies the overdue reduction rule used on resume when session is overdue.
int reducedLevelId(int currentLevelId) {
  if (currentLevelId <= minLevelId + 1) {
    return minLevelId;
  }
  return max(minLevelId, currentLevelId - levelReductionOnOverdue);
}

/// Mirrors SessionService.isSessionOverdue: finishTimerDate < start of today
bool isOverdue(DateTime finishTimerDateLocalNow, {DateTime? now}) {
  final clock = now ?? DateTime.now();
  final startOfToday = DateTime(clock.year, clock.month, clock.day);
  return finishTimerDateLocalNow.isBefore(startOfToday);
}


