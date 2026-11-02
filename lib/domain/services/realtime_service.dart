import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/supabase_client.dart';
import '../../core/constants/supabase_constants.dart';

final realtimeServiceProvider = Provider<RealtimeService>((ref) {
  return RealtimeService(ref.watch(supabaseClientProvider));
});

class RealtimeService {
  final SupabaseClient _client;
  RealtimeChannel? _sessionChannel;
  final _eventController = StreamController<GameEvent>.broadcast();

  RealtimeService(this._client);

  Stream<GameEvent> get events => _eventController.stream;

  // Host: Create and subscribe to session channel
  Future<void> hostSession(String sessionId) async {
    await _unsubscribe();

    _sessionChannel = _client.channel(
      '${SupabaseConstants.sessionChannelPrefix}$sessionId',
      opts: const RealtimeChannelConfig(self: true),
    );

    _sessionChannel!
        .onPresenceSync((payload) {
          final presences = _sessionChannel!.presenceState();
          final playerCount = presences.length;
          _eventController.add(GameEvent.playerCountChanged(playerCount));
        })
        .onBroadcast(
          event: SupabaseConstants.eventChatMessage,
          callback: (payload) =>
              _eventController.add(GameEvent.chatMessageReceived(
                ChatMessagePayload.fromJson(payload),
              )),
        );

    await _subscribeChannel(_sessionChannel!);
  }

  // Player: Join session channel
  Future<void> joinSession({
    required String sessionId,
    required String playerId,
    required String nickname,
  }) async {
    await _unsubscribe();

    _sessionChannel = _client.channel(
      '${SupabaseConstants.sessionChannelPrefix}$sessionId',
      opts: const RealtimeChannelConfig(self: true),
    );

    _sessionChannel!
        .onBroadcast(
          event: SupabaseConstants.eventGameStart,
          callback: (_) => _eventController.add(const GameEvent.gameStarted()),
        )
        .onBroadcast(
          event: SupabaseConstants.eventQuestionShow,
          callback: (payload) => _eventController.add(
            GameEvent.questionReceived(QuestionPayload.fromJson(payload)),
          ),
        )
        .onBroadcast(
          event: SupabaseConstants.eventQuestionEnd,
          callback: (_) =>
              _eventController.add(const GameEvent.questionEnded()),
        )
        .onBroadcast(
          event: SupabaseConstants.eventResultsShow,
          callback: (payload) => _eventController.add(
            GameEvent.resultsReceived(ResultsPayload.fromJson(payload)),
          ),
        )
        .onBroadcast(
          event: SupabaseConstants.eventLeaderboardShow,
          callback: (payload) => _eventController.add(
            GameEvent.leaderboardReceived(LeaderboardPayload.fromJson(payload)),
          ),
        )
        .onBroadcast(
          event: SupabaseConstants.eventGameEnd,
          callback: (payload) => _eventController.add(
            GameEvent.gameEnded(FinalResultsPayload.fromJson(payload)),
          ),
        )
        .onBroadcast(
          event: SupabaseConstants.eventQuizPause,
          callback: (_) => _eventController.add(const GameEvent.quizPaused()),
        )
        .onBroadcast(
          event: SupabaseConstants.eventQuizResume,
          callback: (_) => _eventController.add(const GameEvent.quizResumed()),
        )
        .onBroadcast(
          event: SupabaseConstants.eventNextQuestionCountdown,
          callback: (payload) => _eventController.add(
            GameEvent.nextQuestionCountdown(
              (payload['seconds'] as num?)?.toInt() ?? 10,
            ),
          ),
        )
        .onBroadcast(
          event: SupabaseConstants.eventSessionCancelled,
          callback: (_) =>
              _eventController.add(const GameEvent.sessionCancelled()),
        )
        .onBroadcast(
          event: SupabaseConstants.eventChatMessage,
          callback: (payload) =>
              _eventController.add(GameEvent.chatMessageReceived(
                ChatMessagePayload.fromJson(payload),
              )),
        );

    await _subscribeChannel(_sessionChannel!);
    await _sessionChannel!.track({'player_id': playerId, 'nickname': nickname});
  }

  // Host: Broadcast events to all players
  Future<void> broadcastGameStart() async {
    await _sessionChannel?.sendBroadcastMessage(
      event: SupabaseConstants.eventGameStart,
      payload: {},
    );
  }

  Future<void> broadcastQuestion({
    required int questionIndex,
    required String questionId,
    required String questionText,
    required String questionType,
    required int timeLimit,
    required List<Map<String, dynamic>> answers,
  }) async {
    await _sessionChannel?.sendBroadcastMessage(
      event: SupabaseConstants.eventQuestionShow,
      payload: {
        'question_index': questionIndex,
        'question_id': questionId,
        'question_text': questionText,
        'question_type': questionType,
        'time_limit': timeLimit,
        'answers': answers,
      },
    );
  }

  Future<void> broadcastQuestionEnd() async {
    await _sessionChannel?.sendBroadcastMessage(
      event: SupabaseConstants.eventQuestionEnd,
      payload: {},
    );
  }

  Future<void> broadcastResults({
    required List<String> correctAnswerIds,
    required Map<String, int> distribution,
  }) async {
    await _sessionChannel?.sendBroadcastMessage(
      event: SupabaseConstants.eventResultsShow,
      payload: {
        'correct_answer_ids': correctAnswerIds,
        'distribution': distribution,
      },
    );
  }

  Future<void> broadcastLeaderboard(
    List<Map<String, dynamic>> entries, {
    int? roundNumber,
    int? totalQuestions,
  }) async {
    final payload = <String, dynamic>{'entries': entries};
    if (roundNumber != null) {
      payload['round_number'] = roundNumber;
    }
    if (totalQuestions != null) {
      payload['total_questions'] = totalQuestions;
    }
    await _sessionChannel?.sendBroadcastMessage(
      event: SupabaseConstants.eventLeaderboardShow,
      payload: payload,
    );
  }

  Future<void> broadcastGameEnd(
    List<Map<String, dynamic>> finalLeaderboard, {
    int? roundNumber,
    int? totalQuestions,
  }) async {
    final payload = <String, dynamic>{'leaderboard': finalLeaderboard};
    if (roundNumber != null) {
      payload['round_number'] = roundNumber;
    }
    if (totalQuestions != null) {
      payload['total_questions'] = totalQuestions;
    }
    await _sessionChannel?.sendBroadcastMessage(
      event: SupabaseConstants.eventGameEnd,
      payload: payload,
    );
  }

  Future<void> broadcastSessionCancelled() async {
    await _sessionChannel?.sendBroadcastMessage(
      event: SupabaseConstants.eventSessionCancelled,
      payload: {},
    );
  }

  Future<void> broadcastQuizPaused() async {
    await _sessionChannel?.sendBroadcastMessage(
      event: SupabaseConstants.eventQuizPause,
      payload: {},
    );
  }

  Future<void> broadcastQuizResumed() async {
    await _sessionChannel?.sendBroadcastMessage(
      event: SupabaseConstants.eventQuizResume,
      payload: {},
    );
  }

  Future<void> broadcastNextQuestionCountdown(int seconds) async {
    await _sessionChannel?.sendBroadcastMessage(
      event: SupabaseConstants.eventNextQuestionCountdown,
      payload: {'seconds': seconds},
    );
  }

  Future<void> broadcastChatMessage({
    required String sessionId,
    required String playerId,
    required String nickname,
    required String message,
    required String sentAtIso,
  }) async {
    await _sessionChannel?.sendBroadcastMessage(
      event: SupabaseConstants.eventChatMessage,
      payload: {
        'session_id': sessionId,
        'player_id': playerId,
        'nickname': nickname,
        'message': message,
        'sent_at': sentAtIso,
      },
    );
  }

  Future<void> _unsubscribe() async {
    await _sessionChannel?.unsubscribe();
    _sessionChannel = null;
  }

  Future<void> _subscribeChannel(RealtimeChannel channel) async {
    final completer = Completer<void>();

    channel.subscribe((status, [error]) {
      if (completer.isCompleted) return;

      switch (status) {
        case RealtimeSubscribeStatus.subscribed:
          completer.complete();
          break;
        case RealtimeSubscribeStatus.timedOut:
          completer.completeError(
            Exception('Realtime subscribe timed out'),
          );
          break;
        case RealtimeSubscribeStatus.channelError:
          completer.completeError(
            Exception('Realtime channel error: ${error ?? 'unknown'}'),
          );
          break;
        case RealtimeSubscribeStatus.closed:
          completer.completeError(
            Exception('Realtime channel closed before subscribe'),
          );
          break;
      }
    });

    await completer.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () => throw Exception('Realtime subscribe did not complete'),
    );
  }

  Future<void> dispose() async {
    await _unsubscribe();
    await _eventController.close();
  }
}

// Event classes
sealed class GameEvent {
  const GameEvent();

  const factory GameEvent.playerCountChanged(int count) = PlayerCountChanged;
  const factory GameEvent.gameStarted() = GameStarted;
  const factory GameEvent.questionReceived(QuestionPayload payload) =
      QuestionReceived;
  const factory GameEvent.questionEnded() = QuestionEnded;
  const factory GameEvent.resultsReceived(ResultsPayload payload) =
      ResultsReceived;
  const factory GameEvent.leaderboardReceived(LeaderboardPayload payload) =
      LeaderboardReceived;
  const factory GameEvent.gameEnded(FinalResultsPayload payload) = GameEnded;
  const factory GameEvent.quizPaused() = QuizPaused;
  const factory GameEvent.quizResumed() = QuizResumed;
  const factory GameEvent.nextQuestionCountdown(int seconds) =
      NextQuestionCountdown;
  const factory GameEvent.sessionCancelled() = SessionCancelled;
  const factory GameEvent.chatMessageReceived(ChatMessagePayload payload) =
      ChatMessageReceived;
}

class PlayerCountChanged extends GameEvent {
  final int count;
  const PlayerCountChanged(this.count);
}

class GameStarted extends GameEvent {
  const GameStarted();
}

class QuestionReceived extends GameEvent {
  final QuestionPayload payload;
  const QuestionReceived(this.payload);
}

class QuestionEnded extends GameEvent {
  const QuestionEnded();
}

class ResultsReceived extends GameEvent {
  final ResultsPayload payload;
  const ResultsReceived(this.payload);
}

class LeaderboardReceived extends GameEvent {
  final LeaderboardPayload payload;
  const LeaderboardReceived(this.payload);
}

class GameEnded extends GameEvent {
  final FinalResultsPayload payload;
  const GameEnded(this.payload);
}

class QuizPaused extends GameEvent {
  const QuizPaused();
}

class QuizResumed extends GameEvent {
  const QuizResumed();
}

class NextQuestionCountdown extends GameEvent {
  final int seconds;
  const NextQuestionCountdown(this.seconds);
}

class SessionCancelled extends GameEvent {
  const SessionCancelled();
}

class ChatMessageReceived extends GameEvent {
  final ChatMessagePayload payload;
  const ChatMessageReceived(this.payload);
}

// Payload classes
class QuestionPayload {
  final int questionIndex;
  final String questionId;
  final String questionText;
  final String questionType;
  final int timeLimit;
  final List<AnswerOption> answers;

  QuestionPayload({
    required this.questionIndex,
    required this.questionId,
    required this.questionText,
    required this.questionType,
    required this.timeLimit,
    required this.answers,
  });

  factory QuestionPayload.fromJson(Map<String, dynamic> json) {
    return QuestionPayload(
      questionIndex: json['question_index'] as int,
      questionId: json['question_id'] as String,
      questionText: json['question_text'] as String,
      questionType: json['question_type'] as String,
      timeLimit: json['time_limit'] as int,
      answers: (json['answers'] as List)
          .map((a) => AnswerOption.fromJson(a))
          .toList(),
    );
  }
}

class AnswerOption {
  final String id;
  final String text;
  final int orderIndex;

  AnswerOption({
    required this.id,
    required this.text,
    required this.orderIndex,
  });

  factory AnswerOption.fromJson(Map<String, dynamic> json) {
    return AnswerOption(
      id: json['id'] as String,
      text: json['text'] as String,
      orderIndex: json['order_index'] as int,
    );
  }
}

class ResultsPayload {
  final List<String> correctAnswerIds;
  final Map<String, int> distribution;

  ResultsPayload({required this.correctAnswerIds, required this.distribution});

  factory ResultsPayload.fromJson(Map<String, dynamic> json) {
    return ResultsPayload(
      correctAnswerIds: List<String>.from(json['correct_answer_ids'] ?? []),
      distribution: Map<String, int>.from(json['distribution'] ?? {}),
    );
  }
}

class LeaderboardPayload {
  final List<Map<String, dynamic>> entries;
  final int? roundNumber;
  final int? totalQuestions;

  LeaderboardPayload({
    required this.entries,
    this.roundNumber,
    this.totalQuestions,
  });

  factory LeaderboardPayload.fromJson(Map<String, dynamic> json) {
    return LeaderboardPayload(
      entries: List<Map<String, dynamic>>.from(json['entries'] ?? []),
      roundNumber: (json['round_number'] as num?)?.toInt(),
      totalQuestions: (json['total_questions'] as num?)?.toInt(),
    );
  }
}

class FinalResultsPayload {
  final List<Map<String, dynamic>> leaderboard;
  final int? roundNumber;
  final int? totalQuestions;

  FinalResultsPayload({
    required this.leaderboard,
    this.roundNumber,
    this.totalQuestions,
  });

  factory FinalResultsPayload.fromJson(Map<String, dynamic> json) {
    return FinalResultsPayload(
      leaderboard: List<Map<String, dynamic>>.from(json['leaderboard'] ?? []),
      roundNumber: (json['round_number'] as num?)?.toInt(),
      totalQuestions: (json['total_questions'] as num?)?.toInt(),
    );
  }
}

class ChatMessagePayload {
  final String sessionId;
  final String playerId;
  final String nickname;
  final String message;
  final DateTime sentAt;

  ChatMessagePayload({
    required this.sessionId,
    required this.playerId,
    required this.nickname,
    required this.message,
    required this.sentAt,
  });

  factory ChatMessagePayload.fromJson(Map<String, dynamic> json) {
    return ChatMessagePayload(
      sessionId: json['session_id'] as String,
      playerId: json['player_id'] as String,
      nickname: json['nickname'] as String,
      message: json['message'] as String,
      sentAt: DateTime.parse(json['sent_at'] as String),
    );
  }
}
