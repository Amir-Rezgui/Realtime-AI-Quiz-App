class ChatMessageModel {
  final String id;
  final String sessionId;
  final String? playerId;
  final String? hostId;
  final String nickname;
  final String message;
  final DateTime? createdAt;

  const ChatMessageModel({
    required this.id,
    required this.sessionId,
    this.playerId,
    this.hostId,
    required this.nickname,
    required this.message,
    this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      playerId: json['player_id'] as String?,
      hostId: json['host_id'] as String?,
      nickname: json['nickname'] as String,
      message: json['message'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );
  }
}
