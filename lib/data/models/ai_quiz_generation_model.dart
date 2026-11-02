class AiGeneratedQuiz {
  final String title;
  final String description;
  final String category;
  final List<AiGeneratedQuestion> questions;

  const AiGeneratedQuiz({
    required this.title,
    required this.description,
    required this.category,
    required this.questions,
  });

  factory AiGeneratedQuiz.fromJson(Map<String, dynamic> json) {
    final questionsRaw = json['questions'];
    final questions = questionsRaw is List
        ? questionsRaw
            .whereType<Map<String, dynamic>>()
            .map(AiGeneratedQuestion.fromJson)
            .toList()
        : <AiGeneratedQuestion>[];
    return AiGeneratedQuiz(
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      questions: questions,
    );
  }
}

class AiGeneratedQuestion {
  final String questionText;
  final String questionType;
  final int points;
  final int timeLimitSeconds;
  final List<AiGeneratedAnswer> answers;

  const AiGeneratedQuestion({
    required this.questionText,
    required this.questionType,
    required this.points,
    required this.timeLimitSeconds,
    required this.answers,
  });

  factory AiGeneratedQuestion.fromJson(Map<String, dynamic> json) {
    final answersRaw = json['answers'];
    final answers = answersRaw is List
        ? answersRaw
            .whereType<Map<String, dynamic>>()
            .map(AiGeneratedAnswer.fromJson)
            .toList()
        : <AiGeneratedAnswer>[];
    return AiGeneratedQuestion(
      questionText: (json['question_text'] ?? '').toString(),
      questionType: (json['question_type'] ?? 'single_choice').toString(),
      points: (json['points'] as num?)?.toInt() ?? 1000,
      timeLimitSeconds: (json['time_limit_seconds'] as num?)?.toInt() ?? 20,
      answers: answers,
    );
  }
}

class AiGeneratedAnswer {
  final String answerText;
  final bool isCorrect;

  const AiGeneratedAnswer({
    required this.answerText,
    required this.isCorrect,
  });

  factory AiGeneratedAnswer.fromJson(Map<String, dynamic> json) {
    return AiGeneratedAnswer(
      answerText: (json['answer_text'] ?? '').toString(),
      isCorrect: json['is_correct'] == true,
    );
  }
}
