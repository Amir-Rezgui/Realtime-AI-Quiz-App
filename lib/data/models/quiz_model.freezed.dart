// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuizModel _$QuizModelFromJson(Map<String, dynamic> json) {
  return _QuizModel.fromJson(json);
}

/// @nodoc
mixin _$QuizModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'creator_id')
  String get creatorId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'banner_image_url')
  String? get bannerImageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_published')
  bool get isPublished => throw _privateConstructorUsedError;
  Map<String, dynamic> get settings => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<QuestionModel> get questions => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  int get questionCount => throw _privateConstructorUsedError;

  /// Serializes this QuizModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizModelCopyWith<QuizModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizModelCopyWith<$Res> {
  factory $QuizModelCopyWith(QuizModel value, $Res Function(QuizModel) then) =
      _$QuizModelCopyWithImpl<$Res, QuizModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'creator_id') String creatorId,
      String title,
      String? description,
      String? category,
      @JsonKey(name: 'banner_image_url') String? bannerImageUrl,
      @JsonKey(name: 'is_published') bool isPublished,
      Map<String, dynamic> settings,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      List<QuestionModel> questions,
      @JsonKey(includeFromJson: false, includeToJson: false)
      int questionCount});
}

/// @nodoc
class _$QuizModelCopyWithImpl<$Res, $Val extends QuizModel>
    implements $QuizModelCopyWith<$Res> {
  _$QuizModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? creatorId = null,
    Object? title = null,
    Object? description = freezed,
    Object? category = freezed,
    Object? bannerImageUrl = freezed,
    Object? isPublished = null,
    Object? settings = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? questions = null,
    Object? questionCount = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      creatorId: null == creatorId
          ? _value.creatorId
          : creatorId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      bannerImageUrl: freezed == bannerImageUrl
          ? _value.bannerImageUrl
          : bannerImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isPublished: null == isPublished
          ? _value.isPublished
          : isPublished // ignore: cast_nullable_to_non_nullable
              as bool,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      questions: null == questions
          ? _value.questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<QuestionModel>,
      questionCount: null == questionCount
          ? _value.questionCount
          : questionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuizModelImplCopyWith<$Res>
    implements $QuizModelCopyWith<$Res> {
  factory _$$QuizModelImplCopyWith(
          _$QuizModelImpl value, $Res Function(_$QuizModelImpl) then) =
      __$$QuizModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'creator_id') String creatorId,
      String title,
      String? description,
      String? category,
      @JsonKey(name: 'banner_image_url') String? bannerImageUrl,
      @JsonKey(name: 'is_published') bool isPublished,
      Map<String, dynamic> settings,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      List<QuestionModel> questions,
      @JsonKey(includeFromJson: false, includeToJson: false)
      int questionCount});
}

/// @nodoc
class __$$QuizModelImplCopyWithImpl<$Res>
    extends _$QuizModelCopyWithImpl<$Res, _$QuizModelImpl>
    implements _$$QuizModelImplCopyWith<$Res> {
  __$$QuizModelImplCopyWithImpl(
      _$QuizModelImpl _value, $Res Function(_$QuizModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuizModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? creatorId = null,
    Object? title = null,
    Object? description = freezed,
    Object? category = freezed,
    Object? bannerImageUrl = freezed,
    Object? isPublished = null,
    Object? settings = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? questions = null,
    Object? questionCount = null,
  }) {
    return _then(_$QuizModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      creatorId: null == creatorId
          ? _value.creatorId
          : creatorId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      bannerImageUrl: freezed == bannerImageUrl
          ? _value.bannerImageUrl
          : bannerImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isPublished: null == isPublished
          ? _value.isPublished
          : isPublished // ignore: cast_nullable_to_non_nullable
              as bool,
      settings: null == settings
          ? _value._settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      questions: null == questions
          ? _value._questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<QuestionModel>,
      questionCount: null == questionCount
          ? _value.questionCount
          : questionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizModelImpl implements _QuizModel {
  const _$QuizModelImpl(
      {required this.id,
      @JsonKey(name: 'creator_id') required this.creatorId,
      required this.title,
      this.description,
      this.category,
      @JsonKey(name: 'banner_image_url') this.bannerImageUrl,
      @JsonKey(name: 'is_published') this.isPublished = false,
      final Map<String, dynamic> settings = const {},
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final List<QuestionModel> questions = const [],
      @JsonKey(includeFromJson: false, includeToJson: false)
      this.questionCount = 0})
      : _settings = settings,
        _questions = questions;

  factory _$QuizModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'creator_id')
  final String creatorId;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String? category;
  @override
  @JsonKey(name: 'banner_image_url')
  final String? bannerImageUrl;
  @override
  @JsonKey(name: 'is_published')
  final bool isPublished;
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
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  final List<QuestionModel> _questions;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<QuestionModel> get questions {
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final int questionCount;

  @override
  String toString() {
    return 'QuizModel(id: $id, creatorId: $creatorId, title: $title, description: $description, category: $category, bannerImageUrl: $bannerImageUrl, isPublished: $isPublished, settings: $settings, createdAt: $createdAt, updatedAt: $updatedAt, questions: $questions, questionCount: $questionCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.creatorId, creatorId) ||
                other.creatorId == creatorId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.bannerImageUrl, bannerImageUrl) ||
                other.bannerImageUrl == bannerImageUrl) &&
            (identical(other.isPublished, isPublished) ||
                other.isPublished == isPublished) &&
            const DeepCollectionEquality().equals(other._settings, _settings) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._questions, _questions) &&
            (identical(other.questionCount, questionCount) ||
                other.questionCount == questionCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      creatorId,
      title,
      description,
      category,
      bannerImageUrl,
      isPublished,
      const DeepCollectionEquality().hash(_settings),
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_questions),
      questionCount);

  /// Create a copy of QuizModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizModelImplCopyWith<_$QuizModelImpl> get copyWith =>
      __$$QuizModelImplCopyWithImpl<_$QuizModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizModelImplToJson(
      this,
    );
  }
}

abstract class _QuizModel implements QuizModel {
  const factory _QuizModel(
      {required final String id,
      @JsonKey(name: 'creator_id') required final String creatorId,
      required final String title,
      final String? description,
      final String? category,
      @JsonKey(name: 'banner_image_url') final String? bannerImageUrl,
      @JsonKey(name: 'is_published') final bool isPublished,
      final Map<String, dynamic> settings,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final List<QuestionModel> questions,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final int questionCount}) = _$QuizModelImpl;

  factory _QuizModel.fromJson(Map<String, dynamic> json) =
      _$QuizModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'creator_id')
  String get creatorId;
  @override
  String get title;
  @override
  String? get description;
  @override
  String? get category;
  @override
  @JsonKey(name: 'banner_image_url')
  String? get bannerImageUrl;
  @override
  @JsonKey(name: 'is_published')
  bool get isPublished;
  @override
  Map<String, dynamic> get settings;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<QuestionModel> get questions;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  int get questionCount;

  /// Create a copy of QuizModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizModelImplCopyWith<_$QuizModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateQuizModel _$CreateQuizModelFromJson(Map<String, dynamic> json) {
  return _CreateQuizModel.fromJson(json);
}

/// @nodoc
mixin _$CreateQuizModel {
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'banner_image_url')
  String? get bannerImageUrl => throw _privateConstructorUsedError;

  /// Serializes this CreateQuizModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateQuizModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateQuizModelCopyWith<CreateQuizModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateQuizModelCopyWith<$Res> {
  factory $CreateQuizModelCopyWith(
          CreateQuizModel value, $Res Function(CreateQuizModel) then) =
      _$CreateQuizModelCopyWithImpl<$Res, CreateQuizModel>;
  @useResult
  $Res call(
      {String title,
      String? description,
      String? category,
      @JsonKey(name: 'banner_image_url') String? bannerImageUrl});
}

/// @nodoc
class _$CreateQuizModelCopyWithImpl<$Res, $Val extends CreateQuizModel>
    implements $CreateQuizModelCopyWith<$Res> {
  _$CreateQuizModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateQuizModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = freezed,
    Object? category = freezed,
    Object? bannerImageUrl = freezed,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      bannerImageUrl: freezed == bannerImageUrl
          ? _value.bannerImageUrl
          : bannerImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateQuizModelImplCopyWith<$Res>
    implements $CreateQuizModelCopyWith<$Res> {
  factory _$$CreateQuizModelImplCopyWith(_$CreateQuizModelImpl value,
          $Res Function(_$CreateQuizModelImpl) then) =
      __$$CreateQuizModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String? description,
      String? category,
      @JsonKey(name: 'banner_image_url') String? bannerImageUrl});
}

/// @nodoc
class __$$CreateQuizModelImplCopyWithImpl<$Res>
    extends _$CreateQuizModelCopyWithImpl<$Res, _$CreateQuizModelImpl>
    implements _$$CreateQuizModelImplCopyWith<$Res> {
  __$$CreateQuizModelImplCopyWithImpl(
      _$CreateQuizModelImpl _value, $Res Function(_$CreateQuizModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateQuizModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = freezed,
    Object? category = freezed,
    Object? bannerImageUrl = freezed,
  }) {
    return _then(_$CreateQuizModelImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      bannerImageUrl: freezed == bannerImageUrl
          ? _value.bannerImageUrl
          : bannerImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateQuizModelImpl implements _CreateQuizModel {
  const _$CreateQuizModelImpl(
      {required this.title,
      this.description,
      this.category,
      @JsonKey(name: 'banner_image_url') this.bannerImageUrl});

  factory _$CreateQuizModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateQuizModelImplFromJson(json);

  @override
  final String title;
  @override
  final String? description;
  @override
  final String? category;
  @override
  @JsonKey(name: 'banner_image_url')
  final String? bannerImageUrl;

  @override
  String toString() {
    return 'CreateQuizModel(title: $title, description: $description, category: $category, bannerImageUrl: $bannerImageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateQuizModelImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.bannerImageUrl, bannerImageUrl) ||
                other.bannerImageUrl == bannerImageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, title, description, category, bannerImageUrl);

  /// Create a copy of CreateQuizModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateQuizModelImplCopyWith<_$CreateQuizModelImpl> get copyWith =>
      __$$CreateQuizModelImplCopyWithImpl<_$CreateQuizModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateQuizModelImplToJson(
      this,
    );
  }
}

abstract class _CreateQuizModel implements CreateQuizModel {
  const factory _CreateQuizModel(
          {required final String title,
          final String? description,
          final String? category,
          @JsonKey(name: 'banner_image_url') final String? bannerImageUrl}) =
      _$CreateQuizModelImpl;

  factory _CreateQuizModel.fromJson(Map<String, dynamic> json) =
      _$CreateQuizModelImpl.fromJson;

  @override
  String get title;
  @override
  String? get description;
  @override
  String? get category;
  @override
  @JsonKey(name: 'banner_image_url')
  String? get bannerImageUrl;

  /// Create a copy of CreateQuizModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateQuizModelImplCopyWith<_$CreateQuizModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
