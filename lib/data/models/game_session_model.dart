import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_session_model.freezed.dart';
part 'game_session_model.g.dart';

@freezed
class GameSessionModel with _$GameSessionModel {
  const factory GameSessionModel({
    required String id,
    @JsonKey(name: 'quiz_id') required String quizId,
    @JsonKey(name: 'host_id') required String hostId,
    @JsonKey(name: 'join_code') required String joinCode,
    @Default('lobby') String status,
    @JsonKey(name: 'current_question_index')
    @Default(0)
    int currentQuestionIndex,
    @JsonKey(name: 'question_started_at') DateTime? questionStartedAt,
    @JsonKey(name: 'player_count') @Default(0) int playerCount,
    @Default({}) Map<String, dynamic> settings,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'finished_at') DateTime? finishedAt,
  }) = _GameSessionModel;

  factory GameSessionModel.fromJson(Map<String, dynamic> json) =>
      _$GameSessionModelFromJson(json);
}

@freezed
class CreateGameSessionModel with _$CreateGameSessionModel {
  const factory CreateGameSessionModel({
    @JsonKey(name: 'quiz_id') required String quizId,
    @JsonKey(name: 'host_id') required String hostId,
    @JsonKey(name: 'join_code') required String joinCode,
  }) = _CreateGameSessionModel;

  factory CreateGameSessionModel.fromJson(Map<String, dynamic> json) =>
      _$CreateGameSessionModelFromJson(json);
}
