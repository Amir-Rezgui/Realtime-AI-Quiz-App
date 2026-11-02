// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_answer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlayerAnswerModel _$PlayerAnswerModelFromJson(Map<String, dynamic> json) {
  return _PlayerAnswerModel.fromJson(json);
}

/// @nodoc
mixin _$PlayerAnswerModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'player_id')
  String get playerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'question_id')
  String get questionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'session_id')
  String get sessionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'selected_answer_ids')
  List<String> get selectedAnswerIds => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_correct')
  bool get isCorrect => throw _privateConstructorUsedError;
  @JsonKey(name: 'response_time_ms')
  int get responseTimeMs => throw _privateConstructorUsedError;
  @JsonKey(name: 'points_earned')
  int get pointsEarned => throw _privateConstructorUsedError;
  @JsonKey(name: 'answered_at')
  DateTime? get answeredAt => throw _privateConstructorUsedError;

  /// Serializes this PlayerAnswerModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlayerAnswerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerAnswerModelCopyWith<PlayerAnswerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerAnswerModelCopyWith<$Res> {
  factory $PlayerAnswerModelCopyWith(
          PlayerAnswerModel value, $Res Function(PlayerAnswerModel) then) =
      _$PlayerAnswerModelCopyWithImpl<$Res, PlayerAnswerModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'player_id') String playerId,
      @JsonKey(name: 'question_id') String questionId,
      @JsonKey(name: 'session_id') String sessionId,
      @JsonKey(name: 'selected_answer_ids') List<String> selectedAnswerIds,
      @JsonKey(name: 'is_correct') bool isCorrect,
      @JsonKey(name: 'response_time_ms') int responseTimeMs,
      @JsonKey(name: 'points_earned') int pointsEarned,
      @JsonKey(name: 'answered_at') DateTime? answeredAt});
}

/// @nodoc
class _$PlayerAnswerModelCopyWithImpl<$Res, $Val extends PlayerAnswerModel>
    implements $PlayerAnswerModelCopyWith<$Res> {
  _$PlayerAnswerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerAnswerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? playerId = null,
    Object? questionId = null,
    Object? sessionId = null,
    Object? selectedAnswerIds = null,
    Object? isCorrect = null,
    Object? responseTimeMs = null,
    Object? pointsEarned = null,
    Object? answeredAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String,
      questionId: null == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      selectedAnswerIds: null == selectedAnswerIds
          ? _value.selectedAnswerIds
          : selectedAnswerIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isCorrect: null == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
      responseTimeMs: null == responseTimeMs
          ? _value.responseTimeMs
          : responseTimeMs // ignore: cast_nullable_to_non_nullable
              as int,
      pointsEarned: null == pointsEarned
          ? _value.pointsEarned
          : pointsEarned // ignore: cast_nullable_to_non_nullable
              as int,
      answeredAt: freezed == answeredAt
          ? _value.answeredAt
          : answeredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlayerAnswerModelImplCopyWith<$Res>
    implements $PlayerAnswerModelCopyWith<$Res> {
  factory _$$PlayerAnswerModelImplCopyWith(_$PlayerAnswerModelImpl value,
          $Res Function(_$PlayerAnswerModelImpl) then) =
      __$$PlayerAnswerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'player_id') String playerId,
      @JsonKey(name: 'question_id') String questionId,
      @JsonKey(name: 'session_id') String sessionId,
      @JsonKey(name: 'selected_answer_ids') List<String> selectedAnswerIds,
      @JsonKey(name: 'is_correct') bool isCorrect,
      @JsonKey(name: 'response_time_ms') int responseTimeMs,
      @JsonKey(name: 'points_earned') int pointsEarned,
      @JsonKey(name: 'answered_at') DateTime? answeredAt});
}

/// @nodoc
class __$$PlayerAnswerModelImplCopyWithImpl<$Res>
    extends _$PlayerAnswerModelCopyWithImpl<$Res, _$PlayerAnswerModelImpl>
    implements _$$PlayerAnswerModelImplCopyWith<$Res> {
  __$$PlayerAnswerModelImplCopyWithImpl(_$PlayerAnswerModelImpl _value,
      $Res Function(_$PlayerAnswerModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlayerAnswerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? playerId = null,
    Object? questionId = null,
    Object? sessionId = null,
    Object? selectedAnswerIds = null,
    Object? isCorrect = null,
    Object? responseTimeMs = null,
    Object? pointsEarned = null,
    Object? answeredAt = freezed,
  }) {
    return _then(_$PlayerAnswerModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String,
      questionId: null == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      selectedAnswerIds: null == selectedAnswerIds
          ? _value._selectedAnswerIds
          : selectedAnswerIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isCorrect: null == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
      responseTimeMs: null == responseTimeMs
          ? _value.responseTimeMs
          : responseTimeMs // ignore: cast_nullable_to_non_nullable
              as int,
      pointsEarned: null == pointsEarned
          ? _value.pointsEarned
          : pointsEarned // ignore: cast_nullable_to_non_nullable
              as int,
      answeredAt: freezed == answeredAt
          ? _value.answeredAt
          : answeredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerAnswerModelImpl implements _PlayerAnswerModel {
  const _$PlayerAnswerModelImpl(
      {required this.id,
      @JsonKey(name: 'player_id') required this.playerId,
      @JsonKey(name: 'question_id') required this.questionId,
      @JsonKey(name: 'session_id') required this.sessionId,
      @JsonKey(name: 'selected_answer_ids')
      required final List<String> selectedAnswerIds,
      @JsonKey(name: 'is_correct') required this.isCorrect,
      @JsonKey(name: 'response_time_ms') required this.responseTimeMs,
      @JsonKey(name: 'points_earned') this.pointsEarned = 0,
      @JsonKey(name: 'answered_at') this.answeredAt})
      : _selectedAnswerIds = selectedAnswerIds;

  factory _$PlayerAnswerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerAnswerModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'player_id')
  final String playerId;
  @override
  @JsonKey(name: 'question_id')
  final String questionId;
  @override
  @JsonKey(name: 'session_id')
  final String sessionId;
  final List<String> _selectedAnswerIds;
  @override
  @JsonKey(name: 'selected_answer_ids')
  List<String> get selectedAnswerIds {
    if (_selectedAnswerIds is EqualUnmodifiableListView)
      return _selectedAnswerIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedAnswerIds);
  }

  @override
  @JsonKey(name: 'is_correct')
  final bool isCorrect;
  @override
  @JsonKey(name: 'response_time_ms')
  final int responseTimeMs;
  @override
  @JsonKey(name: 'points_earned')
  final int pointsEarned;
  @override
  @JsonKey(name: 'answered_at')
  final DateTime? answeredAt;

  @override
  String toString() {
    return 'PlayerAnswerModel(id: $id, playerId: $playerId, questionId: $questionId, sessionId: $sessionId, selectedAnswerIds: $selectedAnswerIds, isCorrect: $isCorrect, responseTimeMs: $responseTimeMs, pointsEarned: $pointsEarned, answeredAt: $answeredAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerAnswerModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            const DeepCollectionEquality()
                .equals(other._selectedAnswerIds, _selectedAnswerIds) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect) &&
            (identical(other.responseTimeMs, responseTimeMs) ||
                other.responseTimeMs == responseTimeMs) &&
            (identical(other.pointsEarned, pointsEarned) ||
                other.pointsEarned == pointsEarned) &&
            (identical(other.answeredAt, answeredAt) ||
                other.answeredAt == answeredAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      playerId,
      questionId,
      sessionId,
      const DeepCollectionEquality().hash(_selectedAnswerIds),
      isCorrect,
      responseTimeMs,
      pointsEarned,
      answeredAt);

  /// Create a copy of PlayerAnswerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerAnswerModelImplCopyWith<_$PlayerAnswerModelImpl> get copyWith =>
      __$$PlayerAnswerModelImplCopyWithImpl<_$PlayerAnswerModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerAnswerModelImplToJson(
      this,
    );
  }
}

abstract class _PlayerAnswerModel implements PlayerAnswerModel {
  const factory _PlayerAnswerModel(
          {required final String id,
          @JsonKey(name: 'player_id') required final String playerId,
          @JsonKey(name: 'question_id') required final String questionId,
          @JsonKey(name: 'session_id') required final String sessionId,
          @JsonKey(name: 'selected_answer_ids')
          required final List<String> selectedAnswerIds,
          @JsonKey(name: 'is_correct') required final bool isCorrect,
          @JsonKey(name: 'response_time_ms') required final int responseTimeMs,
          @JsonKey(name: 'points_earned') final int pointsEarned,
          @JsonKey(name: 'answered_at') final DateTime? answeredAt}) =
      _$PlayerAnswerModelImpl;

  factory _PlayerAnswerModel.fromJson(Map<String, dynamic> json) =
      _$PlayerAnswerModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'player_id')
  String get playerId;
  @override
  @JsonKey(name: 'question_id')
  String get questionId;
  @override
  @JsonKey(name: 'session_id')
  String get sessionId;
  @override
  @JsonKey(name: 'selected_answer_ids')
  List<String> get selectedAnswerIds;
  @override
  @JsonKey(name: 'is_correct')
  bool get isCorrect;
  @override
  @JsonKey(name: 'response_time_ms')
  int get responseTimeMs;
  @override
  @JsonKey(name: 'points_earned')
  int get pointsEarned;
  @override
  @JsonKey(name: 'answered_at')
  DateTime? get answeredAt;

  /// Create a copy of PlayerAnswerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerAnswerModelImplCopyWith<_$PlayerAnswerModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreatePlayerAnswerModel _$CreatePlayerAnswerModelFromJson(
    Map<String, dynamic> json) {
  return _CreatePlayerAnswerModel.fromJson(json);
}

/// @nodoc
mixin _$CreatePlayerAnswerModel {
  @JsonKey(name: 'player_id')
  String get playerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'question_id')
  String get questionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'session_id')
  String get sessionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'selected_answer_ids')
  List<String> get selectedAnswerIds => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_correct')
  bool get isCorrect => throw _privateConstructorUsedError;
  @JsonKey(name: 'response_time_ms')
  int get responseTimeMs => throw _privateConstructorUsedError;
  @JsonKey(name: 'points_earned')
  int get pointsEarned => throw _privateConstructorUsedError;

  /// Serializes this CreatePlayerAnswerModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreatePlayerAnswerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreatePlayerAnswerModelCopyWith<CreatePlayerAnswerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatePlayerAnswerModelCopyWith<$Res> {
  factory $CreatePlayerAnswerModelCopyWith(CreatePlayerAnswerModel value,
          $Res Function(CreatePlayerAnswerModel) then) =
      _$CreatePlayerAnswerModelCopyWithImpl<$Res, CreatePlayerAnswerModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'player_id') String playerId,
      @JsonKey(name: 'question_id') String questionId,
      @JsonKey(name: 'session_id') String sessionId,
      @JsonKey(name: 'selected_answer_ids') List<String> selectedAnswerIds,
      @JsonKey(name: 'is_correct') bool isCorrect,
      @JsonKey(name: 'response_time_ms') int responseTimeMs,
      @JsonKey(name: 'points_earned') int pointsEarned});
}

/// @nodoc
class _$CreatePlayerAnswerModelCopyWithImpl<$Res,
        $Val extends CreatePlayerAnswerModel>
    implements $CreatePlayerAnswerModelCopyWith<$Res> {
  _$CreatePlayerAnswerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreatePlayerAnswerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? questionId = null,
    Object? sessionId = null,
    Object? selectedAnswerIds = null,
    Object? isCorrect = null,
    Object? responseTimeMs = null,
    Object? pointsEarned = null,
  }) {
    return _then(_value.copyWith(
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String,
      questionId: null == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      selectedAnswerIds: null == selectedAnswerIds
          ? _value.selectedAnswerIds
          : selectedAnswerIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isCorrect: null == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
      responseTimeMs: null == responseTimeMs
          ? _value.responseTimeMs
          : responseTimeMs // ignore: cast_nullable_to_non_nullable
              as int,
      pointsEarned: null == pointsEarned
          ? _value.pointsEarned
          : pointsEarned // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreatePlayerAnswerModelImplCopyWith<$Res>
    implements $CreatePlayerAnswerModelCopyWith<$Res> {
  factory _$$CreatePlayerAnswerModelImplCopyWith(
          _$CreatePlayerAnswerModelImpl value,
          $Res Function(_$CreatePlayerAnswerModelImpl) then) =
      __$$CreatePlayerAnswerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'player_id') String playerId,
      @JsonKey(name: 'question_id') String questionId,
      @JsonKey(name: 'session_id') String sessionId,
      @JsonKey(name: 'selected_answer_ids') List<String> selectedAnswerIds,
      @JsonKey(name: 'is_correct') bool isCorrect,
      @JsonKey(name: 'response_time_ms') int responseTimeMs,
      @JsonKey(name: 'points_earned') int pointsEarned});
}

/// @nodoc
class __$$CreatePlayerAnswerModelImplCopyWithImpl<$Res>
    extends _$CreatePlayerAnswerModelCopyWithImpl<$Res,
        _$CreatePlayerAnswerModelImpl>
    implements _$$CreatePlayerAnswerModelImplCopyWith<$Res> {
  __$$CreatePlayerAnswerModelImplCopyWithImpl(
      _$CreatePlayerAnswerModelImpl _value,
      $Res Function(_$CreatePlayerAnswerModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreatePlayerAnswerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? questionId = null,
    Object? sessionId = null,
    Object? selectedAnswerIds = null,
    Object? isCorrect = null,
    Object? responseTimeMs = null,
    Object? pointsEarned = null,
  }) {
    return _then(_$CreatePlayerAnswerModelImpl(
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String,
      questionId: null == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      selectedAnswerIds: null == selectedAnswerIds
          ? _value._selectedAnswerIds
          : selectedAnswerIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isCorrect: null == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
      responseTimeMs: null == responseTimeMs
          ? _value.responseTimeMs
          : responseTimeMs // ignore: cast_nullable_to_non_nullable
              as int,
      pointsEarned: null == pointsEarned
          ? _value.pointsEarned
          : pointsEarned // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreatePlayerAnswerModelImpl implements _CreatePlayerAnswerModel {
  const _$CreatePlayerAnswerModelImpl(
      {@JsonKey(name: 'player_id') required this.playerId,
      @JsonKey(name: 'question_id') required this.questionId,
      @JsonKey(name: 'session_id') required this.sessionId,
      @JsonKey(name: 'selected_answer_ids')
      required final List<String> selectedAnswerIds,
      @JsonKey(name: 'is_correct') required this.isCorrect,
      @JsonKey(name: 'response_time_ms') required this.responseTimeMs,
      @JsonKey(name: 'points_earned') required this.pointsEarned})
      : _selectedAnswerIds = selectedAnswerIds;

  factory _$CreatePlayerAnswerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreatePlayerAnswerModelImplFromJson(json);

  @override
  @JsonKey(name: 'player_id')
  final String playerId;
  @override
  @JsonKey(name: 'question_id')
  final String questionId;
  @override
  @JsonKey(name: 'session_id')
  final String sessionId;
  final List<String> _selectedAnswerIds;
  @override
  @JsonKey(name: 'selected_answer_ids')
  List<String> get selectedAnswerIds {
    if (_selectedAnswerIds is EqualUnmodifiableListView)
      return _selectedAnswerIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedAnswerIds);
  }

  @override
  @JsonKey(name: 'is_correct')
  final bool isCorrect;
  @override
  @JsonKey(name: 'response_time_ms')
  final int responseTimeMs;
  @override
  @JsonKey(name: 'points_earned')
  final int pointsEarned;

  @override
  String toString() {
    return 'CreatePlayerAnswerModel(playerId: $playerId, questionId: $questionId, sessionId: $sessionId, selectedAnswerIds: $selectedAnswerIds, isCorrect: $isCorrect, responseTimeMs: $responseTimeMs, pointsEarned: $pointsEarned)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatePlayerAnswerModelImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            const DeepCollectionEquality()
                .equals(other._selectedAnswerIds, _selectedAnswerIds) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect) &&
            (identical(other.responseTimeMs, responseTimeMs) ||
                other.responseTimeMs == responseTimeMs) &&
            (identical(other.pointsEarned, pointsEarned) ||
                other.pointsEarned == pointsEarned));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      playerId,
      questionId,
      sessionId,
      const DeepCollectionEquality().hash(_selectedAnswerIds),
      isCorrect,
      responseTimeMs,
      pointsEarned);

  /// Create a copy of CreatePlayerAnswerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatePlayerAnswerModelImplCopyWith<_$CreatePlayerAnswerModelImpl>
      get copyWith => __$$CreatePlayerAnswerModelImplCopyWithImpl<
          _$CreatePlayerAnswerModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreatePlayerAnswerModelImplToJson(
      this,
    );
  }
}

abstract class _CreatePlayerAnswerModel implements CreatePlayerAnswerModel {
  const factory _CreatePlayerAnswerModel(
          {@JsonKey(name: 'player_id') required final String playerId,
          @JsonKey(name: 'question_id') required final String questionId,
          @JsonKey(name: 'session_id') required final String sessionId,
          @JsonKey(name: 'selected_answer_ids')
          required final List<String> selectedAnswerIds,
          @JsonKey(name: 'is_correct') required final bool isCorrect,
          @JsonKey(name: 'response_time_ms') required final int responseTimeMs,
          @JsonKey(name: 'points_earned') required final int pointsEarned}) =
      _$CreatePlayerAnswerModelImpl;

  factory _CreatePlayerAnswerModel.fromJson(Map<String, dynamic> json) =
      _$CreatePlayerAnswerModelImpl.fromJson;

  @override
  @JsonKey(name: 'player_id')
  String get playerId;
  @override
  @JsonKey(name: 'question_id')
  String get questionId;
  @override
  @JsonKey(name: 'session_id')
  String get sessionId;
  @override
  @JsonKey(name: 'selected_answer_ids')
  List<String> get selectedAnswerIds;
  @override
  @JsonKey(name: 'is_correct')
  bool get isCorrect;
  @override
  @JsonKey(name: 'response_time_ms')
  int get responseTimeMs;
  @override
  @JsonKey(name: 'points_earned')
  int get pointsEarned;

  /// Create a copy of CreatePlayerAnswerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreatePlayerAnswerModelImplCopyWith<_$CreatePlayerAnswerModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
