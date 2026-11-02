import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_answer_model.freezed.dart';
part 'player_answer_model.g.dart';

@freezed
class PlayerAnswerModel with _$PlayerAnswerModel {
  const factory PlayerAnswerModel({
    required String id,
    @JsonKey(name: 'player_id') required String playerId,
    @JsonKey(name: 'question_id') required String questionId,
    @JsonKey(name: 'session_id') required String sessionId,
    @JsonKey(name: 'selected_answer_ids')
    required List<String> selectedAnswerIds,
    @JsonKey(name: 'is_correct') required bool isCorrect,
    @JsonKey(name: 'response_time_ms') required int responseTimeMs,
    @JsonKey(name: 'points_earned') @Default(0) int pointsEarned,
    @JsonKey(name: 'answered_at') DateTime? answeredAt,
  }) = _PlayerAnswerModel;

  factory PlayerAnswerModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerAnswerModelFromJson(json);
}

@freezed
class CreatePlayerAnswerModel with _$CreatePlayerAnswerModel {
  const factory CreatePlayerAnswerModel({
    @JsonKey(name: 'player_id') required String playerId,
    @JsonKey(name: 'question_id') required String questionId,
    @JsonKey(name: 'session_id') required String sessionId,
    @JsonKey(name: 'selected_answer_ids')
    required List<String> selectedAnswerIds,
    @JsonKey(name: 'is_correct') required bool isCorrect,
    @JsonKey(name: 'response_time_ms') required int responseTimeMs,
    @JsonKey(name: 'points_earned') required int pointsEarned,
  }) = _CreatePlayerAnswerModel;

  factory CreatePlayerAnswerModel.fromJson(Map<String, dynamic> json) =>
      _$CreatePlayerAnswerModelFromJson(json);
}
