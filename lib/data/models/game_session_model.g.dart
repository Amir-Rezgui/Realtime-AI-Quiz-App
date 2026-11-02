// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameSessionModelImpl _$$GameSessionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$GameSessionModelImpl(
      id: json['id'] as String,
      quizId: json['quiz_id'] as String,
      hostId: json['host_id'] as String,
      joinCode: json['join_code'] as String,
      status: json['status'] as String? ?? 'lobby',
      currentQuestionIndex:
          (json['current_question_index'] as num?)?.toInt() ?? 0,
      questionStartedAt: json['question_started_at'] == null
          ? null
          : DateTime.parse(json['question_started_at'] as String),
      playerCount: (json['player_count'] as num?)?.toInt() ?? 0,
      settings: json['settings'] as Map<String, dynamic>? ?? const {},
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      finishedAt: json['finished_at'] == null
          ? null
          : DateTime.parse(json['finished_at'] as String),
    );

Map<String, dynamic> _$$GameSessionModelImplToJson(
        _$GameSessionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quiz_id': instance.quizId,
      'host_id': instance.hostId,
      'join_code': instance.joinCode,
      'status': instance.status,
      'current_question_index': instance.currentQuestionIndex,
      'question_started_at': instance.questionStartedAt?.toIso8601String(),
      'player_count': instance.playerCount,
      'settings': instance.settings,
      'created_at': instance.createdAt?.toIso8601String(),
      'finished_at': instance.finishedAt?.toIso8601String(),
    };

_$CreateGameSessionModelImpl _$$CreateGameSessionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateGameSessionModelImpl(
      quizId: json['quiz_id'] as String,
      hostId: json['host_id'] as String,
      joinCode: json['join_code'] as String,
    );

Map<String, dynamic> _$$CreateGameSessionModelImplToJson(
        _$CreateGameSessionModelImpl instance) =>
    <String, dynamic>{
      'quiz_id': instance.quizId,
      'host_id': instance.hostId,
      'join_code': instance.joinCode,
    };
