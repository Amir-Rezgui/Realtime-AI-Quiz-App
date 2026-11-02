import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/supabase_client.dart';
import '../models/player_model.dart';
import '../models/player_answer_model.dart';
import '../../core/constants/supabase_constants.dart';

final playerRepositoryProvider = Provider<PlayerRepository>((ref) {
  return PlayerRepository(ref.watch(supabaseClientProvider));
});

class PlayerRepository {
  final SupabaseClient _client;

  PlayerRepository(this._client);

  Future<PlayerModel> joinSession({
    required String sessionId,
    required String nickname,
    String? avatarSeed,
  }) async {
    final nowIso = DateTime.now().toIso8601String();
    final response = await _client
        .from(SupabaseConstants.playersTable)
        .insert({
          'session_id': sessionId,
          'nickname': nickname.trim(),
          'avatar_seed': avatarSeed ?? nickname.hashCode.toString(),
          'is_connected': true,
          'last_seen_at': nowIso,
        })
        .select()
        .single();

    return PlayerModel.fromJson(response);
  }

  Future<PlayerModel> getPlayer(String playerId) async {
    final response = await _client
        .from(SupabaseConstants.playersTable)
        .select()
        .eq('id', playerId)
        .single();

    return PlayerModel.fromJson(response);
  }

  Future<List<PlayerModel>> getSessionPlayers(String sessionId) async {
    final staleThreshold = DateTime.now()
        .subtract(const Duration(seconds: 6))
        .toIso8601String();
    final response = await _client
        .from(SupabaseConstants.playersTable)
        .select()
        .eq('session_id', sessionId)
        .eq('is_connected', true)
        .gte('last_seen_at', staleThreshold)
        .order('joined_at');

    return (response as List)
        .map((json) => PlayerModel.fromJson(json))
        .toList();
  }

  Future<List<PlayerModel>> getSessionPlayersAll(String sessionId) async {
    final response = await _client
        .from(SupabaseConstants.playersTable)
        .select()
        .eq('session_id', sessionId)
        .order('joined_at');

    return (response as List)
        .map((json) => PlayerModel.fromJson(json))
        .toList();
  }

  Stream<List<PlayerModel>> watchSessionPlayers(String sessionId) {
    return _client
        .from(SupabaseConstants.playersTable)
        .stream(primaryKey: ['id'])
        .eq('session_id', sessionId)
        .map(
          (list) => list
              .where((p) => p['is_connected'] == true)
              .map((json) => PlayerModel.fromJson(json))
              .toList(),
        );
  }

  Future<void> updateConnectionStatus(String playerId, bool isConnected) async {
    await _client.from(SupabaseConstants.playersTable).update({
      'is_connected': isConnected,
      'last_seen_at': DateTime.now().toIso8601String(),
    }).eq('id', playerId);
  }

  Future<bool> isNicknameAvailable(String sessionId, String nickname) async {
    final response = await _client
        .from(SupabaseConstants.playersTable)
        .select('id')
        .eq('session_id', sessionId)
        .ilike('nickname', nickname.trim())
        .maybeSingle();

    return response == null;
  }

  Future<int> getPlayerCount(String sessionId) async {
    final staleThreshold = DateTime.now()
        .subtract(const Duration(seconds: 6))
        .toIso8601String();
    final response = await _client
        .from(SupabaseConstants.playersTable)
        .select('id')
        .eq('session_id', sessionId)
        .eq('is_connected', true)
        .gte('last_seen_at', staleThreshold);

    return (response as List).length;
  }

  // Answers
  Future<PlayerAnswerModel> submitAnswer({
    required String playerId,
    required String questionId,
    required String sessionId,
    required List<String> selectedAnswerIds,
    required bool isCorrect,
    required int responseTimeMs,
    required int pointsEarned,
  }) async {
    final response = await _client
        .from(SupabaseConstants.playerAnswersTable)
        .insert({
          'player_id': playerId,
          'question_id': questionId,
          'session_id': sessionId,
          'selected_answer_ids': selectedAnswerIds,
          'is_correct': isCorrect,
          'response_time_ms': responseTimeMs,
          'points_earned': pointsEarned,
        })
        .select()
        .single();

    return PlayerAnswerModel.fromJson(response);
  }

  Future<List<PlayerAnswerModel>> getSessionQuestionAnswers(
    String sessionId,
    String questionId,
  ) async {
    final response = await _client
        .from(SupabaseConstants.playerAnswersTable)
        .select()
        .eq('session_id', sessionId)
        .eq('question_id', questionId);

    return (response as List)
        .map((json) => PlayerAnswerModel.fromJson(json))
        .toList();
  }

  Future<void> updateAnswerEvaluation({
    required String answerId,
    required bool isCorrect,
    required int pointsEarned,
  }) async {
    await _client.from(SupabaseConstants.playerAnswersTable).update({
      'is_correct': isCorrect,
      'points_earned': pointsEarned,
    }).eq('id', answerId);
  }

  Future<void> updatePlayerScoreAndStreak({
    required String playerId,
    required int totalScore,
    required int currentStreak,
  }) async {
    await _client.from(SupabaseConstants.playersTable).update({
      'total_score': totalScore,
      'current_streak': currentStreak,
    }).eq('id', playerId);
  }

  Future<int> getAnswerCount(String sessionId, String questionId) async {
    final response = await _client
        .from(SupabaseConstants.playerAnswersTable)
        .select('id')
        .eq('session_id', sessionId)
        .eq('question_id', questionId);

    return (response as List).length;
  }

  Stream<int> watchAnswerCount(String sessionId, String questionId) {
    return _client
        .from(SupabaseConstants.playerAnswersTable)
        .stream(primaryKey: ['id'])
        .eq('session_id', sessionId)
        .map(
          (list) => list.where((a) => a['question_id'] == questionId).length,
        );
  }

  Future<Map<String, int>> getAnswerDistribution(
    String sessionId,
    String questionId,
  ) async {
    final response = await _client
        .from(SupabaseConstants.playerAnswersTable)
        .select('selected_answer_ids')
        .eq('session_id', sessionId)
        .eq('question_id', questionId);

    final distribution = <String, int>{};
    for (final answer in response as List) {
      final answerIds = List<String>.from(answer['selected_answer_ids'] ?? []);
      for (final id in answerIds) {
        distribution[id] = (distribution[id] ?? 0) + 1;
      }
    }
    return distribution;
  }
}
