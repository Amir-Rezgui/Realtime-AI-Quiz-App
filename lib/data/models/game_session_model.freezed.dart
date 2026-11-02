// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_session_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GameSessionModel _$GameSessionModelFromJson(Map<String, dynamic> json) {
  return _GameSessionModel.fromJson(json);
}

/// @nodoc
mixin _$GameSessionModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'quiz_id')
  String get quizId => throw _privateConstructorUsedError;
  @JsonKey(name: 'host_id')
  String get hostId => throw _privateConstructorUsedError;
  @JsonKey(name: 'join_code')
  String get joinCode => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_question_index')
  int get currentQuestionIndex => throw _privateConstructorUsedError;
  @JsonKey(name: 'question_started_at')
  DateTime? get questionStartedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'player_count')
  int get playerCount => throw _privateConstructorUsedError;
  Map<String, dynamic> get settings => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'finished_at')
  DateTime? get finishedAt => throw _privateConstructorUsedError;

  /// Serializes this GameSessionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameSessionModelCopyWith<GameSessionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameSessionModelCopyWith<$Res> {
  factory $GameSessionModelCopyWith(
          GameSessionModel value, $Res Function(GameSessionModel) then) =
      _$GameSessionModelCopyWithImpl<$Res, GameSessionModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'quiz_id') String quizId,
      @JsonKey(name: 'host_id') String hostId,
      @JsonKey(name: 'join_code') String joinCode,
      String status,
      @JsonKey(name: 'current_question_index') int currentQuestionIndex,
      @JsonKey(name: 'question_started_at') DateTime? questionStartedAt,
      @JsonKey(name: 'player_count') int playerCount,
      Map<String, dynamic> settings,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'finished_at') DateTime? finishedAt});
}

/// @nodoc
class _$GameSessionModelCopyWithImpl<$Res, $Val extends GameSessionModel>
    implements $GameSessionModelCopyWith<$Res> {
  _$GameSessionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quizId = null,
    Object? hostId = null,
    Object? joinCode = null,
    Object? status = null,
    Object? currentQuestionIndex = null,
    Object? questionStartedAt = freezed,
    Object? playerCount = null,
    Object? settings = null,
    Object? createdAt = freezed,
    Object? finishedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      quizId: null == quizId
          ? _value.quizId
          : quizId // ignore: cast_nullable_to_non_nullable
              as String,
      hostId: null == hostId
          ? _value.hostId
          : hostId // ignore: cast_nullable_to_non_nullable
              as String,
      joinCode: null == joinCode
          ? _value.joinCode
          : joinCode // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      currentQuestionIndex: null == currentQuestionIndex
          ? _value.currentQuestionIndex
          : currentQuestionIndex // ignore: cast_nullable_to_non_nullable
              as int,
      questionStartedAt: freezed == questionStartedAt
          ? _value.questionStartedAt
          : questionStartedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      playerCount: null == playerCount
          ? _value.playerCount
          : playerCount // ignore: cast_nullable_to_non_nullable
              as int,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      finishedAt: freezed == finishedAt
          ? _value.finishedAt
          : finishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GameSessionModelImplCopyWith<$Res>
    implements $GameSessionModelCopyWith<$Res> {
  factory _$$GameSessionModelImplCopyWith(_$GameSessionModelImpl value,
          $Res Function(_$GameSessionModelImpl) then) =
      __$$GameSessionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'quiz_id') String quizId,
      @JsonKey(name: 'host_id') String hostId,
      @JsonKey(name: 'join_code') String joinCode,
      String status,
      @JsonKey(name: 'current_question_index') int currentQuestionIndex,
      @JsonKey(name: 'question_started_at') DateTime? questionStartedAt,
      @JsonKey(name: 'player_count') int playerCount,
      Map<String, dynamic> settings,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'finished_at') DateTime? finishedAt});
}

/// @nodoc
class __$$GameSessionModelImplCopyWithImpl<$Res>
    extends _$GameSessionModelCopyWithImpl<$Res, _$GameSessionModelImpl>
    implements _$$GameSessionModelImplCopyWith<$Res> {
  __$$GameSessionModelImplCopyWithImpl(_$GameSessionModelImpl _value,
      $Res Function(_$GameSessionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of GameSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quizId = null,
    Object? hostId = null,
    Object? joinCode = null,
    Object? status = null,
    Object? currentQuestionIndex = null,
    Object? questionStartedAt = freezed,
    Object? playerCount = null,
    Object? settings = null,
    Object? createdAt = freezed,
    Object? finishedAt = freezed,
  }) {
    return _then(_$GameSessionModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      quizId: null == quizId
          ? _value.quizId
          : quizId // ignore: cast_nullable_to_non_nullable
              as String,
      hostId: null == hostId
          ? _value.hostId
          : hostId // ignore: cast_nullable_to_non_nullable
              as String,
      joinCode: null == joinCode
          ? _value.joinCode
          : joinCode // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      currentQuestionIndex: null == currentQuestionIndex
          ? _value.currentQuestionIndex
          : currentQuestionIndex // ignore: cast_nullable_to_non_nullable
              as int,
      questionStartedAt: freezed == questionStartedAt
          ? _value.questionStartedAt
          : questionStartedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      playerCount: null == playerCount
          ? _value.playerCount
          : playerCount // ignore: cast_nullable_to_non_nullable
              as int,
      settings: null == settings
          ? _value._settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      finishedAt: freezed == finishedAt
          ? _value.finishedAt
          : finishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GameSessionModelImpl implements _GameSessionModel {
  const _$GameSessionModelImpl(
      {required this.id,
      @JsonKey(name: 'quiz_id') required this.quizId,
      @JsonKey(name: 'host_id') required this.hostId,
      @JsonKey(name: 'join_code') required this.joinCode,
      this.status = 'lobby',
      @JsonKey(name: 'current_question_index') this.currentQuestionIndex = 0,
      @JsonKey(name: 'question_started_at') this.questionStartedAt,
      @JsonKey(name: 'player_count') this.playerCount = 0,
      final Map<String, dynamic> settings = const {},
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'finished_at') this.finishedAt})
      : _settings = settings;

  factory _$GameSessionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameSessionModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'quiz_id')
  final String quizId;
  @override
  @JsonKey(name: 'host_id')
  final String hostId;
  @override
  @JsonKey(name: 'join_code')
  final String joinCode;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'current_question_index')
  final int currentQuestionIndex;
  @override
  @JsonKey(name: 'question_started_at')
  final DateTime? questionStartedAt;
  @override
  @JsonKey(name: 'player_count')
  final int playerCount;
  final Map<String, dynamic> _settings;
  @override
  @JsonKey()
  Map<String, dynamic> get settings {
    if (_settings is EqualUnmodifiableMapView) return _settings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_settings);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'finished_at')
  final DateTime? finishedAt;

  @override
  String toString() {
    return 'GameSessionModel(id: $id, quizId: $quizId, hostId: $hostId, joinCode: $joinCode, status: $status, currentQuestionIndex: $currentQuestionIndex, questionStartedAt: $questionStartedAt, playerCount: $playerCount, settings: $settings, createdAt: $createdAt, finishedAt: $finishedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameSessionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quizId, quizId) || other.quizId == quizId) &&
            (identical(other.hostId, hostId) || other.hostId == hostId) &&
            (identical(other.joinCode, joinCode) ||
                other.joinCode == joinCode) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.currentQuestionIndex, currentQuestionIndex) ||
                other.currentQuestionIndex == currentQuestionIndex) &&
            (identical(other.questionStartedAt, questionStartedAt) ||
                other.questionStartedAt == questionStartedAt) &&
            (identical(other.playerCount, playerCount) ||
                other.playerCount == playerCount) &&
            const DeepCollectionEquality().equals(other._settings, _settings) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.finishedAt, finishedAt) ||
                other.finishedAt == finishedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      quizId,
      hostId,
      joinCode,
      status,
      currentQuestionIndex,
      questionStartedAt,
      playerCount,
      const DeepCollectionEquality().hash(_settings),
      createdAt,
      finishedAt);

  /// Create a copy of GameSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameSessionModelImplCopyWith<_$GameSessionModelImpl> get copyWith =>
      __$$GameSessionModelImplCopyWithImpl<_$GameSessionModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameSessionModelImplToJson(
      this,
    );
  }
}

abstract class _GameSessionModel implements GameSessionModel {
  const factory _GameSessionModel(
      {required final String id,
      @JsonKey(name: 'quiz_id') required final String quizId,
      @JsonKey(name: 'host_id') required final String hostId,
      @JsonKey(name: 'join_code') required final String joinCode,
      final String status,
      @JsonKey(name: 'current_question_index') final int currentQuestionIndex,
      @JsonKey(name: 'question_started_at') final DateTime? questionStartedAt,
      @JsonKey(name: 'player_count') final int playerCount,
      final Map<String, dynamic> settings,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'finished_at')
      final DateTime? finishedAt}) = _$GameSessionModelImpl;

  factory _GameSessionModel.fromJson(Map<String, dynamic> json) =
      _$GameSessionModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'quiz_id')
  String get quizId;
  @override
  @JsonKey(name: 'host_id')
  String get hostId;
  @override
  @JsonKey(name: 'join_code')
  String get joinCode;
  @override
  String get status;
  @override
  @JsonKey(name: 'current_question_index')
  int get currentQuestionIndex;
  @override
  @JsonKey(name: 'question_started_at')
  DateTime? get questionStartedAt;
  @override
  @JsonKey(name: 'player_count')
  int get playerCount;
  @override
  Map<String, dynamic> get settings;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'finished_at')
  DateTime? get finishedAt;

  /// Create a copy of GameSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameSessionModelImplCopyWith<_$GameSessionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateGameSessionModel _$CreateGameSessionModelFromJson(
    Map<String, dynamic> json) {
  return _CreateGameSessionModel.fromJson(json);
}

/// @nodoc
mixin _$CreateGameSessionModel {
  @JsonKey(name: 'quiz_id')
  String get quizId => throw _privateConstructorUsedError;
  @JsonKey(name: 'host_id')
  String get hostId => throw _privateConstructorUsedError;
  @JsonKey(name: 'join_code')
  String get joinCode => throw _privateConstructorUsedError;

  /// Serializes this CreateGameSessionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateGameSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateGameSessionModelCopyWith<CreateGameSessionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateGameSessionModelCopyWith<$Res> {
  factory $CreateGameSessionModelCopyWith(CreateGameSessionModel value,
          $Res Function(CreateGameSessionModel) then) =
      _$CreateGameSessionModelCopyWithImpl<$Res, CreateGameSessionModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'quiz_id') String quizId,
      @JsonKey(name: 'host_id') String hostId,
      @JsonKey(name: 'join_code') String joinCode});
}

/// @nodoc
class _$CreateGameSessionModelCopyWithImpl<$Res,
        $Val extends CreateGameSessionModel>
    implements $CreateGameSessionModelCopyWith<$Res> {
  _$CreateGameSessionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateGameSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? quizId = null,
    Object? hostId = null,
    Object? joinCode = null,
  }) {
    return _then(_value.copyWith(
      quizId: null == quizId
          ? _value.quizId
          : quizId // ignore: cast_nullable_to_non_nullable
              as String,
      hostId: null == hostId
          ? _value.hostId
          : hostId // ignore: cast_nullable_to_non_nullable
              as String,
      joinCode: null == joinCode
          ? _value.joinCode
          : joinCode // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateGameSessionModelImplCopyWith<$Res>
    implements $CreateGameSessionModelCopyWith<$Res> {
  factory _$$CreateGameSessionModelImplCopyWith(
          _$CreateGameSessionModelImpl value,
          $Res Function(_$CreateGameSessionModelImpl) then) =
      __$$CreateGameSessionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'quiz_id') String quizId,
      @JsonKey(name: 'host_id') String hostId,
      @JsonKey(name: 'join_code') String joinCode});
}

/// @nodoc
class __$$CreateGameSessionModelImplCopyWithImpl<$Res>
    extends _$CreateGameSessionModelCopyWithImpl<$Res,
        _$CreateGameSessionModelImpl>
    implements _$$CreateGameSessionModelImplCopyWith<$Res> {
  __$$CreateGameSessionModelImplCopyWithImpl(
      _$CreateGameSessionModelImpl _value,
      $Res Function(_$CreateGameSessionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateGameSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? quizId = null,
    Object? hostId = null,
    Object? joinCode = null,
  }) {
    return _then(_$CreateGameSessionModelImpl(
      quizId: null == quizId
          ? _value.quizId
          : quizId // ignore: cast_nullable_to_non_nullable
              as String,
      hostId: null == hostId
          ? _value.hostId
          : hostId // ignore: cast_nullable_to_non_nullable
              as String,
      joinCode: null == joinCode
          ? _value.joinCode
          : joinCode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateGameSessionModelImpl implements _CreateGameSessionModel {
  const _$CreateGameSessionModelImpl(
      {@JsonKey(name: 'quiz_id') required this.quizId,
      @JsonKey(name: 'host_id') required this.hostId,
      @JsonKey(name: 'join_code') required this.joinCode});

  factory _$CreateGameSessionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateGameSessionModelImplFromJson(json);

  @override
  @JsonKey(name: 'quiz_id')
  final String quizId;
  @override
  @JsonKey(name: 'host_id')
  final String hostId;
  @override
  @JsonKey(name: 'join_code')
  final String joinCode;

  @override
  String toString() {
    return 'CreateGameSessionModel(quizId: $quizId, hostId: $hostId, joinCode: $joinCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateGameSessionModelImpl &&
            (identical(other.quizId, quizId) || other.quizId == quizId) &&
            (identical(other.hostId, hostId) || other.hostId == hostId) &&
            (identical(other.joinCode, joinCode) ||
                other.joinCode == joinCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, quizId, hostId, joinCode);

  /// Create a copy of CreateGameSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateGameSessionModelImplCopyWith<_$CreateGameSessionModelImpl>
      get copyWith => __$$CreateGameSessionModelImplCopyWithImpl<
          _$CreateGameSessionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateGameSessionModelImplToJson(
      this,
    );
  }
}

abstract class _CreateGameSessionModel implements CreateGameSessionModel {
  const factory _CreateGameSessionModel(
          {@JsonKey(name: 'quiz_id') required final String quizId,
          @JsonKey(name: 'host_id') required final String hostId,
          @JsonKey(name: 'join_code') required final String joinCode}) =
      _$CreateGameSessionModelImpl;

  factory _CreateGameSessionModel.fromJson(Map<String, dynamic> json) =
      _$CreateGameSessionModelImpl.fromJson;

  @override
  @JsonKey(name: 'quiz_id')
  String get quizId;
  @override
  @JsonKey(name: 'host_id')
  String get hostId;
  @override
  @JsonKey(name: 'join_code')
  String get joinCode;

  /// Create a copy of CreateGameSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateGameSessionModelImplCopyWith<_$CreateGameSessionModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
