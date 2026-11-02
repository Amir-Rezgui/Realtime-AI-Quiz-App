import 'package:freezed_annotation/freezed_annotation.dart';
import 'question_model.dart';

part 'quiz_model.freezed.dart';
part 'quiz_model.g.dart';

@freezed
class QuizModel with _$QuizModel {
  const factory QuizModel({
    required String id,
    @JsonKey(name: 'creator_id') required String creatorId,
    required String title,
    String? description,
    String? category,
    @JsonKey(name: 'banner_image_url') String? bannerImageUrl,
    @JsonKey(name: 'is_published') @Default(false) bool isPublished,
    @Default({}) Map<String, dynamic> settings,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default([])
    List<QuestionModel> questions,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(0)
    int questionCount,
  }) = _QuizModel;

  factory QuizModel.fromJson(Map<String, dynamic> json) =>
      _$QuizModelFromJson(json);
}

@freezed
class CreateQuizModel with _$CreateQuizModel {
  const factory CreateQuizModel({
    required String title,
    String? description,
    String? category,
    @JsonKey(name: 'banner_image_url') String? bannerImageUrl,
  }) = _CreateQuizModel;

  factory CreateQuizModel.fromJson(Map<String, dynamic> json) =>
      _$CreateQuizModelFromJson(json);
}
