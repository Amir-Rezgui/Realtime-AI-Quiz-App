import 'package:freezed_annotation/freezed_annotation.dart';

part 'answer_model.freezed.dart';
part 'answer_model.g.dart';

@freezed
class AnswerModel with _$AnswerModel {
  const factory AnswerModel({
    required String id,
    @JsonKey(name: 'question_id') required String questionId,
    @JsonKey(name: 'order_index') required int orderIndex,
    @JsonKey(name: 'answer_text') required String answerText,
    @JsonKey(name: 'is_correct') @Default(false) bool isCorrect,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _AnswerModel;

  factory AnswerModel.fromJson(Map<String, dynamic> json) =>
      _$AnswerModelFromJson(json);
}

@freezed
class CreateAnswerModel with _$CreateAnswerModel {
  const factory CreateAnswerModel({
    @JsonKey(name: 'question_id') required String questionId,
    @JsonKey(name: 'order_index') required int orderIndex,
    @JsonKey(name: 'answer_text') required String answerText,
    @JsonKey(name: 'is_correct') @Default(false) bool isCorrect,
  }) = _CreateAnswerModel;

  factory CreateAnswerModel.fromJson(Map<String, dynamic> json) =>
      _$CreateAnswerModelFromJson(json);
}
