// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerModelImpl _$$PlayerModelImplFromJson(Map<String, dynamic> json) =>
    _$PlayerModelImpl(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      nickname: json['nickname'] as String,
      avatarSeed: json['avatar_seed'] as String?,
      totalScore: (json['total_score'] as num?)?.toInt() ?? 0,
      currentStreak: (json['current_streak'] as num?)?.toInt() ?? 0,
      isConnected: json['is_connected'] as bool? ?? true,
      joinedAt: json['joined_at'] == null
          ? null
          : DateTime.parse(json['joined_at'] as String),
      lastSeenAt: json['last_seen_at'] == null
          ? null
          : DateTime.parse(json['last_seen_at'] as String),
    );

Map<String, dynamic> _$$PlayerModelImplToJson(_$PlayerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'session_id': instance.sessionId,
      'nickname': instance.nickname,
      'avatar_seed': instance.avatarSeed,
      'total_score': instance.totalScore,
      'current_streak': instance.currentStreak,
      'is_connected': instance.isConnected,
      'joined_at': instance.joinedAt?.toIso8601String(),
      'last_seen_at': instance.lastSeenAt?.toIso8601String(),
    };

_$CreatePlayerModelImpl _$$CreatePlayerModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CreatePlayerModelImpl(
      sessionId: json['session_id'] as String,
      nickname: json['nickname'] as String,
      avatarSeed: json['avatar_seed'] as String?,
    );

Map<String, dynamic> _$$CreatePlayerModelImplToJson(
        _$CreatePlayerModelImpl instance) =>
    <String, dynamic>{
      'session_id': instance.sessionId,
      'nickname': instance.nickname,
      'avatar_seed': instance.avatarSeed,
    };
