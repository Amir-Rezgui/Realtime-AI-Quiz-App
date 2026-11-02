class AppConstants {
  AppConstants._();

  static const String appName = 'QuizApp';
  static const String appVersion = '1.0.0';

  // Join code
  static const int joinCodeLength = 6;

  // Game settings
  static const int defaultTimeLimit = 20;
  static const int minTimeLimit = 5;
  static const int maxTimeLimit = 120;
  static const int defaultPoints = 1000;
  static const int minPoints = 100;
  static const int maxPoints = 2000;
  static const int resultsRevealDurationMs = 5000;

  // Player settings
  static const int minNicknameLength = 2;
  static const int maxNicknameLength = 20;

  // Question settings
  static const int minAnswerOptions = 2;
  static const int maxAnswerOptions = 6;
}

class GameStatus {
  GameStatus._();

  static const String lobby = 'lobby';
  static const String inProgress = 'in_progress';
  static const String questionActive = 'question_active';
  static const String showingResults = 'showing_results';
  static const String finished = 'finished';
}

class QuestionType {
  QuestionType._();

  static const String singleChoice = 'single_choice';
  static const String multipleChoice = 'multiple_choice';
}
