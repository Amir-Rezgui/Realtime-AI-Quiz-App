import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/supabase_client.dart';
import '../models/game_session_model.dart';
import '../models/leaderboard_entry_model.dart';
import '../../core/constants/supabase_constants.dart';
import '../../core/constants/app_constants.dart';

final gameSessionRepositoryProvider = Provider<GameSessionRepository>((ref) {
  return GameSessionRepository(ref.watch(supabaseClientProvider));
});

class GameSessionRepository {
  final SupabaseClient _client;

  GameSessionRepository(this._client);

  Future<String> generateJoinCode() async {
    final response = await _client.rpc(
      SupabaseConstants.generateJoinCodeFunction,
    );
    return response as String;
  }

  Future<GameSessionModel> createSession(String quizId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Not authenticated');

    final joinCode = await generateJoinCode();

    final response = await _client
        .from(SupabaseConstants.gameSessionsTable)
        .insert({'quiz_id': quizId, 'host_id': userId, 'join_code': joinCode})
        .select()
        .single();

    return GameSessionModel.fromJson(response);
  }

  Future<GameSessionModel?> findByJoinCode(String joinCode) async {
    final response = await _client
        .from(SupabaseConstants.gameSessionsTable)
        .select()
        .eq('join_code', joinCode.toUpperCase())
        .neq('status', 'finished')
        .maybeSingle();

    if (response == null) return null;
    return GameSessionModel.fromJson(response);
  }

  Future<GameSessionModel> getSession(String sessionId) async {
    final response = await _client
        .from(SupabaseConstants.gameSessionsTable)
        .select()
        .eq('id', sessionId)
        .single();

    return GameSessionModel.fromJson(response);
  }

  Future<GameSessionModel> updateStatus(String sessionId, String status) async {
    final updates = <String, dynamic>{'status': status};
    if (status == 'finished') {
      updates['finished_at'] = DateTime.now().toIso8601String();
    }

    final response = await _client
        .from(SupabaseConstants.gameSessionsTable)
        .update(updates)
        .eq('id', sessionId)
        .select()
        .single();

    return GameSessionModel.fromJson(response);
  }

  Future<GameSessionModel> updateCurrentQuestion(
    String sessionId,
    int questionIndex,
  ) async {
    final response = await _client
        .from(SupabaseConstants.gameSessionsTable)
        .update({
          'current_question_index': questionIndex,
          'question_started_at': DateTime.now().toIso8601String(),
          'status': 'question_active',
        })
        .eq('id', sessionId)
        .select()
        .single();

    return GameSessionModel.fromJson(response);
  }

  Future<List<LeaderboardEntryModel>> getLeaderboard(String sessionId) async {
    final response = await _client.rpc(
      SupabaseConstants.getSessionLeaderboardFunction,
      params: {'p_session_id': sessionId},
    );

    return (response as List)
        .map((json) => LeaderboardEntryModel.fromJson(json))
        .toList();
  }

  Stream<GameSessionModel> watchSession(String sessionId) {
    return _client
        .from(SupabaseConstants.gameSessionsTable)
        .stream(primaryKey: ['id'])
        .eq('id', sessionId)
        .map((list) => GameSessionModel.fromJson(list.first));
  }

  Future<List<GameSessionModel>> getMyRecentSessions() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Not authenticated');

    final response = await _client
        .from(SupabaseConstants.gameSessionsTable)
        .select()
        .eq('host_id', userId)
        .order('created_at', ascending: false)
        .limit(10);

    return (response as List)
        .map((json) => GameSessionModel.fromJson(json))
        .toList();
  }

  Future<List<GameSessionModel>> getMySessions() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Not authenticated');

    final response = await _client
        .from(SupabaseConstants.gameSessionsTable)
        .select()
        .eq('host_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => GameSessionModel.fromJson(json))
        .toList();
  }

  /// Find an active session for a specific quiz (lobby, in_progress, or question_active)
  Future<GameSessionModel?> findActiveSessionForQuiz(String quizId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Not authenticated');

    final response = await _client
        .from(SupabaseConstants.gameSessionsTable)
        .select()
        .eq('quiz_id', quizId)
        .eq('host_id', userId)
        .inFilter('status',
            ['lobby', 'in_progress', 'question_active', 'showing_results'])
        .order('created_at', ascending: false)
        .maybeSingle();

    if (response == null) return null;
    return GameSessionModel.fromJson(response);
  }

  /// Mark all host active sessions for this quiz as finished.
  Future<void> closeActiveSessionsForQuiz(String quizId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Not authenticated');

    await _client
        .from(SupabaseConstants.gameSessionsTable)
        .update({
          'status': GameStatus.finished,
          'finished_at': DateTime.now().toIso8601String(),
        })
        .eq('host_id', userId)
        .eq('quiz_id', quizId)
        .inFilter('status', [
          GameStatus.lobby,
          GameStatus.inProgress,
          GameStatus.questionActive,
          GameStatus.showingResults,
        ]);
  }

  /// Discard a game session and remove all associated players
  Future<void> discardSession(String sessionId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Not authenticated');

    // Delete all players associated with this session
    await _client
        .from(SupabaseConstants.playersTable)
        .delete()
        .eq('session_id', sessionId);

    // Delete all player answers associated with this session
    await _client
        .from(SupabaseConstants.playerAnswersTable)
        .delete()
        .eq('session_id', sessionId);

    // Delete all chat messages associated with this session
    await _client
        .from(SupabaseConstants.chatMessagesTable)
        .delete()
        .eq('session_id', sessionId);

    // Delete the game session
    await _client
        .from(SupabaseConstants.gameSessionsTable)
        .delete()
        .eq('id', sessionId)
        .eq('host_id', userId);
  }
}
