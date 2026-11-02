// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuestionModel _$QuestionModelFromJson(Map<String, dynamic> json) {
  return _QuestionModel.fromJson(json);
}

/// @nodoc
mixin _$QuestionModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'quiz_id')
  String get quizId => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_index')
  int get orderIndex => throw _privateConstructorUsedError;
  @JsonKey(name: 'question_text')
  String get questionText => throw _privateConstructorUsedError;
  @JsonKey(name: 'question_type')
  String get questionType => throw _privateConstructorUsedError;
  int get points => throw _privateConstructorUsedError;
  @JsonKey(name: 'time_limit_seconds')
  int get timeLimitSeconds => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<AnswerModel> get answers => throw _privateConstructorUsedError;

  /// Serializes this QuestionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuestionModelCopyWith<QuestionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionModelCopyWith<$Res> {
  factory $QuestionModelCopyWith(
          QuestionModel value, $Res Function(QuestionModel) then) =
      _$QuestionModelCopyWithImpl<$Res, QuestionModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'quiz_id') String quizId,
      @JsonKey(name: 'order_index') int orderIndex,
      @JsonKey(name: 'question_text') String questionText,
      @JsonKey(name: 'question_type') String questionType,
      int points,
      @JsonKey(name: 'time_limit_seconds') int timeLimitSeconds,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      List<AnswerModel> answers});
}

/// @nodoc
class _$QuestionModelCopyWithImpl<$Res, $Val extends QuestionModel>
    implements $QuestionModelCopyWith<$Res> {
  _$QuestionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quizId = null,
    Object? orderIndex = null,
    Object? questionText = null,
    Object? questionType = null,
    Object? points = null,
    Object? timeLimitSeconds = null,
    Object? createdAt = freezed,
    Object? answers = null,
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
      orderIndex: null == orderIndex
          ? _value.orderIndex
          : orderIndex // ignore: cast_nullable_to_non_nullable
              as int,
      questionText: null == questionText
          ? _value.questionText
          : questionText // ignore: cast_nullable_to_non_nullable
              as String,
      questionType: null == questionType
          ? _value.questionType
          : questionType // ignore: cast_nullable_to_non_nullable
              as String,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      timeLimitSeconds: null == timeLimitSeconds
          ? _value.timeLimitSeconds
          : timeLimitSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      answers: null == answers
          ? _value.answers
          : answers // ignore: cast_nullable_to_non_nullable
              as List<AnswerModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuestionModelImplCopyWith<$Res>
    implements $QuestionModelCopyWith<$Res> {
  factory _$$QuestionModelImplCopyWith(
          _$QuestionModelImpl value, $Res Function(_$QuestionModelImpl) then) =
      __$$QuestionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'quiz_id') String quizId,
      @JsonKey(name: 'order_index') int orderIndex,
      @JsonKey(name: 'question_text') String questionText,
      @JsonKey(name: 'question_type') String questionType,
      int points,
      @JsonKey(name: 'time_limit_seconds') int timeLimitSeconds,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      List<AnswerModel> answers});
}

/// @nodoc
class __$$QuestionModelImplCopyWithImpl<$Res>
    extends _$QuestionModelCopyWithImpl<$Res, _$QuestionModelImpl>
    implements _$$QuestionModelImplCopyWith<$Res> {
  __$$QuestionModelImplCopyWithImpl(
      _$QuestionModelImpl _value, $Res Function(_$QuestionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quizId = null,
    Object? orderIndex = null,
    Object? questionText = null,
    Object? questionType = null,
    Object? points = null,
    Object? timeLimitSeconds = null,
    Object? createdAt = freezed,
    Object? answers = null,
  }) {
    return _then(_$QuestionModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      quizId: null == quizId
          ? _value.quizId
          : quizId // ignore: cast_nullable_to_non_nullable
              as String,
      orderIndex: null == orderIndex
          ? _value.orderIndex
          : orderIndex // ignore: cast_nullable_to_non_nullable
              as int,
      questionText: null == questionText
          ? _value.questionText
          : questionText // ignore: cast_nullable_to_non_nullable
              as String,
      questionType: null == questionType
          ? _value.questionType
          : questionType // ignore: cast_nullable_to_non_nullable
              as String,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      timeLimitSeconds: null == timeLimitSeconds
          ? _value.timeLimitSeconds
          : timeLimitSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      answers: null == answers
          ? _value._answers
          : answers // ignore: cast_nullable_to_non_nullable
              as List<AnswerModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionModelImpl implements _QuestionModel {
  const _$QuestionModelImpl(
      {required this.id,
      @JsonKey(name: 'quiz_id') required this.quizId,
      @JsonKey(name: 'order_index') required this.orderIndex,
      @JsonKey(name: 'question_text') required this.questionText,
      @JsonKey(name: 'question_type') this.questionType = 'single_choice',
      this.points = 1000,
      @JsonKey(name: 'time_limit_seconds') this.timeLimitSeconds = 20,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final List<AnswerModel> answers = const []})
      : _answers = answers;

  factory _$QuestionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'quiz_id')
  final String quizId;
  @override
  @JsonKey(name: 'order_index')
  final int orderIndex;
  @override
  @JsonKey(name: 'question_text')
  final String questionText;
  @override
  @JsonKey(name: 'question_type')
  final String questionType;
  @override
  @JsonKey()
  final int points;
  @override
  @JsonKey(name: 'time_limit_seconds')
  final int timeLimitSeconds;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  final List<AnswerModel> _answers;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<AnswerModel> get answers {
    if (_answers is EqualUnmodifiableListView) return _answers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_answers);
  }

  @override
  String toString() {
    return 'QuestionModel(id: $id, quizId: $quizId, orderIndex: $orderIndex, questionText: $questionText, questionType: $questionType, points: $points, timeLimitSeconds: $timeLimitSeconds, createdAt: $createdAt, answers: $answers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quizId, quizId) || other.quizId == quizId) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex) &&
            (identical(other.questionText, questionText) ||
                other.questionText == questionText) &&
            (identical(other.questionType, questionType) ||
                other.questionType == questionType) &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.timeLimitSeconds, timeLimitSeconds) ||
                other.timeLimitSeconds == timeLimitSeconds) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._answers, _answers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      quizId,
      orderIndex,
      questionText,
      questionType,
      points,
      timeLimitSeconds,
      createdAt,
      const DeepCollectionEquality().hash(_answers));

  /// Create a copy of QuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionModelImplCopyWith<_$QuestionModelImpl> get copyWith =>
      __$$QuestionModelImplCopyWithImpl<_$QuestionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionModelImplToJson(
      this,
    );
  }
}

abstract class _QuestionModel implements QuestionModel {
  const factory _QuestionModel(
      {required final String id,
      @JsonKey(name: 'quiz_id') required final String quizId,
      @JsonKey(name: 'order_index') required final int orderIndex,
      @JsonKey(name: 'question_text') required final String questionText,
      @JsonKey(name: 'question_type') final String questionType,
      final int points,
      @JsonKey(name: 'time_limit_seconds') final int timeLimitSeconds,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final List<AnswerModel> answers}) = _$QuestionModelImpl;

  factory _QuestionModel.fromJson(Map<String, dynamic> json) =
      _$QuestionModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'quiz_id')
  String get quizId;
  @override
  @JsonKey(name: 'order_index')
  int get orderIndex;
  @override
  @JsonKey(name: 'question_text')
  String get questionText;
  @override
  @JsonKey(name: 'question_type')
  String get questionType;
  @override
  int get points;
  @override
  @JsonKey(name: 'time_limit_seconds')
  int get timeLimitSeconds;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<AnswerModel> get answers;

  /// Create a copy of QuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuestionModelImplCopyWith<_$QuestionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateQuestionModel _$CreateQuestionModelFromJson(Map<String, dynamic> json) {
  return _CreateQuestionModel.fromJson(json);
}

/// @nodoc
mixin _$CreateQuestionModel {
  @JsonKey(name: 'quiz_id')
  String get quizId => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_index')
  int get orderIndex => throw _privateConstructorUsedError;
  @JsonKey(name: 'question_text')
  String get questionText => throw _privateConstructorUsedError;
  @JsonKey(name: 'question_type')
  String get questionType => throw _privateConstructorUsedError;
  int get points => throw _privateConstructorUsedError;
  @JsonKey(name: 'time_limit_seconds')
  int get timeLimitSeconds => throw _privateConstructorUsedError;

  /// Serializes this CreateQuestionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateQuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateQuestionModelCopyWith<CreateQuestionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateQuestionModelCopyWith<$Res> {
  factory $CreateQuestionModelCopyWith(
          CreateQuestionModel value, $Res Function(CreateQuestionModel) then) =
      _$CreateQuestionModelCopyWithImpl<$Res, CreateQuestionModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'quiz_id') String quizId,
      @JsonKey(name: 'order_index') int orderIndex,
      @JsonKey(name: 'question_text') String questionText,
      @JsonKey(name: 'question_type') String questionType,
      int points,
      @JsonKey(name: 'time_limit_seconds') int timeLimitSeconds});
}

/// @nodoc
class _$CreateQuestionModelCopyWithImpl<$Res, $Val extends CreateQuestionModel>
    implements $CreateQuestionModelCopyWith<$Res> {
  _$CreateQuestionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateQuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? quizId = null,
    Object? orderIndex = null,
    Object? questionText = null,
    Object? questionType = null,
    Object? points = null,
    Object? timeLimitSeconds = null,
  }) {
    return _then(_value.copyWith(
      quizId: null == quizId
          ? _value.quizId
          : quizId // ignore: cast_nullable_to_non_nullable
              as String,
      orderIndex: null == orderIndex
          ? _value.orderIndex
          : orderIndex // ignore: cast_nullable_to_non_nullable
              as int,
      questionText: null == questionText
          ? _value.questionText
          : questionText // ignore: cast_nullable_to_non_nullable
              as String,
      questionType: null == questionType
          ? _value.questionType
          : questionType // ignore: cast_nullable_to_non_nullable
              as String,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      timeLimitSeconds: null == timeLimitSeconds
          ? _value.timeLimitSeconds
          : timeLimitSeconds // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateQuestionModelImplCopyWith<$Res>
    implements $CreateQuestionModelCopyWith<$Res> {
  factory _$$CreateQuestionModelImplCopyWith(_$CreateQuestionModelImpl value,
          $Res Function(_$CreateQuestionModelImpl) then) =
      __$$CreateQuestionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'quiz_id') String quizId,
      @JsonKey(name: 'order_index') int orderIndex,
      @JsonKey(name: 'question_text') String questionText,
      @JsonKey(name: 'question_type') String questionType,
      int points,
      @JsonKey(name: 'time_limit_seconds') int timeLimitSeconds});
}

/// @nodoc
class __$$CreateQuestionModelImplCopyWithImpl<$Res>
    extends _$CreateQuestionModelCopyWithImpl<$Res, _$CreateQuestionModelImpl>
    implements _$$CreateQuestionModelImplCopyWith<$Res> {
  __$$CreateQuestionModelImplCopyWithImpl(_$CreateQuestionModelImpl _value,
      $Res Function(_$CreateQuestionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateQuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? quizId = null,
    Object? orderIndex = null,
    Object? questionText = null,
    Object? questionType = null,
    Object? points = null,
    Object? timeLimitSeconds = null,
  }) {
    return _then(_$CreateQuestionModelImpl(
      quizId: null == quizId
          ? _value.quizId
          : quizId // ignore: cast_nullable_to_non_nullable
              as String,
      orderIndex: null == orderIndex
          ? _value.orderIndex
          : orderIndex // ignore: cast_nullable_to_non_nullable
              as int,
      questionText: null == questionText
          ? _value.questionText
          : questionText // ignore: cast_nullable_to_non_nullable
              as String,
      questionType: null == questionType
          ? _value.questionType
          : questionType // ignore: cast_nullable_to_non_nullable
              as String,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      timeLimitSeconds: null == timeLimitSeconds
          ? _value.timeLimitSeconds
          : timeLimitSeconds // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateQuestionModelImpl implements _CreateQuestionModel {
  const _$CreateQuestionModelImpl(
      {@JsonKey(name: 'quiz_id') required this.quizId,
      @JsonKey(name: 'order_index') required this.orderIndex,
      @JsonKey(name: 'question_text') required this.questionText,
      @JsonKey(name: 'question_type') this.questionType = 'single_choice',
      this.points = 1000,
      @JsonKey(name: 'time_limit_seconds') this.timeLimitSeconds = 20});

  factory _$CreateQuestionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateQuestionModelImplFromJson(json);

  @override
  @JsonKey(name: 'quiz_id')
  final String quizId;
  @override
  @JsonKey(name: 'order_index')
  final int orderIndex;
  @override
  @JsonKey(name: 'question_text')
  final String questionText;
  @override
  @JsonKey(name: 'question_type')
  final String questionType;
  @override
  @JsonKey()
  final int points;
  @override
  @JsonKey(name: 'time_limit_seconds')
  final int timeLimitSeconds;

  @override
  String toString() {
    return 'CreateQuestionModel(quizId: $quizId, orderIndex: $orderIndex, questionText: $questionText, questionType: $questionType, points: $points, timeLimitSeconds: $timeLimitSeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateQuestionModelImpl &&
            (identical(other.quizId, quizId) || other.quizId == quizId) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex) &&
            (identical(other.questionText, questionText) ||
                other.questionText == questionText) &&
            (identical(other.questionType, questionType) ||
                other.questionType == questionType) &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.timeLimitSeconds, timeLimitSeconds) ||
                other.timeLimitSeconds == timeLimitSeconds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, quizId, orderIndex, questionText,
      questionType, points, timeLimitSeconds);

  /// Create a copy of CreateQuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateQuestionModelImplCopyWith<_$CreateQuestionModelImpl> get copyWith =>
      __$$CreateQuestionModelImplCopyWithImpl<_$CreateQuestionModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateQuestionModelImplToJson(
      this,
    );
  }
}

abstract class _CreateQuestionModel implements CreateQuestionModel {
  const factory _CreateQuestionModel(
          {@JsonKey(name: 'quiz_id') required final String quizId,
          @JsonKey(name: 'order_index') required final int orderIndex,
          @JsonKey(name: 'question_text') required final String questionText,
          @JsonKey(name: 'question_type') final String questionType,
          final int points,
          @JsonKey(name: 'time_limit_seconds') final int timeLimitSeconds}) =
      _$CreateQuestionModelImpl;

  factory _CreateQuestionModel.fromJson(Map<String, dynamic> json) =
      _$CreateQuestionModelImpl.fromJson;

  @override
  @JsonKey(name: 'quiz_id')
  String get quizId;
  @override
  @JsonKey(name: 'order_index')
  int get orderIndex;
  @override
  @JsonKey(name: 'question_text')
  String get questionText;
  @override
  @JsonKey(name: 'question_type')
  String get questionType;
  @override
  int get points;
  @override
  @JsonKey(name: 'time_limit_seconds')
  int get timeLimitSeconds;

  /// Create a copy of CreateQuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateQuestionModelImplCopyWith<_$CreateQuestionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
