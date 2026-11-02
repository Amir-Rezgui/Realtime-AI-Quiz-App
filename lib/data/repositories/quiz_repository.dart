import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/supabase_client.dart';
import '../models/quiz_model.dart';
import '../models/question_model.dart';
import '../models/answer_model.dart';
import '../../core/constants/supabase_constants.dart';

final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  return QuizRepository(ref.watch(supabaseClientProvider));
});

class QuizRepository {
  final SupabaseClient _client;

  QuizRepository(this._client);

  Future<List<QuizModel>> getMyQuizzes() async {
    final userId = _client.auth.currentUser?.id;
    print('[QuizRepository] getMyQuizzes - userId: $userId');
    if (userId == null) throw Exception('Not authenticated');

    try {
      final response = await _client
          .from(SupabaseConstants.quizzesTable)
          .select()
          .eq('creator_id', userId)
          .order('updated_at', ascending: false);

      print('[QuizRepository] getMyQuizzes - response: $response');
      final quizzes = <QuizModel>[];

      for (final json in response as List) {
        final quiz = QuizModel.fromJson(json);
        // Fetch question count for each quiz
        final questionCount = await getQuestionCount(quiz.id);
        quizzes.add(quiz.copyWith(questionCount: questionCount));
      }

      print('[QuizRepository] getMyQuizzes - found ${quizzes.length} quizzes');
      return quizzes;
    } catch (e) {
      print('[QuizRepository] getMyQuizzes - ERROR: $e');
      rethrow;
    }
  }

  Future<QuizModel> getQuiz(String quizId) async {
    final response = await _client
        .from(SupabaseConstants.quizzesTable)
        .select()
        .eq('id', quizId)
        .single();

    return QuizModel.fromJson(response);
  }

  Future<QuizModel> getQuizWithQuestions(String quizId) async {
    final quizResponse = await _client
        .from(SupabaseConstants.quizzesTable)
        .select()
        .eq('id', quizId)
        .single();

    final questionsResponse = await _client
        .from(SupabaseConstants.questionsTable)
        .select()
        .eq('quiz_id', quizId)
        .order('order_index');

    final questions = <QuestionModel>[];
    for (final qJson in questionsResponse as List) {
      final answersResponse = await _client
          .from(SupabaseConstants.answersTable)
          .select()
          .eq('question_id', qJson['id'])
          .order('order_index');

      final answers = (answersResponse as List)
          .map((a) => AnswerModel.fromJson(a))
          .toList();

      questions.add(QuestionModel.fromJson(qJson).copyWith(answers: answers));
    }

    return QuizModel.fromJson(quizResponse).copyWith(questions: questions);
  }

  Future<QuizModel> createQuiz(CreateQuizModel quiz) async {
    final userId = _client.auth.currentUser?.id;
    print(
        '[QuizRepository] createQuiz - userId: $userId, title: ${quiz.title}');
    if (userId == null) throw Exception('Not authenticated');

    try {
      final response = await _client
          .from(SupabaseConstants.quizzesTable)
          .insert({
            'creator_id': userId,
            'title': quiz.title,
            'description': quiz.description,
            'category': quiz.category,
            'banner_image_url': quiz.bannerImageUrl,
          })
          .select()
          .single();

      print('[QuizRepository] createQuiz - SUCCESS: $response');
      return QuizModel.fromJson(response);
    } catch (e) {
      print('[QuizRepository] createQuiz - ERROR: $e');
      rethrow;
    }
  }

  Future<QuizModel> updateQuiz(
    String quizId, {
    String? title,
    String? description,
    String? category,
    String? bannerImageUrl,
    bool? isPublished,
  }) async {
    final updates = <String, dynamic>{};
    if (title != null) updates['title'] = title;
    if (description != null) updates['description'] = description;
    if (category != null) updates['category'] = category;
    if (bannerImageUrl != null) updates['banner_image_url'] = bannerImageUrl;
    if (isPublished != null) updates['is_published'] = isPublished;

    final response = await _client
        .from(SupabaseConstants.quizzesTable)
        .update(updates)
        .eq('id', quizId)
        .select()
        .single();

    return QuizModel.fromJson(response);
  }

  Future<void> deleteQuiz(String quizId) async {
    await _client
        .from(SupabaseConstants.quizzesTable)
        .delete()
        .eq('id', quizId);
  }

  // Questions
  Future<QuestionModel> createQuestion(CreateQuestionModel question) async {
    final response = await _client
        .from(SupabaseConstants.questionsTable)
        .insert({
          'quiz_id': question.quizId,
          'order_index': question.orderIndex,
          'question_text': question.questionText,
          'question_type': question.questionType,
          'points': question.points,
          'time_limit_seconds': question.timeLimitSeconds,
        })
        .select()
        .single();

    return QuestionModel.fromJson(response);
  }

  Future<QuestionModel> updateQuestion(
    String questionId, {
    String? questionText,
    String? questionType,
    int? points,
    int? timeLimitSeconds,
  }) async {
    final updates = <String, dynamic>{};
    if (questionText != null) updates['question_text'] = questionText;
    if (questionType != null) updates['question_type'] = questionType;
    if (points != null) updates['points'] = points;
    if (timeLimitSeconds != null)
      updates['time_limit_seconds'] = timeLimitSeconds;

    final response = await _client
        .from(SupabaseConstants.questionsTable)
        .update(updates)
        .eq('id', questionId)
        .select()
        .single();

    return QuestionModel.fromJson(response);
  }

  Future<void> deleteQuestion(String questionId) async {
    await _client
        .from(SupabaseConstants.questionsTable)
        .delete()
        .eq('id', questionId);
  }

  Future<void> reorderQuestions(String quizId, List<String> questionIds) async {
    for (int i = 0; i < questionIds.length; i++) {
      await _client
          .from(SupabaseConstants.questionsTable)
          .update({'order_index': i}).eq('id', questionIds[i]);
    }
  }

  // Answers
  Future<AnswerModel> createAnswer(CreateAnswerModel answer) async {
    final response = await _client
        .from(SupabaseConstants.answersTable)
        .insert({
          'question_id': answer.questionId,
          'order_index': answer.orderIndex,
          'answer_text': answer.answerText,
          'is_correct': answer.isCorrect,
        })
        .select()
        .single();

    return AnswerModel.fromJson(response);
  }

  Future<AnswerModel> updateAnswer(
    String answerId, {
    String? answerText,
    bool? isCorrect,
  }) async {
    final updates = <String, dynamic>{};
    if (answerText != null) updates['answer_text'] = answerText;
    if (isCorrect != null) updates['is_correct'] = isCorrect;

    final response = await _client
        .from(SupabaseConstants.answersTable)
        .update(updates)
        .eq('id', answerId)
        .select()
        .single();

    return AnswerModel.fromJson(response);
  }

  Future<void> deleteAnswer(String answerId) async {
    await _client
        .from(SupabaseConstants.answersTable)
        .delete()
        .eq('id', answerId);
  }

  Future<int> getQuestionCount(String quizId) async {
    final response = await _client
        .from(SupabaseConstants.questionsTable)
        .select('id')
        .eq('quiz_id', quizId);

    return (response as List).length;
  }
}
