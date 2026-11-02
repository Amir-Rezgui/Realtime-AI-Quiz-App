import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/quiz_categories.dart';
import '../datasources/supabase_client.dart';

final aiQuizRepositoryProvider = Provider<AiQuizRepository>((ref) {
  return AiQuizRepository(ref.watch(supabaseClientProvider));
});

class AiQuizRepository {
  final SupabaseClient _client;

  AiQuizRepository(this._client);

  Future<GeneratedQuizDraft> generateQuiz({
    required String topic,
    required String difficulty,
    required int questionCount,
    required String language,
    String? additionalInstructions,
  }) async {
    try {
      final accessToken = _client.auth.currentSession?.accessToken;
      if (accessToken == null || accessToken.isEmpty) {
        throw const AiQuizGenerationException(
          'Your session expired. Please sign in again.',
        );
      }

      final response = await _client.functions.invoke(
        'generate-quiz',
        headers: {
          'Authorization': 'Bearer $accessToken',
          'x-client-jwt': accessToken,
        },
        body: {
          'topic': topic,
          'difficulty': difficulty,
          'questionCount': questionCount,
          'language': language,
          if (additionalInstructions != null &&
              additionalInstructions.trim().isNotEmpty)
            'additionalInstructions': additionalInstructions.trim(),
        },
      );

      if (response.status < 200 || response.status >= 300) {
        final message = _extractFunctionErrorMessage(response.data);
        throw AiQuizGenerationException(
          _statusToMessage(response.status, message),
        );
      }

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const AiQuizGenerationException(
          'AI response format is invalid. Please try again.',
        );
      }

      return _parseDraft(data);
    } on AiQuizGenerationException {
      rethrow;
    } on FunctionException catch (e) {
      throw AiQuizGenerationException(
        'AI service is unreachable right now (${e.status ?? 'unknown'}). Please retry.',
      );
    } catch (_) {
      throw const AiQuizGenerationException(
        'Unexpected error while generating the quiz. Please retry in a moment.',
      );
    }
  }

  GeneratedQuizDraft _parseDraft(Map<String, dynamic> json) {
    final rawQuestions = json['questions'];
    if (rawQuestions is! List) {
      throw Exception('AI response is missing questions');
    }

    final parsedQuestions = <GeneratedQuizQuestion>[];
    for (final item in rawQuestions) {
      if (item is! Map<String, dynamic>) continue;

      final rawAnswers = item['answers'];
      if (rawAnswers is! List ||
          rawAnswers.length < AppConstants.minAnswerOptions) {
        continue;
      }

      final answers = <GeneratedQuizAnswer>[];
      for (final answer in rawAnswers) {
        if (answer is! Map<String, dynamic>) continue;

        final answerText = (answer['answerText'] ?? '').toString().trim();
        if (answerText.isEmpty) continue;

        answers.add(
          GeneratedQuizAnswer(
            answerText: answerText,
            isCorrect: answer['isCorrect'] == true,
          ),
        );
      }

      if (answers.length < AppConstants.minAnswerOptions) continue;
      if (!answers.any((a) => a.isCorrect)) continue;

      final questionText = (item['questionText'] ?? '').toString().trim();
      if (questionText.isEmpty) continue;

      final parsedType = _normalizeQuestionType(
        (item['questionType'] ?? '').toString(),
      );

      final points = _boundedInt(
        value: item['points'],
        fallback: AppConstants.defaultPoints,
        min: AppConstants.minPoints,
        max: AppConstants.maxPoints,
      );

      final timeLimit = _boundedInt(
        value: item['timeLimitSeconds'],
        fallback: AppConstants.defaultTimeLimit,
        min: AppConstants.minTimeLimit,
        max: AppConstants.maxTimeLimit,
      );

      if (parsedType == QuestionType.singleChoice) {
        final firstCorrectIndex = answers.indexWhere((a) => a.isCorrect);
        for (var i = 0; i < answers.length; i++) {
          answers[i] = GeneratedQuizAnswer(
            answerText: answers[i].answerText,
            isCorrect: i == firstCorrectIndex,
          );
        }
      }

      parsedQuestions.add(
        GeneratedQuizQuestion(
          questionText: questionText,
          questionType: parsedType,
          points: points,
          timeLimitSeconds: timeLimit,
          answers: answers,
        ),
      );
    }

    if (parsedQuestions.isEmpty) {
      throw Exception('AI did not return usable questions');
    }

    final title = (json['title'] ?? '').toString().trim();
    final description = (json['description'] ?? '').toString().trim();
    final category = _normalizeCategory((json['category'] ?? '').toString());

    return GeneratedQuizDraft(
      title: title.isEmpty ? 'AI Generated Quiz' : title,
      description: description.isEmpty ? null : description,
      category: category,
      questions: parsedQuestions,
    );
  }

  String _normalizeQuestionType(String raw) {
    final _ = raw.trim().toLowerCase();
    return QuestionType.singleChoice;
  }

  String _statusToMessage(int status, String? details) {
    final loweredDetails = details?.toLowerCase() ?? '';
    final isQuotaIssue = loweredDetails.contains('quota') ||
        loweredDetails.contains('resource_exhausted') ||
        loweredDetails.contains('rate limit');

    switch (status) {
      case 400:
        return details ?? 'Invalid generation settings. Please review inputs.';
      case 401:
      case 403:
        return 'Your session expired. Please sign in again.';
      case 429:
        if (isQuotaIssue) {
          return 'AI provider quota is exhausted for the current API project. Use another API key/project or retry later.';
        }
        return 'Too many generation attempts. Please wait and retry.';
      case 500:
      case 502:
      case 503:
        if (isQuotaIssue) {
          return 'AI provider quota is exhausted for the current API project. Use another API key/project or retry later.';
        }
        return 'AI provider is temporarily unavailable. Please retry soon.';
      default:
        return details ?? 'AI generation failed (HTTP $status).';
    }
  }

  String? _extractFunctionErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final providerStatus = data['providerStatus'];
      final providerDetails = (data['details'] ?? '').toString().toLowerCase();
      final isQuotaIssue = providerStatus == 429 ||
          providerDetails.contains('resource_exhausted') ||
          providerDetails.contains('quota exceeded');
      if (isQuotaIssue) {
        return 'AI provider quota is exhausted for the current API project. Use another API key/project or retry later.';
      }

      final error = data['error'];
      if (error is String && error.trim().isNotEmpty) {
        return error.trim();
      }
    }
    return null;
  }

  String _normalizeCategory(String raw) {
    final normalized = raw.trim().toLowerCase();
    final allIds = QuizCategories.all.map((c) => c.id).toSet();
    if (allIds.contains(normalized)) return normalized;

    for (final category in QuizCategories.all) {
      if (category.name.toLowerCase() == normalized) return category.id;
    }

    return QuizCategories.defaultCategory.id;
  }

  int _boundedInt({
    required dynamic value,
    required int fallback,
    required int min,
    required int max,
  }) {
    final parsed = value is int ? value : int.tryParse(value.toString());
    if (parsed == null) return fallback;
    if (parsed < min) return min;
    if (parsed > max) return max;
    return parsed;
  }
}

class GeneratedQuizDraft {
  final String title;
  final String? description;
  final String category;
  final List<GeneratedQuizQuestion> questions;

  const GeneratedQuizDraft({
    required this.title,
    required this.description,
    required this.category,
    required this.questions,
  });
}

class GeneratedQuizQuestion {
  final String questionText;
  final String questionType;
  final int points;
  final int timeLimitSeconds;
  final List<GeneratedQuizAnswer> answers;

  const GeneratedQuizQuestion({
    required this.questionText,
    required this.questionType,
    required this.points,
    required this.timeLimitSeconds,
    required this.answers,
  });
}

class GeneratedQuizAnswer {
  final String answerText;
  final bool isCorrect;

  const GeneratedQuizAnswer({
    required this.answerText,
    required this.isCorrect,
  });
}

class AiQuizGenerationException implements Exception {
  final String message;

  const AiQuizGenerationException(this.message);

  @override
  String toString() => message;
}
