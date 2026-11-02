// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnswerModelImpl _$$AnswerModelImplFromJson(Map<String, dynamic> json) =>
    _$AnswerModelImpl(
      id: json['id'] as String,
      questionId: json['question_id'] as String,
      orderIndex: (json['order_index'] as num).toInt(),
      answerText: json['answer_text'] as String,
      isCorrect: json['is_correct'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$AnswerModelImplToJson(_$AnswerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question_id': instance.questionId,
      'order_index': instance.orderIndex,
      'answer_text': instance.answerText,
      'is_correct': instance.isCorrect,
      'created_at': instance.createdAt?.toIso8601String(),
    };

_$CreateAnswerModelImpl _$$CreateAnswerModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateAnswerModelImpl(
      questionId: json['question_id'] as String,
      orderIndex: (json['order_index'] as num).toInt(),
      answerText: json['answer_text'] as String,
      isCorrect: json['is_correct'] as bool? ?? false,
    );

Map<String, dynamic> _$$CreateAnswerModelImplToJson(
        _$CreateAnswerModelImpl instance) =>
    <String, dynamic>{
      'question_id': instance.questionId,
      'order_index': instance.orderIndex,
      'answer_text': instance.answerText,
      'is_correct': instance.isCorrect,
    };
