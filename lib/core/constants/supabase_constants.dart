class SupabaseConstants {
  SupabaseConstants._();

  // Table names
  static const String profilesTable = 'profiles';
  static const String quizzesTable = 'quizzes';
  static const String questionsTable = 'questions';
  static const String answersTable = 'answers';
  static const String gameSessionsTable = 'game_sessions';
  static const String playersTable = 'players';
  static const String playerAnswersTable = 'player_answers';
  static const String chatMessagesTable = 'chat_messages';

  // Function names
  static const String generateJoinCodeFunction = 'generate_join_code';
  static const String calculatePointsFunction = 'calculate_points';
  static const String getSessionLeaderboardFunction = 'get_session_leaderboard';

  // Realtime channel prefix
  static const String sessionChannelPrefix = 'session:';

  // Broadcast events
  static const String eventGameStart = 'game:start';
  static const String eventQuestionShow = 'question:show';
  static const String eventQuestionEnd = 'question:end';
  static const String eventResultsShow = 'results:show';
  static const String eventLeaderboardShow = 'leaderboard:show';
  static const String eventGameEnd = 'game:end';
  static const String eventNextQuestionCountdown = 'question:next_countdown';
  static const String eventQuizPause = 'quiz:pause';
  static const String eventQuizResume = 'quiz:resume';
  static const String eventSessionCancelled = 'session:cancelled';
  static const String eventChatMessage = 'chat:message';
}
