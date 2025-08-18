/// Positions order mirrors the bot: FRONT -> BACK -> LEFT -> RIGHT -> SHADE.
enum Position {
  front,
  back,
  left,
  right,
  shade,
}

extension PositionCycle on Position {
  /// Returns the next position in the cycle.
  Position get next {
    final valuesList = Position.values;
    final index = valuesList.indexOf(this);
    return valuesList[(index + 1) % valuesList.length];
  }
}


