// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlayerModel _$PlayerModelFromJson(Map<String, dynamic> json) {
  return _PlayerModel.fromJson(json);
}

/// @nodoc
mixin _$PlayerModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'session_id')
  String get sessionId => throw _privateConstructorUsedError;
  String get nickname => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_seed')
  String? get avatarSeed => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_score')
  int get totalScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_streak')
  int get currentStreak => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_connected')
  bool get isConnected => throw _privateConstructorUsedError;
  @JsonKey(name: 'joined_at')
  DateTime? get joinedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_seen_at')
  DateTime? get lastSeenAt => throw _privateConstructorUsedError;

  /// Serializes this PlayerModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerModelCopyWith<PlayerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerModelCopyWith<$Res> {
  factory $PlayerModelCopyWith(
          PlayerModel value, $Res Function(PlayerModel) then) =
      _$PlayerModelCopyWithImpl<$Res, PlayerModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'session_id') String sessionId,
      String nickname,
      @JsonKey(name: 'avatar_seed') String? avatarSeed,
      @JsonKey(name: 'total_score') int totalScore,
      @JsonKey(name: 'current_streak') int currentStreak,
      @JsonKey(name: 'is_connected') bool isConnected,
      @JsonKey(name: 'joined_at') DateTime? joinedAt,
      @JsonKey(name: 'last_seen_at') DateTime? lastSeenAt});
}

/// @nodoc
class _$PlayerModelCopyWithImpl<$Res, $Val extends PlayerModel>
    implements $PlayerModelCopyWith<$Res> {
  _$PlayerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? nickname = null,
    Object? avatarSeed = freezed,
    Object? totalScore = null,
    Object? currentStreak = null,
    Object? isConnected = null,
    Object? joinedAt = freezed,
    Object? lastSeenAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
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
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      isConnected: null == isConnected
          ? _value.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      joinedAt: freezed == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastSeenAt: freezed == lastSeenAt
          ? _value.lastSeenAt
          : lastSeenAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlayerModelImplCopyWith<$Res>
    implements $PlayerModelCopyWith<$Res> {
  factory _$$PlayerModelImplCopyWith(
          _$PlayerModelImpl value, $Res Function(_$PlayerModelImpl) then) =
      __$$PlayerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'session_id') String sessionId,
      String nickname,
      @JsonKey(name: 'avatar_seed') String? avatarSeed,
      @JsonKey(name: 'total_score') int totalScore,
      @JsonKey(name: 'current_streak') int currentStreak,
      @JsonKey(name: 'is_connected') bool isConnected,
      @JsonKey(name: 'joined_at') DateTime? joinedAt,
      @JsonKey(name: 'last_seen_at') DateTime? lastSeenAt});
}

/// @nodoc
class __$$PlayerModelImplCopyWithImpl<$Res>
    extends _$PlayerModelCopyWithImpl<$Res, _$PlayerModelImpl>
    implements _$$PlayerModelImplCopyWith<$Res> {
  __$$PlayerModelImplCopyWithImpl(
      _$PlayerModelImpl _value, $Res Function(_$PlayerModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? nickname = null,
    Object? avatarSeed = freezed,
    Object? totalScore = null,
    Object? currentStreak = null,
    Object? isConnected = null,
    Object? joinedAt = freezed,
    Object? lastSeenAt = freezed,
  }) {
    return _then(_$PlayerModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
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
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      isConnected: null == isConnected
          ? _value.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      joinedAt: freezed == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastSeenAt: freezed == lastSeenAt
          ? _value.lastSeenAt
          : lastSeenAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerModelImpl implements _PlayerModel {
  const _$PlayerModelImpl(
      {required this.id,
      @JsonKey(name: 'session_id') required this.sessionId,
      required this.nickname,
      @JsonKey(name: 'avatar_seed') this.avatarSeed,
      @JsonKey(name: 'total_score') this.totalScore = 0,
      @JsonKey(name: 'current_streak') this.currentStreak = 0,
      @JsonKey(name: 'is_connected') this.isConnected = true,
      @JsonKey(name: 'joined_at') this.joinedAt,
      @JsonKey(name: 'last_seen_at') this.lastSeenAt});

  factory _$PlayerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'session_id')
  final String sessionId;
  @override
  final String nickname;
  @override
  @JsonKey(name: 'avatar_seed')
  final String? avatarSeed;
  @override
  @JsonKey(name: 'total_score')
  final int totalScore;
  @override
  @JsonKey(name: 'current_streak')
  final int currentStreak;
  @override
  @JsonKey(name: 'is_connected')
  final bool isConnected;
  @override
  @JsonKey(name: 'joined_at')
  final DateTime? joinedAt;
  @override
  @JsonKey(name: 'last_seen_at')
  final DateTime? lastSeenAt;

  @override
  String toString() {
    return 'PlayerModel(id: $id, sessionId: $sessionId, nickname: $nickname, avatarSeed: $avatarSeed, totalScore: $totalScore, currentStreak: $currentStreak, isConnected: $isConnected, joinedAt: $joinedAt, lastSeenAt: $lastSeenAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.avatarSeed, avatarSeed) ||
                other.avatarSeed == avatarSeed) &&
            (identical(other.totalScore, totalScore) ||
                other.totalScore == totalScore) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.isConnected, isConnected) ||
                other.isConnected == isConnected) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt) &&
            (identical(other.lastSeenAt, lastSeenAt) ||
                other.lastSeenAt == lastSeenAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, sessionId, nickname,
      avatarSeed, totalScore, currentStreak, isConnected, joinedAt, lastSeenAt);

  /// Create a copy of PlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerModelImplCopyWith<_$PlayerModelImpl> get copyWith =>
      __$$PlayerModelImplCopyWithImpl<_$PlayerModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerModelImplToJson(
      this,
    );
  }
}

abstract class _PlayerModel implements PlayerModel {
  const factory _PlayerModel(
          {required final String id,
          @JsonKey(name: 'session_id') required final String sessionId,
          required final String nickname,
          @JsonKey(name: 'avatar_seed') final String? avatarSeed,
          @JsonKey(name: 'total_score') final int totalScore,
          @JsonKey(name: 'current_streak') final int currentStreak,
          @JsonKey(name: 'is_connected') final bool isConnected,
          @JsonKey(name: 'joined_at') final DateTime? joinedAt,
          @JsonKey(name: 'last_seen_at') final DateTime? lastSeenAt}) =
      _$PlayerModelImpl;

  factory _PlayerModel.fromJson(Map<String, dynamic> json) =
      _$PlayerModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'session_id')
  String get sessionId;
  @override
  String get nickname;
  @override
  @JsonKey(name: 'avatar_seed')
  String? get avatarSeed;
  @override
  @JsonKey(name: 'total_score')
  int get totalScore;
  @override
  @JsonKey(name: 'current_streak')
  int get currentStreak;
  @override
  @JsonKey(name: 'is_connected')
  bool get isConnected;
  @override
  @JsonKey(name: 'joined_at')
  DateTime? get joinedAt;
  @override
  @JsonKey(name: 'last_seen_at')
  DateTime? get lastSeenAt;

  /// Create a copy of PlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerModelImplCopyWith<_$PlayerModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreatePlayerModel _$CreatePlayerModelFromJson(Map<String, dynamic> json) {
  return _CreatePlayerModel.fromJson(json);
}

/// @nodoc
mixin _$CreatePlayerModel {
  @JsonKey(name: 'session_id')
  String get sessionId => throw _privateConstructorUsedError;
  String get nickname => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_seed')
  String? get avatarSeed => throw _privateConstructorUsedError;

  /// Serializes this CreatePlayerModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreatePlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreatePlayerModelCopyWith<CreatePlayerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatePlayerModelCopyWith<$Res> {
  factory $CreatePlayerModelCopyWith(
          CreatePlayerModel value, $Res Function(CreatePlayerModel) then) =
      _$CreatePlayerModelCopyWithImpl<$Res, CreatePlayerModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'session_id') String sessionId,
      String nickname,
      @JsonKey(name: 'avatar_seed') String? avatarSeed});
}

/// @nodoc
class _$CreatePlayerModelCopyWithImpl<$Res, $Val extends CreatePlayerModel>
    implements $CreatePlayerModelCopyWith<$Res> {
  _$CreatePlayerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreatePlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? nickname = null,
    Object? avatarSeed = freezed,
  }) {
    return _then(_value.copyWith(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      avatarSeed: freezed == avatarSeed
          ? _value.avatarSeed
          : avatarSeed // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreatePlayerModelImplCopyWith<$Res>
    implements $CreatePlayerModelCopyWith<$Res> {
  factory _$$CreatePlayerModelImplCopyWith(_$CreatePlayerModelImpl value,
          $Res Function(_$CreatePlayerModelImpl) then) =
      __$$CreatePlayerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'session_id') String sessionId,
      String nickname,
      @JsonKey(name: 'avatar_seed') String? avatarSeed});
}

/// @nodoc
class __$$CreatePlayerModelImplCopyWithImpl<$Res>
    extends _$CreatePlayerModelCopyWithImpl<$Res, _$CreatePlayerModelImpl>
    implements _$$CreatePlayerModelImplCopyWith<$Res> {
  __$$CreatePlayerModelImplCopyWithImpl(_$CreatePlayerModelImpl _value,
      $Res Function(_$CreatePlayerModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreatePlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? nickname = null,
    Object? avatarSeed = freezed,
  }) {
    return _then(_$CreatePlayerModelImpl(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      avatarSeed: freezed == avatarSeed
          ? _value.avatarSeed
          : avatarSeed // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreatePlayerModelImpl implements _CreatePlayerModel {
  const _$CreatePlayerModelImpl(
      {@JsonKey(name: 'session_id') required this.sessionId,
      required this.nickname,
      @JsonKey(name: 'avatar_seed') this.avatarSeed});

  factory _$CreatePlayerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreatePlayerModelImplFromJson(json);

  @override
  @JsonKey(name: 'session_id')
  final String sessionId;
  @override
  final String nickname;
  @override
  @JsonKey(name: 'avatar_seed')
  final String? avatarSeed;

  @override
  String toString() {
    return 'CreatePlayerModel(sessionId: $sessionId, nickname: $nickname, avatarSeed: $avatarSeed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatePlayerModelImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.avatarSeed, avatarSeed) ||
                other.avatarSeed == avatarSeed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sessionId, nickname, avatarSeed);

  /// Create a copy of CreatePlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatePlayerModelImplCopyWith<_$CreatePlayerModelImpl> get copyWith =>
      __$$CreatePlayerModelImplCopyWithImpl<_$CreatePlayerModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreatePlayerModelImplToJson(
      this,
    );
  }
}

abstract class _CreatePlayerModel implements CreatePlayerModel {
  const factory _CreatePlayerModel(
          {@JsonKey(name: 'session_id') required final String sessionId,
          required final String nickname,
          @JsonKey(name: 'avatar_seed') final String? avatarSeed}) =
      _$CreatePlayerModelImpl;

  factory _CreatePlayerModel.fromJson(Map<String, dynamic> json) =
      _$CreatePlayerModelImpl.fromJson;

  @override
  @JsonKey(name: 'session_id')
  String get sessionId;
  @override
  String get nickname;
  @override
  @JsonKey(name: 'avatar_seed')
  String? get avatarSeed;

  /// Create a copy of CreatePlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreatePlayerModelImplCopyWith<_$CreatePlayerModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
