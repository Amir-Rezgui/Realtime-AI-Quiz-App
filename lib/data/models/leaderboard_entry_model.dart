import 'package:freezed_annotation/freezed_annotation.dart';

part 'leaderboard_entry_model.freezed.dart';
part 'leaderboard_entry_model.g.dart';

@freezed
class LeaderboardEntryModel with _$LeaderboardEntryModel {
  const factory LeaderboardEntryModel({
    @JsonKey(name: 'player_id') required String playerId,
    required String nickname,
    @JsonKey(name: 'avatar_seed') String? avatarSeed,
    @JsonKey(name: 'total_score') required int totalScore,
    @JsonKey(name: 'correct_answers') required int correctAnswers,
    @JsonKey(name: 'current_streak') required int currentStreak,
    required int rank,
  }) = _LeaderboardEntryModel;

  factory LeaderboardEntryModel.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardEntryModelFromJson(json);
}
