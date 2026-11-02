import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/quiz_repository.dart';
import '../../data/models/quiz_model.dart';
import '../../data/models/question_model.dart';
import '../../data/models/answer_model.dart';

// My quizzes provider
final myQuizzesProvider = FutureProvider<List<QuizModel>>((ref) async {
  final repository = ref.watch(quizRepositoryProvider);
  return repository.getMyQuizzes();
});

// Single quiz provider
final quizProvider = FutureProvider.family<QuizModel, String>((
  ref,
  quizId,
) async {
  final repository = ref.watch(quizRepositoryProvider);
  return repository.getQuizWithQuestions(quizId);
});

// Quiz editor notifier
final quizEditorProvider =
    StateNotifierProvider.autoDispose<QuizEditorNotifier, QuizEditorState>((
      ref,
    ) {
      return QuizEditorNotifier(ref.watch(quizRepositoryProvider));
    });

class QuizEditorState {
  final bool isLoading;
  final bool isSaving;
  final String? error;
  final QuizModel? quiz;

  const QuizEditorState({
    this.isLoading = false,
    this.isSaving = false,
    this.error,
    this.quiz,
  });

  QuizEditorState copyWith({
    bool? isLoading,
    bool? isSaving,
    String? error,
    QuizModel? quiz,
  }) {
    return QuizEditorState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
      quiz: quiz ?? this.quiz,
    );
  }
}

class QuizEditorNotifier extends StateNotifier<QuizEditorState> {
  final QuizRepository _repository;

  QuizEditorNotifier(this._repository) : super(const QuizEditorState());

  Future<void> loadQuiz(String quizId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final quiz = await _repository.getQuizWithQuestions(quizId);
      state = state.copyWith(isLoading: false, quiz: quiz);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<QuizModel?> createQuiz({
    required String title,
    String? description,
  }) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final quiz = await _repository.createQuiz(
        CreateQuizModel(title: title, description: description),
      );
      state = state.copyWith(isSaving: false, quiz: quiz);
      return quiz;
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      return null;
    }
  }

  Future<void> updateQuiz({
    String? title,
    String? description,
    bool? isPublished,
  }) async {
    if (state.quiz == null) return;

    state = state.copyWith(isSaving: true, error: null);

    try {
      final updated = await _repository.updateQuiz(
        state.quiz!.id,
        title: title,
        description: description,
        isPublished: isPublished,
      );
      state = state.copyWith(
        isSaving: false,
        quiz: state.quiz!.copyWith(
          title: updated.title,
          description: updated.description,
          isPublished: updated.isPublished,
        ),
      );
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
    }
  }

  Future<QuestionModel?> addQuestion({
    required String questionText,
    String questionType = 'single_choice',
    int points = 1000,
    int timeLimitSeconds = 20,
  }) async {
    if (state.quiz == null) return null;

    state = state.copyWith(isSaving: true, error: null);

    try {
      final orderIndex = state.quiz!.questions.length;
      final question = await _repository.createQuestion(
        CreateQuestionModel(
          quizId: state.quiz!.id,
          orderIndex: orderIndex,
          questionText: questionText,
          questionType: questionType,
          points: points,
          timeLimitSeconds: timeLimitSeconds,
        ),
      );

      final updatedQuestions = [...state.quiz!.questions, question];
      state = state.copyWith(
        isSaving: false,
        quiz: state.quiz!.copyWith(questions: updatedQuestions),
      );
      return question;
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      return null;
    }
  }

  Future<void> updateQuestion(
    String questionId, {
    String? questionText,
    String? questionType,
    int? points,
    int? timeLimitSeconds,
  }) async {
    if (state.quiz == null) return;

    state = state.copyWith(isSaving: true, error: null);

    try {
      final updated = await _repository.updateQuestion(
        questionId,
        questionText: questionText,
        questionType: questionType,
        points: points,
        timeLimitSeconds: timeLimitSeconds,
      );

      final questions = state.quiz!.questions.map((q) {
        if (q.id == questionId) {
          return q.copyWith(
            questionText: updated.questionText,
            questionType: updated.questionType,
            points: updated.points,
            timeLimitSeconds: updated.timeLimitSeconds,
          );
        }
        return q;
      }).toList();

      state = state.copyWith(
        isSaving: false,
        quiz: state.quiz!.copyWith(questions: questions),
      );
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
    }
  }

  Future<void> deleteQuestion(String questionId) async {
    if (state.quiz == null) return;

    state = state.copyWith(isSaving: true, error: null);

    try {
      await _repository.deleteQuestion(questionId);

      final questions = state.quiz!.questions
          .where((q) => q.id != questionId)
          .toList();

      state = state.copyWith(
        isSaving: false,
        quiz: state.quiz!.copyWith(questions: questions),
      );
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
    }
  }

  Future<AnswerModel?> addAnswer(
    String questionId, {
    required String answerText,
    bool isCorrect = false,
  }) async {
    if (state.quiz == null) return null;

    state = state.copyWith(isSaving: true, error: null);

    try {
      final question = state.quiz!.questions.firstWhere(
        (q) => q.id == questionId,
      );
      final orderIndex = question.answers.length;

      final answer = await _repository.createAnswer(
        CreateAnswerModel(
          questionId: questionId,
          orderIndex: orderIndex,
          answerText: answerText,
          isCorrect: isCorrect,
        ),
      );

      final questions = state.quiz!.questions.map((q) {
        if (q.id == questionId) {
          return q.copyWith(answers: [...q.answers, answer]);
        }
        return q;
      }).toList();

      state = state.copyWith(
        isSaving: false,
        quiz: state.quiz!.copyWith(questions: questions),
      );
      return answer;
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      return null;
    }
  }

  Future<void> updateAnswer(
    String questionId,
    String answerId, {
    String? answerText,
    bool? isCorrect,
  }) async {
    if (state.quiz == null) return;

    state = state.copyWith(isSaving: true, error: null);

    try {
      final updated = await _repository.updateAnswer(
        answerId,
        answerText: answerText,
        isCorrect: isCorrect,
      );

      final questions = state.quiz!.questions.map((q) {
        if (q.id == questionId) {
          final answers = q.answers.map((a) {
            if (a.id == answerId) {
              return a.copyWith(
                answerText: updated.answerText,
                isCorrect: updated.isCorrect,
              );
            }
            return a;
          }).toList();
          return q.copyWith(answers: answers);
        }
        return q;
      }).toList();

      state = state.copyWith(
        isSaving: false,
        quiz: state.quiz!.copyWith(questions: questions),
      );
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
    }
  }

  Future<void> deleteAnswer(String questionId, String answerId) async {
    if (state.quiz == null) return;

    state = state.copyWith(isSaving: true, error: null);

    try {
      await _repository.deleteAnswer(answerId);

      final questions = state.quiz!.questions.map((q) {
        if (q.id == questionId) {
          final answers = q.answers.where((a) => a.id != answerId).toList();
          return q.copyWith(answers: answers);
        }
        return q;
      }).toList();

      state = state.copyWith(
        isSaving: false,
        quiz: state.quiz!.copyWith(questions: questions),
      );
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
