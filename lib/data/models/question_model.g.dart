// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestionModelImpl _$$QuestionModelImplFromJson(Map<String, dynamic> json) =>
    _$QuestionModelImpl(
      id: json['id'] as String,
      quizId: json['quiz_id'] as String,
      orderIndex: (json['order_index'] as num).toInt(),
      questionText: json['question_text'] as String,
      questionType: json['question_type'] as String? ?? 'single_choice',
      points: (json['points'] as num?)?.toInt() ?? 1000,
      timeLimitSeconds: (json['time_limit_seconds'] as num?)?.toInt() ?? 20,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$QuestionModelImplToJson(_$QuestionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quiz_id': instance.quizId,
      'order_index': instance.orderIndex,
      'question_text': instance.questionText,
      'question_type': instance.questionType,
      'points': instance.points,
      'time_limit_seconds': instance.timeLimitSeconds,
      'created_at': instance.createdAt?.toIso8601String(),
    };

_$CreateQuestionModelImpl _$$CreateQuestionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateQuestionModelImpl(
      quizId: json['quiz_id'] as String,
      orderIndex: (json['order_index'] as num).toInt(),
      questionText: json['question_text'] as String,
      questionType: json['question_type'] as String? ?? 'single_choice',
      points: (json['points'] as num?)?.toInt() ?? 1000,
      timeLimitSeconds: (json['time_limit_seconds'] as num?)?.toInt() ?? 20,
    );

Map<String, dynamic> _$$CreateQuestionModelImplToJson(
        _$CreateQuestionModelImpl instance) =>
    <String, dynamic>{
      'quiz_id': instance.quizId,
      'order_index': instance.orderIndex,
      'question_text': instance.questionText,
      'question_type': instance.questionType,
      'points': instance.points,
      'time_limit_seconds': instance.timeLimitSeconds,
    };
