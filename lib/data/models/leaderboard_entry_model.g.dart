// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeaderboardEntryModelImpl _$$LeaderboardEntryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$LeaderboardEntryModelImpl(
      playerId: json['player_id'] as String,
      nickname: json['nickname'] as String,
      avatarSeed: json['avatar_seed'] as String?,
      totalScore: (json['total_score'] as num).toInt(),
      correctAnswers: (json['correct_answers'] as num).toInt(),
      currentStreak: (json['current_streak'] as num).toInt(),
      rank: (json['rank'] as num).toInt(),
    );

Map<String, dynamic> _$$LeaderboardEntryModelImplToJson(
        _$LeaderboardEntryModelImpl instance) =>
    <String, dynamic>{
      'player_id': instance.playerId,
      'nickname': instance.nickname,
      'avatar_seed': instance.avatarSeed,
      'total_score': instance.totalScore,
      'correct_answers': instance.correctAnswers,
      'current_streak': instance.currentStreak,
      'rank': instance.rank,
    };
