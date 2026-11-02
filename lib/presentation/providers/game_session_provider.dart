import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/game_session_repository.dart';
import '../../data/repositories/quiz_repository.dart';
import '../../data/repositories/player_repository.dart';
import '../../data/repositories/chat_repository.dart';
import '../../data/datasources/supabase_client.dart';
import '../../data/models/game_session_model.dart';
import '../../data/models/quiz_model.dart';
import '../../data/models/player_model.dart';
import '../../data/models/leaderboard_entry_model.dart';
import '../../domain/services/realtime_service.dart';
import '../../domain/services/scoring_service.dart';
import '../../core/constants/app_constants.dart';

// Session by ID provider
final sessionProvider = StreamProvider.family<GameSessionModel, String>((
  ref,
  sessionId,
) async* {
  final repository = ref.watch(gameSessionRepositoryProvider);
  const refreshInterval = Duration(seconds: 2);
  var isActive = true;
  ref.onDispose(() {
    isActive = false;
  });

  GameSessionModel? latest;
  while (isActive) {
    try {
      latest = await repository.getSession(sessionId);
      yield latest;
    } catch (e) {
      if (latest == null) rethrow;
    }
    await Future<void>.delayed(refreshInterval);
  }
});

// Session players provider
final sessionPlayersProvider =
    StreamProvider.family<List<PlayerModel>, String>((
  ref,
  sessionId,
) async* {
  final repository = ref.watch(playerRepositoryProvider);
  const refreshInterval = Duration(milliseconds: 700);
  List<PlayerModel> sortStable(List<PlayerModel> players) {
    final copy = [...players];
    copy.sort((a, b) {
      final aJoined = a.joinedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bJoined = b.joinedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final byJoined = aJoined.compareTo(bJoined);
      if (byJoined != 0) return byJoined;
      return a.id.compareTo(b.id);
    });
    return copy;
  }

  bool isActive = true;
  ref.onDispose(() {
    isActive = false;
  });

  var latest = <PlayerModel>[];
  while (isActive) {
    try {
      final current = sortStable(await repository.getSessionPlayers(sessionId));
      final sameLength = current.length == latest.length;
      final sameIds = sameLength &&
          List.generate(current.length, (i) => current[i].id == latest[i].id)
              .every((v) => v);
      if (!sameIds) {
        latest = current;
        yield current;
      }
    } catch (_) {
      if (latest.isEmpty) {
        yield const <PlayerModel>[];
      }
    }
    await Future<void>.delayed(refreshInterval);
  }
});

// Recent sessions for current host
final myRecentSessionsProvider = FutureProvider<List<GameSessionModel>>((
  ref,
) async {
  final repository = ref.watch(gameSessionRepositoryProvider);
  return repository.getMyRecentSessions();
});

final mySessionsProvider = FutureProvider<List<GameSessionModel>>((ref) async {
  final repository = ref.watch(gameSessionRepositoryProvider);
  return repository.getMySessions();
});

final mySessionsLiveProvider =
    StreamProvider<List<GameSessionModel>>((ref) async* {
  final repository = ref.watch(gameSessionRepositoryProvider);
  const refreshInterval = Duration(seconds: 1);
  var isActive = true;
  ref.onDispose(() {
    isActive = false;
  });

  var latest = <GameSessionModel>[];
  while (isActive) {
    try {
      latest = await repository.getMySessions();
      yield latest;
    } catch (_) {
      yield latest;
    }
    await Future<void>.delayed(refreshInterval);
  }
});

final mySessionPlayerCountsProvider =
    StreamProvider<Map<String, int>>((ref) async* {
  final sessionRepository = ref.watch(gameSessionRepositoryProvider);
  final playerRepository = ref.watch(playerRepositoryProvider);
  const refreshInterval = Duration(seconds: 1);
  var isActive = true;
  ref.onDispose(() {
    isActive = false;
  });

  var latest = <String, int>{};
  while (isActive) {
    try {
      final sessions = await sessionRepository.getMySessions();
      final counts = <String, int>{};
      for (final session in sessions) {
        final connected = await playerRepository.getPlayerCount(session.id);
        counts[session.id] = connected;
      }
      latest = counts;
      yield latest;
    } catch (_) {
      yield latest;
    }
    await Future<void>.delayed(refreshInterval);
  }
});

// Host game notifier - NOT autoDispose to persist during navigation
final hostGameProvider = StateNotifierProvider<HostGameNotifier, HostGameState>(
  (ref) {
    final notifier = HostGameNotifier(
      ref.watch(gameSessionRepositoryProvider),
      ref.watch(quizRepositoryProvider),
      ref.watch(playerRepositoryProvider),
      ref.watch(chatRepositoryProvider),
      ref,
    );
    ref.onDispose(() {
      notifier.cleanup();
    });
    return notifier;
  },
);

class HostGameState {
  final bool isLoading;
  final String? error;
  final GameSessionModel? session;
  final QuizModel? quiz;
  final int answeredCount;
  final int totalPlayers;
  final Timer? questionTimer;
  final int remainingSeconds;
  final Map<String, int> answerDistribution;
  final bool isQuestionRevealed;
  final bool canGoToNextQuestion;
  final bool isPaused;
  final bool isShowingRoundLeaderboard;
  final int nextQuestionCountdownSeconds;
  final List<String> revealedCorrectAnswerIds;
  final List<Map<String, dynamic>> roundLeaderboard;
  final List<HostChatMessage> chatMessages;

  const HostGameState({
    this.isLoading = false,
    this.error,
    this.session,
    this.quiz,
    this.answeredCount = 0,
    this.totalPlayers = 0,
    this.questionTimer,
    this.remainingSeconds = 0,
    this.answerDistribution = const {},
    this.isQuestionRevealed = false,
    this.canGoToNextQuestion = false,
    this.isPaused = false,
    this.isShowingRoundLeaderboard = false,
    this.nextQuestionCountdownSeconds = 0,
    this.revealedCorrectAnswerIds = const [],
    this.roundLeaderboard = const [],
    this.chatMessages = const [],
  });

  HostGameState copyWith({
    bool? isLoading,
    String? error,
    GameSessionModel? session,
    QuizModel? quiz,
    int? answeredCount,
    int? totalPlayers,
    Timer? questionTimer,
    int? remainingSeconds,
    Map<String, int>? answerDistribution,
    bool? isQuestionRevealed,
    bool? canGoToNextQuestion,
    bool? isPaused,
    bool? isShowingRoundLeaderboard,
    int? nextQuestionCountdownSeconds,
    List<String>? revealedCorrectAnswerIds,
    List<Map<String, dynamic>>? roundLeaderboard,
    List<HostChatMessage>? chatMessages,
  }) {
    return HostGameState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      session: session ?? this.session,
      quiz: quiz ?? this.quiz,
      answeredCount: answeredCount ?? this.answeredCount,
      totalPlayers: totalPlayers ?? this.totalPlayers,
      questionTimer: questionTimer ?? this.questionTimer,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      answerDistribution: answerDistribution ?? this.answerDistribution,
      isQuestionRevealed: isQuestionRevealed ?? this.isQuestionRevealed,
      canGoToNextQuestion: canGoToNextQuestion ?? this.canGoToNextQuestion,
      isPaused: isPaused ?? this.isPaused,
      isShowingRoundLeaderboard:
          isShowingRoundLeaderboard ?? this.isShowingRoundLeaderboard,
      nextQuestionCountdownSeconds:
          nextQuestionCountdownSeconds ?? this.nextQuestionCountdownSeconds,
      revealedCorrectAnswerIds:
          revealedCorrectAnswerIds ?? this.revealedCorrectAnswerIds,
      roundLeaderboard: roundLeaderboard ?? this.roundLeaderboard,
      chatMessages: chatMessages ?? this.chatMessages,
    );
  }
}

class HostChatMessage {
  final String playerId;
  final String nickname;
  final String message;
  final DateTime sentAt;
  final bool isSystem;

  const HostChatMessage({
    required this.playerId,
    required this.nickname,
    required this.message,
    required this.sentAt,
    this.isSystem = false,
  });
}

class HostGameNotifier extends StateNotifier<HostGameState>
    with WidgetsBindingObserver {
  final GameSessionRepository _sessionRepository;
  final QuizRepository _quizRepository;
  final PlayerRepository _playerRepository;
  final ChatRepository _chatRepository;
  final Ref _ref;
  RealtimeService? _realtimeService;
  StreamSubscription? _eventSubscription;
  bool _isDisposed = false;
  bool _hostExitHandled = false;

  HostGameNotifier(
    this._sessionRepository,
    this._quizRepository,
    this._playerRepository,
    this._chatRepository,
    this._ref,
  ) : super(const HostGameState()) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    if (_isDisposed || _hostExitHandled || state.session == null) return;
    if (lifecycleState != AppLifecycleState.detached) return;

    _hostExitHandled = true;
    // Best-effort cancellation so connected players are not stranded.
    unawaited(discardSession());
  }

  Future<GameSessionModel?> createSession(String quizId) async {
    if (_isDisposed) return null;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final session = await _sessionRepository.createSession(quizId);
      final quiz = await _quizRepository.getQuizWithQuestions(quizId);

      if (_isDisposed) return session;

      final realtimeError = await _initializeHostRealtime(session.id);

      if (_isDisposed) return session;

      state = state.copyWith(
        isLoading: false,
        error: realtimeError,
        session: session,
        quiz: quiz,
        chatMessages: _buildInitialChatMessages(),
      );
      await _loadChatHistory(session.id);
      return session;
    } catch (e) {
      if (!_isDisposed) {
        state = state.copyWith(isLoading: false, error: e.toString());
      }
      return null;
    }
  }

  /// Get existing active session or create a new one
  /// Returns a fresh new session for the quiz.
  /// Any stale/active previous sessions are first closed as finished.
  Future<GameSessionModel?> getOrCreateSession(String quizId) async {
    if (_isDisposed) return null;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Safety-first host flow: close all stale active sessions, then create fresh.
      await _sessionRepository.closeActiveSessionsForQuiz(quizId);
      final session = await _sessionRepository.createSession(quizId);
      final quiz = await _quizRepository.getQuizWithQuestions(quizId);

      if (_isDisposed) return session;

      final realtimeError = await _initializeHostRealtime(session.id);

      if (_isDisposed) return session;

      state = state.copyWith(
        isLoading: false,
        error: realtimeError,
        session: session,
        quiz: quiz,
        chatMessages: _buildInitialChatMessages(),
      );
      await _loadChatHistory(session.id);
      return session;
    } catch (e) {
      if (!_isDisposed) {
        state = state.copyWith(isLoading: false, error: e.toString());
      }
      return null;
    }
  }

  Future<void> loadSession(String sessionId) async {
    if (_isDisposed) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final session = await _sessionRepository.getSession(sessionId);
      final quiz = await _quizRepository.getQuizWithQuestions(session.quizId);

      // Get the actual player count from the database
      final playerCount = await _playerRepository.getPlayerCount(sessionId);

      if (_isDisposed) return;

      final realtimeError = await _initializeHostRealtime(session.id);

      if (_isDisposed) return;

      state = state.copyWith(
        isLoading: false,
        error: realtimeError,
        session: session,
        quiz: quiz,
        totalPlayers: playerCount,
        chatMessages: _buildInitialChatMessages(),
      );
      await _loadChatHistory(session.id);
    } catch (e) {
      if (!_isDisposed) {
        state = state.copyWith(isLoading: false, error: e.toString());
      }
    }
  }

  void _handleEvent(GameEvent event) {
    if (_isDisposed) return;
    switch (event) {
      case PlayerCountChanged(:final count):
        state = state.copyWith(totalPlayers: count);
        break;
      case ChatMessageReceived(:final payload):
        if (payload.sessionId != state.session?.id) break;
        _appendChatMessage(
          HostChatMessage(
            playerId: payload.playerId,
            nickname: payload.nickname,
            message: payload.message,
            sentAt: payload.sentAt,
          ),
        );
        break;
      default:
        break;
    }
  }

  List<HostChatMessage> _buildInitialChatMessages() {
    return [
      HostChatMessage(
        playerId: 'system',
        nickname: 'System Update',
        message: 'Lobby chat is live for host and players.',
        sentAt: DateTime.now(),
        isSystem: true,
      ),
    ];
  }

  void _appendChatMessage(HostChatMessage newMessage) {
    final exists = state.chatMessages.any(
      (m) =>
          m.playerId == newMessage.playerId &&
          m.sentAt == newMessage.sentAt &&
          m.message == newMessage.message,
    );
    if (exists) return;
    state = state.copyWith(chatMessages: [...state.chatMessages, newMessage]);
  }

  Future<void> _loadChatHistory(String sessionId) async {
    try {
      final history = await _chatRepository.getSessionMessages(sessionId);
      final mapped = history
          .map(
            (m) => HostChatMessage(
              playerId: m.playerId ?? 'host:${m.hostId ?? 'unknown'}',
              nickname: m.nickname,
              message: m.message,
              sentAt: m.createdAt ?? DateTime.now(),
            ),
          )
          .toList();
      mapped.sort((a, b) => a.sentAt.compareTo(b.sentAt));
      final base = state.chatMessages.where((m) => m.isSystem).toList();
      state = state.copyWith(chatMessages: [...base, ...mapped]);
    } catch (e) {
      if (!_isDisposed) {
        state = state.copyWith(error: e.toString());
      }
    }
  }

  Future<void> sendChatMessage({
    required String nickname,
    required String message,
  }) async {
    if (_isDisposed || state.session == null || message.trim().isEmpty) return;

    try {
      final sentAt = DateTime.now().toUtc();
      final saved = await _chatRepository.createMessage(
        sessionId: state.session!.id,
        nickname: nickname,
        message: message.trim(),
        hostId: state.session!.hostId,
      );
      await _realtimeService?.broadcastChatMessage(
        sessionId: state.session!.id,
        playerId:
            saved.playerId ?? 'host:${saved.hostId ?? state.session!.hostId}',
        nickname: saved.nickname,
        message: saved.message,
        sentAtIso: (saved.createdAt ?? sentAt).toUtc().toIso8601String(),
      );
    } catch (e) {
      if (!_isDisposed) {
        state = state.copyWith(error: e.toString());
      }
    }
  }

  Future<void> startGame() async {
    if (_isDisposed ||
        state.session == null ||
        state.quiz == null ||
        _realtimeService == null) return;

    try {
      await _sessionRepository.updateStatus(
        state.session!.id,
        GameStatus.inProgress,
      );

      await _realtimeService!.broadcastGameStart();

      await _showQuestion(0);
    } catch (e) {
      if (!_isDisposed) {
        state = state.copyWith(error: e.toString());
      }
    }
  }

  Future<void> _showQuestion(int index) async {
    if (_isDisposed || _realtimeService == null) return;
    if (state.quiz == null || index >= state.quiz!.questions.length) {
      await _endGame();
      return;
    }

    final question = state.quiz!.questions[index];
    final orderedAnswers = [...question.answers]
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

    final session = await _sessionRepository.updateCurrentQuestion(
      state.session!.id,
      index,
    );

    if (_isDisposed) return;

    await _realtimeService!.broadcastQuestion(
      questionIndex: index,
      questionId: question.id,
      questionText: question.questionText,
      questionType: question.questionType,
      timeLimit: question.timeLimitSeconds,
      answers: orderedAnswers
          .map(
            (a) => {
              'id': a.id,
              'text': a.answerText,
              'order_index': a.orderIndex,
            },
          )
          .toList(),
    );

    if (_isDisposed) return;

    state = state.copyWith(
      session: session,
      answeredCount: 0,
      remainingSeconds: question.timeLimitSeconds,
      answerDistribution: const {},
      isQuestionRevealed: false,
      canGoToNextQuestion: false,
      isPaused: false,
      isShowingRoundLeaderboard: false,
      nextQuestionCountdownSeconds: 0,
      revealedCorrectAnswerIds: const [],
      roundLeaderboard: const [],
    );

    _startTimer(question.timeLimitSeconds);
    _refreshLiveQuestionStats();
  }

  void _startTimer(int seconds) {
    if (_isDisposed) return;
    state.questionTimer?.cancel();

    final timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_isDisposed) {
        t.cancel();
        return;
      }
      final remaining = seconds - t.tick;
      if (remaining <= 0) {
        t.cancel();
        _endQuestion(showResults: true);
      } else {
        state = state.copyWith(remainingSeconds: remaining);
        _refreshLiveQuestionStats();
      }
    });

    state = state.copyWith(questionTimer: timer, remainingSeconds: seconds);
  }

  Future<void> _refreshLiveQuestionStats() async {
    if (_isDisposed || state.session == null || state.quiz == null) return;
    final questionIndex = state.session!.currentQuestionIndex;
    if (questionIndex < 0 || questionIndex >= state.quiz!.questions.length)
      return;

    final question = state.quiz!.questions[questionIndex];
    final answerCount = await _playerRepository.getAnswerCount(
      state.session!.id,
      question.id,
    );
    final distribution = await _playerRepository.getAnswerDistribution(
      state.session!.id,
      question.id,
    );

    if (_isDisposed) return;
    state = state.copyWith(
      answeredCount: answerCount,
      answerDistribution: distribution,
    );
  }

  Future<void> _endQuestion({required bool showResults}) async {
    if (_isDisposed || _realtimeService == null) return;
    state.questionTimer?.cancel();

    await _realtimeService!.broadcastQuestionEnd();

    if (_isDisposed || state.quiz == null || state.session == null) return;

    final question = state.quiz!.questions[state.session!.currentQuestionIndex];
    final correctIds =
        question.answers.where((a) => a.isCorrect).map((a) => a.id).toList();
    if (showResults) {
      final answers = await _playerRepository.getSessionQuestionAnswers(
        state.session!.id,
        question.id,
      );
      final players =
          await _playerRepository.getSessionPlayersAll(state.session!.id);
      final playerById = {for (final p in players) p.id: p};
      final isMultipleChoice =
          question.questionType == QuestionType.multipleChoice;

      for (final answer in answers) {
        final player = playerById[answer.playerId];
        if (player == null) continue;

        final isCorrect = ScoringService.checkAnswer(
          selectedIds: answer.selectedAnswerIds,
          correctIds: correctIds,
          isMultipleChoice: isMultipleChoice,
        );

        final points = ScoringService.calculatePoints(
          basePoints: question.points,
          timeLimitMs: question.timeLimitSeconds * 1000,
          responseTimeMs: answer.responseTimeMs,
          isCorrect: isCorrect,
          currentStreak: player.currentStreak,
        );

        await _playerRepository.updateAnswerEvaluation(
          answerId: answer.id,
          isCorrect: isCorrect,
          pointsEarned: points,
        );

        final newStreak = isCorrect ? player.currentStreak + 1 : 0;
        await _playerRepository.updatePlayerScoreAndStreak(
          playerId: player.id,
          totalScore: player.totalScore + points,
          currentStreak: newStreak,
        );
      }
    }

    final distribution = await _playerRepository.getAnswerDistribution(
      state.session!.id,
      question.id,
    );

    if (_isDisposed) return;

    if (showResults) {
      await _realtimeService!.broadcastResults(
        correctAnswerIds: correctIds,
        distribution: distribution,
      );
    }

    if (showResults) {
      await Future<void>.delayed(
        const Duration(milliseconds: AppConstants.resultsRevealDurationMs),
      );
    }

    final leaderboardEntries = await _sessionRepository.getLeaderboard(
      state.session!.id,
    );
    final leaderboardPayload = leaderboardEntries
        .map(
          (e) => {
            'player_id': e.playerId,
            'nickname': e.nickname,
            'total_score': e.totalScore,
            'correct_answers': e.correctAnswers,
            'current_streak': e.currentStreak,
            'rank': e.rank,
          },
        )
        .toList();
    final roundNumber = state.session!.currentQuestionIndex + 1;
    final totalQuestions = state.quiz!.questions.length;
    await _realtimeService!.broadcastLeaderboard(
      leaderboardPayload,
      roundNumber: roundNumber,
      totalQuestions: totalQuestions,
    );

    final isLastQuestion =
        state.session!.currentQuestionIndex >= state.quiz!.questions.length - 1;
    if (isLastQuestion) {
      await _endGame();
      return;
    }

    if (_isDisposed) return;
    state = state.copyWith(
      remainingSeconds: 0,
      answerDistribution: distribution,
      isQuestionRevealed: showResults,
      canGoToNextQuestion: true,
      isPaused: false,
      isShowingRoundLeaderboard: true,
      nextQuestionCountdownSeconds: 0,
      revealedCorrectAnswerIds: showResults ? correctIds : const [],
      roundLeaderboard: leaderboardPayload,
    );
  }

  Future<void> skipQuestion() async {
    if (_isDisposed ||
        state.session == null ||
        state.session!.status != GameStatus.questionActive) {
      return;
    }
    state.questionTimer?.cancel();
    await _endQuestion(showResults: true);
  }

  Future<void> goToNextQuestion() async {
    if (_isDisposed || state.session == null || !state.canGoToNextQuestion) {
      return;
    }
    state = state.copyWith(nextQuestionCountdownSeconds: 10);
    await _realtimeService?.broadcastNextQuestionCountdown(10);
    for (var seconds = 9; seconds >= 0; seconds--) {
      await Future<void>.delayed(const Duration(seconds: 1));
      if (_isDisposed || state.session == null) return;
      state = state.copyWith(nextQuestionCountdownSeconds: seconds);
    }
    await _showQuestion(state.session!.currentQuestionIndex + 1);
  }

  Future<void> togglePause() async {
    if (_isDisposed || state.session == null) return;
    if (state.session!.status != GameStatus.questionActive) return;
    if (state.canGoToNextQuestion) return;

    if (state.isPaused) {
      _startTimer(state.remainingSeconds);
      state = state.copyWith(isPaused: false);
      await _realtimeService?.broadcastQuizResumed();
      return;
    }

    state.questionTimer?.cancel();
    state = state.copyWith(isPaused: true);
    await _realtimeService?.broadcastQuizPaused();
  }

  Future<void> _endGame() async {
    if (_isDisposed || state.session == null) return;

    await _sessionRepository.updateStatus(
      state.session!.id,
      GameStatus.finished,
    );

    final leaderboard = await _sessionRepository.getLeaderboard(
      state.session!.id,
    );
    final payload = leaderboard
        .map(
          (e) => {
            'player_id': e.playerId,
            'nickname': e.nickname,
            'total_score': e.totalScore,
            'correct_answers': e.correctAnswers,
            'current_streak': e.currentStreak,
            'rank': e.rank,
          },
        )
        .toList();
    final roundNumber = state.session!.currentQuestionIndex + 1;
    final totalQuestions = state.quiz?.questions.length;
    await _realtimeService?.broadcastGameEnd(
      payload,
      roundNumber: roundNumber,
      totalQuestions: totalQuestions,
    );

    if (_isDisposed) return;

    state = state.copyWith(
      session: state.session!.copyWith(status: GameStatus.finished),
      isShowingRoundLeaderboard: false,
      nextQuestionCountdownSeconds: 0,
      roundLeaderboard: payload,
    );
  }

  Future<void> endGame() async {
    state.questionTimer?.cancel();
    await _endGame();
  }

  /// Cancel/discard the current session (mark as finished and clear state)
  Future<void> cancelSession() async {
    if (_isDisposed || state.session == null) return;

    try {
      // Mark session as finished
      await _sessionRepository.updateStatus(
        state.session!.id,
        GameStatus.finished,
      );

      // Clean up realtime connection
      _eventSubscription?.cancel();
      _realtimeService?.dispose();
      _realtimeService = null;
      _eventSubscription = null;

      // Reset state
      state = const HostGameState();
    } catch (e) {
      if (!_isDisposed) {
        state = state.copyWith(error: e.toString());
      }
    }
  }

  /// Discard the current game session and remove all players
  Future<bool> discardSession() async {
    if (_isDisposed || state.session == null) return false;

    try {
      _hostExitHandled = true;
      final sessionId = state.session!.id;

      // Broadcast session cancelled to all players BEFORE cleaning up
      await _realtimeService?.broadcastSessionCancelled();

      // Small delay to ensure broadcast is sent
      await Future.delayed(const Duration(milliseconds: 200));

      // Clean up realtime service
      _eventSubscription?.cancel();
      _realtimeService?.dispose();
      _realtimeService = null;
      _eventSubscription = null;

      // Delete the session and all associated data
      await _sessionRepository.discardSession(sessionId);

      // Reset state
      state = const HostGameState();
      return true;
    } catch (e) {
      if (!_isDisposed) {
        state = state.copyWith(error: e.toString());
      }
      return false;
    }
  }

  void cleanup() {
    _isDisposed = true;
    WidgetsBinding.instance.removeObserver(this);
    state.questionTimer?.cancel();
    _eventSubscription?.cancel();
    _realtimeService?.dispose();
  }

  Future<String?> _initializeHostRealtime(String sessionId) async {
    await _eventSubscription?.cancel();
    await _realtimeService?.dispose();
    _eventSubscription = null;
    _realtimeService = null;

    final realtimeService = RealtimeService(_ref.read(supabaseClientProvider));
    try {
      await realtimeService.hostSession(sessionId);
      _realtimeService = realtimeService;
      _eventSubscription = _realtimeService!.events.listen(_handleEvent);
      return null;
    } catch (e) {
      await realtimeService.dispose();
      return e.toString();
    }
  }

  @override
  void dispose() {
    cleanup();
    super.dispose();
  }
}

// Leaderboard provider
final leaderboardProvider =
    StreamProvider.family<List<LeaderboardEntryModel>, String>((
  ref,
  sessionId,
) async* {
  final repository = ref.watch(gameSessionRepositoryProvider);
  const refreshInterval = Duration(seconds: 1);
  var isActive = true;
  ref.onDispose(() {
    isActive = false;
  });

  var latest = <LeaderboardEntryModel>[];
  while (isActive) {
    try {
      latest = await repository.getLeaderboard(sessionId);
      yield latest;
    } catch (_) {
      yield latest;
    }
    await Future<void>.delayed(refreshInterval);
  }
});
