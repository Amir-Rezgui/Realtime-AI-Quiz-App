import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_model.freezed.dart';
part 'player_model.g.dart';

@freezed
class PlayerModel with _$PlayerModel {
  const factory PlayerModel({
    required String id,
    @JsonKey(name: 'session_id') required String sessionId,
    required String nickname,
    @JsonKey(name: 'avatar_seed') String? avatarSeed,
    @JsonKey(name: 'total_score') @Default(0) int totalScore,
    @JsonKey(name: 'current_streak') @Default(0) int currentStreak,
    @JsonKey(name: 'is_connected') @Default(true) bool isConnected,
    @JsonKey(name: 'joined_at') DateTime? joinedAt,
    @JsonKey(name: 'last_seen_at') DateTime? lastSeenAt,
  }) = _PlayerModel;

  factory PlayerModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerModelFromJson(json);
}

@freezed
class CreatePlayerModel with _$CreatePlayerModel {
  const factory CreatePlayerModel({
    @JsonKey(name: 'session_id') required String sessionId,
    required String nickname,
    @JsonKey(name: 'avatar_seed') String? avatarSeed,
  }) = _CreatePlayerModel;

  factory CreatePlayerModel.fromJson(Map<String, dynamic> json) =>
      _$CreatePlayerModelFromJson(json);
}
