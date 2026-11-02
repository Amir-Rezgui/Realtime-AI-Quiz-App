// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuizModelImpl _$$QuizModelImplFromJson(Map<String, dynamic> json) =>
    _$QuizModelImpl(
      id: json['id'] as String,
      creatorId: json['creator_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      category: json['category'] as String?,
      bannerImageUrl: json['banner_image_url'] as String?,
      isPublished: json['is_published'] as bool? ?? false,
      settings: json['settings'] as Map<String, dynamic>? ?? const {},
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$QuizModelImplToJson(_$QuizModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creator_id': instance.creatorId,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'banner_image_url': instance.bannerImageUrl,
      'is_published': instance.isPublished,
      'settings': instance.settings,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$CreateQuizModelImpl _$$CreateQuizModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateQuizModelImpl(
      title: json['title'] as String,
      description: json['description'] as String?,
      category: json['category'] as String?,
      bannerImageUrl: json['banner_image_url'] as String?,
    );

Map<String, dynamic> _$$CreateQuizModelImplToJson(
        _$CreateQuizModelImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'banner_image_url': instance.bannerImageUrl,
    };
