// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leaderboard_entry_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LeaderboardEntryModel _$LeaderboardEntryModelFromJson(
    Map<String, dynamic> json) {
  return _LeaderboardEntryModel.fromJson(json);
}

/// @nodoc
mixin _$LeaderboardEntryModel {
  @JsonKey(name: 'player_id')
  String get playerId => throw _privateConstructorUsedError;
  String get nickname => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_seed')
  String? get avatarSeed => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_score')
  int get totalScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'correct_answers')
  int get correctAnswers => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_streak')
  int get currentStreak => throw _privateConstructorUsedError;
  int get rank => throw _privateConstructorUsedError;

  /// Serializes this LeaderboardEntryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LeaderboardEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LeaderboardEntryModelCopyWith<LeaderboardEntryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeaderboardEntryModelCopyWith<$Res> {
  factory $LeaderboardEntryModelCopyWith(LeaderboardEntryModel value,
          $Res Function(LeaderboardEntryModel) then) =
      _$LeaderboardEntryModelCopyWithImpl<$Res, LeaderboardEntryModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'player_id') String playerId,
      String nickname,
      @JsonKey(name: 'avatar_seed') String? avatarSeed,
      @JsonKey(name: 'total_score') int totalScore,
      @JsonKey(name: 'correct_answers') int correctAnswers,
      @JsonKey(name: 'current_streak') int currentStreak,
      int rank});
}

/// @nodoc
class _$LeaderboardEntryModelCopyWithImpl<$Res,
        $Val extends LeaderboardEntryModel>
    implements $LeaderboardEntryModelCopyWith<$Res> {
  _$LeaderboardEntryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LeaderboardEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? nickname = null,
    Object? avatarSeed = freezed,
    Object? totalScore = null,
    Object? correctAnswers = null,
    Object? currentStreak = null,
    Object? rank = null,
  }) {
    return _then(_value.copyWith(
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      avatarSeed: freezed == avatarSeed
          ? _value.avatarSeed
          : avatarSeed // ignore: cast_nullable_to_non_nullable
              as String?,
      totalScore: null == totalScore
          ? _value.totalScore
          : totalScore // ignore: cast_nullable_to_non_nullable
              as int,
      correctAnswers: null == correctAnswers
          ? _value.correctAnswers
          : correctAnswers // ignore: cast_nullable_to_non_nullable
              as int,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LeaderboardEntryModelImplCopyWith<$Res>
    implements $LeaderboardEntryModelCopyWith<$Res> {
  factory _$$LeaderboardEntryModelImplCopyWith(
          _$LeaderboardEntryModelImpl value,
          $Res Function(_$LeaderboardEntryModelImpl) then) =
      __$$LeaderboardEntryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'player_id') String playerId,
      String nickname,
      @JsonKey(name: 'avatar_seed') String? avatarSeed,
      @JsonKey(name: 'total_score') int totalScore,
      @JsonKey(name: 'correct_answers') int correctAnswers,
      @JsonKey(name: 'current_streak') int currentStreak,
      int rank});
}

/// @nodoc
class __$$LeaderboardEntryModelImplCopyWithImpl<$Res>
    extends _$LeaderboardEntryModelCopyWithImpl<$Res,
        _$LeaderboardEntryModelImpl>
    implements _$$LeaderboardEntryModelImplCopyWith<$Res> {
  __$$LeaderboardEntryModelImplCopyWithImpl(_$LeaderboardEntryModelImpl _value,
      $Res Function(_$LeaderboardEntryModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of LeaderboardEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? nickname = null,
    Object? avatarSeed = freezed,
    Object? totalScore = null,
    Object? correctAnswers = null,
    Object? currentStreak = null,
    Object? rank = null,
  }) {
    return _then(_$LeaderboardEntryModelImpl(
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      avatarSeed: freezed == avatarSeed
          ? _value.avatarSeed
          : avatarSeed // ignore: cast_nullable_to_non_nullable
              as String?,
      totalScore: null == totalScore
          ? _value.totalScore
          : totalScore // ignore: cast_nullable_to_non_nullable
              as int,
      correctAnswers: null == correctAnswers
          ? _value.correctAnswers
          : correctAnswers // ignore: cast_nullable_to_non_nullable
              as int,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LeaderboardEntryModelImpl implements _LeaderboardEntryModel {
  const _$LeaderboardEntryModelImpl(
      {@JsonKey(name: 'player_id') required this.playerId,
      required this.nickname,
      @JsonKey(name: 'avatar_seed') this.avatarSeed,
      @JsonKey(name: 'total_score') required this.totalScore,
      @JsonKey(name: 'correct_answers') required this.correctAnswers,
      @JsonKey(name: 'current_streak') required this.currentStreak,
      required this.rank});

  factory _$LeaderboardEntryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeaderboardEntryModelImplFromJson(json);

  @override
  @JsonKey(name: 'player_id')
  final String playerId;
  @override
  final String nickname;
  @override
  @JsonKey(name: 'avatar_seed')
  final String? avatarSeed;
  @override
  @JsonKey(name: 'total_score')
  final int totalScore;
  @override
  @JsonKey(name: 'correct_answers')
  final int correctAnswers;
  @override
  @JsonKey(name: 'current_streak')
  final int currentStreak;
  @override
  final int rank;

  @override
  String toString() {
    return 'LeaderboardEntryModel(playerId: $playerId, nickname: $nickname, avatarSeed: $avatarSeed, totalScore: $totalScore, correctAnswers: $correctAnswers, currentStreak: $currentStreak, rank: $rank)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeaderboardEntryModelImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.avatarSeed, avatarSeed) ||
                other.avatarSeed == avatarSeed) &&
            (identical(other.totalScore, totalScore) ||
                other.totalScore == totalScore) &&
            (identical(other.correctAnswers, correctAnswers) ||
                other.correctAnswers == correctAnswers) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.rank, rank) || other.rank == rank));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, playerId, nickname, avatarSeed,
      totalScore, correctAnswers, currentStreak, rank);

  /// Create a copy of LeaderboardEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LeaderboardEntryModelImplCopyWith<_$LeaderboardEntryModelImpl>
      get copyWith => __$$LeaderboardEntryModelImplCopyWithImpl<
          _$LeaderboardEntryModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LeaderboardEntryModelImplToJson(
      this,
    );
  }
}

abstract class _LeaderboardEntryModel implements LeaderboardEntryModel {
  const factory _LeaderboardEntryModel(
      {@JsonKey(name: 'player_id') required final String playerId,
      required final String nickname,
      @JsonKey(name: 'avatar_seed') final String? avatarSeed,
      @JsonKey(name: 'total_score') required final int totalScore,
      @JsonKey(name: 'correct_answers') required final int correctAnswers,
      @JsonKey(name: 'current_streak') required final int currentStreak,
      required final int rank}) = _$LeaderboardEntryModelImpl;

  factory _LeaderboardEntryModel.fromJson(Map<String, dynamic> json) =
      _$LeaderboardEntryModelImpl.fromJson;

  @override
  @JsonKey(name: 'player_id')
  String get playerId;
  @override
  String get nickname;
  @override
  @JsonKey(name: 'avatar_seed')
  String? get avatarSeed;
  @override
  @JsonKey(name: 'total_score')
  int get totalScore;
  @override
  @JsonKey(name: 'correct_answers')
  int get correctAnswers;
  @override
  @JsonKey(name: 'current_streak')
  int get currentStreak;
  @override
  int get rank;

  /// Create a copy of LeaderboardEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LeaderboardEntryModelImplCopyWith<_$LeaderboardEntryModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
