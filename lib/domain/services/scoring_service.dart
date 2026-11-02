import 'dart:math';

class ScoringService {
  ScoringService._();

  static int calculatePoints({
    required int basePoints,
    required int timeLimitMs,
    required int responseTimeMs,
    required bool isCorrect,
    int currentStreak = 0,
  }) {
    if (!isCorrect) return 0;

    // Time-based multiplier (1.0 to 0.5)
    final timeMultiplier = 1.0 - (responseTimeMs / timeLimitMs) * 0.5;

    // Streak bonus (+10% per consecutive correct, max 50%)
    final streakBonus = min(currentStreak * 0.1, 0.5);

    final points = (basePoints * timeMultiplier * (1 + streakBonus)).round();

    // Minimum 50% of base points for correct answer
    return max(points, (basePoints * 0.5).round());
  }

  static bool checkAnswer({
    required List<String> selectedIds,
    required List<String> correctIds,
    required bool isMultipleChoice,
  }) {
    if (selectedIds.isEmpty) return false;

    if (isMultipleChoice) {
      // For multiple choice, all correct answers must be selected
      // and no incorrect answers should be selected
      final selectedSet = selectedIds.toSet();
      final correctSet = correctIds.toSet();
      return selectedSet.containsAll(correctSet) &&
          correctSet.containsAll(selectedSet);
    } else {
      // For single choice, exactly one answer must be selected and be correct
      if (selectedIds.length != 1) return false;
      return correctIds.contains(selectedIds.first);
    }
  }
}
