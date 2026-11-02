import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/supabase_client.dart';
import '../models/chat_message_model.dart';
import '../../core/constants/supabase_constants.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(ref.watch(supabaseClientProvider));
});

class ChatRepository {
  final SupabaseClient _client;

  ChatRepository(this._client);

  Future<List<ChatMessageModel>> getSessionMessages(String sessionId) async {
    final response = await _client
        .from(SupabaseConstants.chatMessagesTable)
        .select()
        .eq('session_id', sessionId)
        .order('created_at');

    return (response as List)
        .map((json) => ChatMessageModel.fromJson(json))
        .toList();
  }

  Future<ChatMessageModel> createMessage({
    required String sessionId,
    required String nickname,
    required String message,
    String? playerId,
    String? hostId,
  }) async {
    if (playerId == null && hostId == null) {
      throw Exception('Either playerId or hostId is required for chat message');
    }

    final payload = <String, dynamic>{
      'session_id': sessionId,
      'nickname': nickname,
      'message': message,
    };
    if (playerId != null) payload['player_id'] = playerId;
    if (hostId != null) payload['host_id'] = hostId;

    final response = await _client
        .from(SupabaseConstants.chatMessagesTable)
        .insert(payload)
        .select()
        .single();

    return ChatMessageModel.fromJson(response);
  }
}
