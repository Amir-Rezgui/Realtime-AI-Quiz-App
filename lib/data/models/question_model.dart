import 'package:freezed_annotation/freezed_annotation.dart';
import 'answer_model.dart';

part 'question_model.freezed.dart';
part 'question_model.g.dart';

@freezed
class QuestionModel with _$QuestionModel {
  const factory QuestionModel({
    required String id,
    @JsonKey(name: 'quiz_id') required String quizId,
    @JsonKey(name: 'order_index') required int orderIndex,
    @JsonKey(name: 'question_text') required String questionText,
    @JsonKey(name: 'question_type')
    @Default('single_choice')
    String questionType,
    @Default(1000) int points,
    @JsonKey(name: 'time_limit_seconds') @Default(20) int timeLimitSeconds,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default([])
    List<AnswerModel> answers,
  }) = _QuestionModel;

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);
}

@freezed
class CreateQuestionModel with _$CreateQuestionModel {
  const factory CreateQuestionModel({
    @JsonKey(name: 'quiz_id') required String quizId,
    @JsonKey(name: 'order_index') required int orderIndex,
    @JsonKey(name: 'question_text') required String questionText,
    @JsonKey(name: 'question_type')
    @Default('single_choice')
    String questionType,
    @Default(1000) int points,
    @JsonKey(name: 'time_limit_seconds') @Default(20) int timeLimitSeconds,
  }) = _CreateQuestionModel;

  factory CreateQuestionModel.fromJson(Map<String, dynamic> json) =>
      _$CreateQuestionModelFromJson(json);
}
