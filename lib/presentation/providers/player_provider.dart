import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/game_session_repository.dart';
import '../../data/repositories/player_repository.dart';
import '../../data/repositories/chat_repository.dart';
import '../../data/models/game_session_model.dart';
import '../../data/models/player_model.dart';
import '../../domain/services/realtime_service.dart';
import '../../domain/services/scoring_service.dart';
import '../../core/constants/app_constants.dart';

class PlayerChatMessage {
  final String playerId;
  final String nickname;
  final String message;
  final DateTime sentAt;
  final bool isSystem;

  const PlayerChatMessage({
    required this.playerId,
    required this.nickname,
    required this.message,
    required this.sentAt,
    this.isSystem = false,
  });
}

// Player game notifier
final playerGameProvider =
    StateNotifierProvider.autoDispose<PlayerGameNotifier, PlayerGameState>((
  ref,
) {
  return PlayerGameNotifier(
    ref.watch(gameSessionRepositoryProvider),
    ref.watch(playerRepositoryProvider),
    ref.watch(chatRepositoryProvider),
    ref.watch(realtimeServiceProvider),
  );
});

class PlayerGameState {
  final bool isLoading;
  final String? error;
  final GameSessionModel? session;
  final PlayerModel? player;
  final GamePhase phase;
  final QuestionPayload? currentQuestion;
  final List<String> selectedAnswerIds;
  final bool hasAnswered;
  final DateTime? questionStartTime;
  final ResultsPayload? results;
  final LeaderboardPayload? leaderboard;
  final int? pointsEarned;
  final int remainingSeconds;
  final bool isPaused;
  final int totalPlayers;
  final int answeredPlayers;
  final int nextQuestionCountdownSeconds;
  final List<PlayerChatMessage> chatMessages;

  const PlayerGameState({
    this.isLoading = false,
    this.error,
    this.session,
    this.player,
    this.phase = GamePhase.joining,
    this.currentQuestion,
    this.selectedAnswerIds = const [],
    this.hasAnswered = false,
    this.questionStartTime,
    this.results,
    this.leaderboard,
    this.pointsEarned,
    this.remainingSeconds = 0,
    this.isPaused = false,
    this.totalPlayers = 0,
    this.answeredPlayers = 0,
    this.nextQuestionCountdownSeconds = 0,
    this.chatMessages = const [],
  });

  PlayerGameState copyWith({
    bool? isLoading,
    String? error,
    GameSessionModel? session,
    PlayerModel? player,
    GamePhase? phase,
    QuestionPayload? currentQuestion,
    List<String>? selectedAnswerIds,
    bool? hasAnswered,
    DateTime? questionStartTime,
    ResultsPayload? results,
    LeaderboardPayload? leaderboard,
    int? pointsEarned,
    int? remainingSeconds,
    bool? isPaused,
    int? totalPlayers,
    int? answeredPlayers,
    int? nextQuestionCountdownSeconds,
    List<PlayerChatMessage>? chatMessages,
  }) {
    return PlayerGameState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      session: session ?? this.session,
      player: player ?? this.player,
      phase: phase ?? this.phase,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      selectedAnswerIds: selectedAnswerIds ?? this.selectedAnswerIds,
      hasAnswered: hasAnswered ?? this.hasAnswered,
      questionStartTime: questionStartTime ?? this.questionStartTime,
      results: results ?? this.results,
      leaderboard: leaderboard ?? this.leaderboard,
      pointsEarned: pointsEarned ?? this.pointsEarned,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isPaused: isPaused ?? this.isPaused,
      totalPlayers: totalPlayers ?? this.totalPlayers,
      answeredPlayers: answeredPlayers ?? this.answeredPlayers,
      nextQuestionCountdownSeconds:
          nextQuestionCountdownSeconds ?? this.nextQuestionCountdownSeconds,
      chatMessages: chatMessages ?? this.chatMessages,
    );
  }
}

enum GamePhase {
  joining,
  lobby,
  question,
  waiting,
  results,
  leaderboard,
  finished,
  cancelled,
}

class PlayerGameNotifier extends StateNotifier<PlayerGameState> {
  final GameSessionRepository _sessionRepository;
  final PlayerRepository _playerRepository;
  final ChatRepository _chatRepository;
  final RealtimeService _realtimeService;
  StreamSubscription? _eventSubscription;
  Timer? _countdownTimer;
  Timer? _presenceHeartbeatTimer;

  PlayerGameNotifier(
    this._sessionRepository,
    this._playerRepository,
    this._chatRepository,
    this._realtimeService,
  ) : super(const PlayerGameState());

  Future<bool> joinByCode(String joinCode) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final session = await _sessionRepository.findByJoinCode(joinCode);
      if (session == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'Invalid code or game has ended',
        );
        return false;
      }

      if (session.status != GameStatus.lobby) {
        state = state.copyWith(
          isLoading: false,
          error: 'Game has already started',
        );
        return false;
      }

      state = state.copyWith(isLoading: false, session: session);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> setNickname(String nickname) async {
    if (state.session == null) return false;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final available = await _playerRepository.isNicknameAvailable(
        state.session!.id,
        nickname,
      );

      if (!available) {
        state = state.copyWith(
          isLoading: false,
          error: 'Nickname already taken',
        );
        return false;
      }

      final player = await _playerRepository.joinSession(
        sessionId: state.session!.id,
        nickname: nickname,
      );

      await _realtimeService.joinSession(
        sessionId: state.session!.id,
        playerId: player.id,
        nickname: nickname,
      );

      _eventSubscription = _realtimeService.events.listen(_handleEvent);

      state = state.copyWith(
        isLoading: false,
        player: player,
        phase: GamePhase.lobby,
        chatMessages: _buildInitialChatMessages(state.session?.id),
      );
      _startPresenceHeartbeat();
      await _loadChatHistory();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> loadExistingSession(String sessionId, String playerId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final session = await _sessionRepository.getSession(sessionId);
      final player = await _playerRepository.getPlayer(playerId);

      await _realtimeService.joinSession(
        sessionId: sessionId,
        playerId: playerId,
        nickname: player.nickname,
      );

      _eventSubscription = _realtimeService.events.listen(_handleEvent);

      final phase = _getPhaseFromStatus(session.status);

      state = state.copyWith(
        isLoading: false,
        session: session,
        player: player,
        phase: phase,
        chatMessages: _buildInitialChatMessages(session.id),
      );
      _startPresenceHeartbeat();
      await _loadChatHistory();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  GamePhase _getPhaseFromStatus(String status) {
    switch (status) {
      case GameStatus.lobby:
        return GamePhase.lobby;
      case GameStatus.questionActive:
        return GamePhase.question;
      case GameStatus.showingResults:
        return GamePhase.results;
      case GameStatus.finished:
        return GamePhase.finished;
      default:
        return GamePhase.lobby;
    }
  }

  void _handleEvent(GameEvent event) {
    switch (event) {
      case GameStarted():
        state = state.copyWith(phase: GamePhase.question);
        break;

      case QuestionReceived(:final payload):
        _countdownTimer?.cancel();
        state = state.copyWith(
          phase: GamePhase.question,
          currentQuestion: payload,
          selectedAnswerIds: [],
          hasAnswered: false,
          results: null,
          questionStartTime: DateTime.now(),
          remainingSeconds: payload.timeLimit,
          isPaused: false,
          answeredPlayers: 0,
          nextQuestionCountdownSeconds: 0,
          pointsEarned: null,
        );
        _refreshParticipationProgress();
        _startCountdown(payload.timeLimit);
        break;

      case QuestionEnded():
        _countdownTimer?.cancel();
        _refreshParticipationProgress();
        state = state.copyWith(remainingSeconds: 0, isPaused: false);
        break;

      case ResultsReceived(:final payload):
        _countdownTimer?.cancel();
        final isMultipleChoice =
            state.currentQuestion?.questionType == QuestionType.multipleChoice;
        final isCorrect = ScoringService.checkAnswer(
          selectedIds: state.selectedAnswerIds,
          correctIds: payload.correctAnswerIds,
          isMultipleChoice: isMultipleChoice,
        );
        state = state.copyWith(
          phase: GamePhase.results,
          results: payload,
          pointsEarned: isCorrect ? state.pointsEarned : 0,
        );
        break;

      case LeaderboardReceived(:final payload):
        state = state.copyWith(
          phase: GamePhase.leaderboard,
          nextQuestionCountdownSeconds: 0,
          leaderboard: payload,
        );
        break;

      case GameEnded(:final payload):
        state = state.copyWith(
          phase: GamePhase.leaderboard,
          isPaused: false,
          leaderboard: LeaderboardPayload(
            entries: payload.leaderboard,
            roundNumber: payload.roundNumber,
            totalQuestions: payload.totalQuestions,
          ),
        );
        break;

      case QuizPaused():
        _countdownTimer?.cancel();
        state = state.copyWith(isPaused: true);
        break;

      case QuizResumed():
        if (state.phase == GamePhase.question && state.remainingSeconds > 0) {
          _startCountdown(state.remainingSeconds);
        }
        state = state.copyWith(isPaused: false);
        break;

      case NextQuestionCountdown(:final seconds):
        state = state.copyWith(nextQuestionCountdownSeconds: seconds);
        _startNextQuestionCountdown(seconds);
        break;

      case PlayerCountChanged():
        _refreshParticipationProgress();
        break;

      case SessionCancelled():
        _countdownTimer?.cancel();
        state = state.copyWith(phase: GamePhase.cancelled);
        break;

      case ChatMessageReceived(:final payload):
        if (payload.sessionId != state.session?.id) {
          break;
        }
        _appendChatMessage(
          PlayerChatMessage(
            playerId: payload.playerId,
            nickname: payload.nickname,
            message: payload.message,
            sentAt: payload.sentAt,
          ),
        );
        break;
    }
  }

  List<PlayerChatMessage> _buildInitialChatMessages(String? sessionId) {
    if (sessionId == null) return const [];
    return [
      PlayerChatMessage(
        playerId: 'system',
        nickname: 'System Update',
        message: 'Welcome! Lobby chat is live. Stay respectful and have fun.',
        sentAt: DateTime.now(),
        isSystem: true,
      ),
    ];
  }

  void _appendChatMessage(PlayerChatMessage newMessage) {
    final alreadyExists = state.chatMessages.any(
      (m) =>
          m.playerId == newMessage.playerId &&
          m.sentAt == newMessage.sentAt &&
          m.message == newMessage.message,
    );
    if (alreadyExists) return;
    state = state.copyWith(chatMessages: [...state.chatMessages, newMessage]);
  }

  Future<void> _loadChatHistory() async {
    if (state.session == null) return;
    try {
      final history =
          await _chatRepository.getSessionMessages(state.session!.id);
      final mapped = history
          .map(
            (m) => PlayerChatMessage(
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
      state = state.copyWith(error: e.toString());
    }
  }

  void _startCountdown(int seconds) {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = seconds - timer.tick;
      if (remaining <= 0) {
        timer.cancel();
        state = state.copyWith(remainingSeconds: 0);
      } else {
        state = state.copyWith(remainingSeconds: remaining);
        _refreshParticipationProgress();
      }
    });
  }

  Future<void> _refreshParticipationProgress() async {
    if (state.session == null || state.currentQuestion == null) return;
    try {
      final sessionId = state.session!.id;
      final questionId = state.currentQuestion!.questionId;
      final totalPlayers = await _playerRepository.getPlayerCount(sessionId);
      final answeredPlayers = await _playerRepository.getAnswerCount(
        sessionId,
        questionId,
      );
      state = state.copyWith(
        totalPlayers: totalPlayers,
        answeredPlayers: answeredPlayers,
      );
    } catch (_) {}
  }

  void _startNextQuestionCountdown(int seconds) {
    _countdownTimer?.cancel();
    state = state.copyWith(nextQuestionCountdownSeconds: seconds);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = seconds - timer.tick;
      if (remaining <= 0) {
        timer.cancel();
        state = state.copyWith(nextQuestionCountdownSeconds: 0);
      } else {
        state = state.copyWith(nextQuestionCountdownSeconds: remaining);
      }
    });
  }

  Future<void> selectAnswer(String answerId) async {
    final canAnswerNow = !state.isPaused && state.remainingSeconds > 0;
    if (state.hasAnswered ||
        state.currentQuestion == null ||
        state.player == null ||
        !canAnswerNow) {
      return;
    }

    // Single-choice only: tapping an option selects it as the only answer.
    state = state.copyWith(selectedAnswerIds: [answerId]);
  }

  Future<void> confirmAnswer() async {
    final canAnswerNow = !state.isPaused && state.remainingSeconds > 0;
    if (state.selectedAnswerIds.isEmpty || !canAnswerNow) return;
    await _submitAnswer(state.selectedAnswerIds);
  }

  Future<void> _submitAnswer(List<String> answerIds) async {
    final canAnswerNow = !state.isPaused && state.remainingSeconds > 0;
    if (state.hasAnswered ||
        state.currentQuestion == null ||
        state.player == null ||
        state.questionStartTime == null ||
        !canAnswerNow) {
      return;
    }

    final responseTimeMs =
        DateTime.now().difference(state.questionStartTime!).inMilliseconds;

    // We don't know correct answers yet, will be calculated server-side
    // For now, assume we need to wait for results
    state = state.copyWith(
      hasAnswered: true,
      selectedAnswerIds: answerIds,
    );

    try {
      await _playerRepository.submitAnswer(
        playerId: state.player!.id,
        questionId: state.currentQuestion!.questionId,
        sessionId: state.session!.id,
        selectedAnswerIds: answerIds,
        isCorrect: false,
        responseTimeMs: responseTimeMs,
        pointsEarned: 0,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> sendChatMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.session == null || state.player == null) {
      return;
    }

    try {
      final sentAt = DateTime.now().toUtc();
      final saved = await _chatRepository.createMessage(
        sessionId: state.session!.id,
        nickname: state.player!.nickname,
        message: trimmed,
        playerId: state.player!.id,
      );
      await _realtimeService.broadcastChatMessage(
        sessionId: state.session!.id,
        playerId: saved.playerId ?? state.player!.id,
        nickname: saved.nickname,
        message: saved.message,
        sentAtIso: (saved.createdAt ?? sentAt).toUtc().toIso8601String(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void _startPresenceHeartbeat() {
    _presenceHeartbeatTimer?.cancel();
    _presenceHeartbeatTimer =
        Timer.periodic(const Duration(seconds: 1), (_) async {
      final playerId = state.player?.id;
      if (playerId == null || playerId.isEmpty) return;
      await _playerRepository.updateConnectionStatus(playerId, true);
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _presenceHeartbeatTimer?.cancel();
    _eventSubscription?.cancel();
    final playerId = state.player?.id;
    if (playerId != null && playerId.isNotEmpty) {
      _playerRepository.updateConnectionStatus(playerId, false);
    }
    _realtimeService.dispose();
    super.dispose();
  }
}
