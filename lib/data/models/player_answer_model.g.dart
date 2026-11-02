// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_answer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerAnswerModelImpl _$$PlayerAnswerModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PlayerAnswerModelImpl(
      id: json['id'] as String,
      playerId: json['player_id'] as String,
      questionId: json['question_id'] as String,
      sessionId: json['session_id'] as String,
      selectedAnswerIds: (json['selected_answer_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isCorrect: json['is_correct'] as bool,
      responseTimeMs: (json['response_time_ms'] as num).toInt(),
      pointsEarned: (json['points_earned'] as num?)?.toInt() ?? 0,
      answeredAt: json['answered_at'] == null
          ? null
          : DateTime.parse(json['answered_at'] as String),
    );

Map<String, dynamic> _$$PlayerAnswerModelImplToJson(
        _$PlayerAnswerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'player_id': instance.playerId,
      'question_id': instance.questionId,
      'session_id': instance.sessionId,
      'selected_answer_ids': instance.selectedAnswerIds,
      'is_correct': instance.isCorrect,
      'response_time_ms': instance.responseTimeMs,
      'points_earned': instance.pointsEarned,
      'answered_at': instance.answeredAt?.toIso8601String(),
    };

_$CreatePlayerAnswerModelImpl _$$CreatePlayerAnswerModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CreatePlayerAnswerModelImpl(
      playerId: json['player_id'] as String,
      questionId: json['question_id'] as String,
      sessionId: json['session_id'] as String,
      selectedAnswerIds: (json['selected_answer_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isCorrect: json['is_correct'] as bool,
      responseTimeMs: (json['response_time_ms'] as num).toInt(),
      pointsEarned: (json['points_earned'] as num).toInt(),
    );

Map<String, dynamic> _$$CreatePlayerAnswerModelImplToJson(
        _$CreatePlayerAnswerModelImpl instance) =>
    <String, dynamic>{
      'player_id': instance.playerId,
      'question_id': instance.questionId,
      'session_id': instance.sessionId,
      'selected_answer_ids': instance.selectedAnswerIds,
      'is_correct': instance.isCorrect,
      'response_time_ms': instance.responseTimeMs,
      'points_earned': instance.pointsEarned,
    };
