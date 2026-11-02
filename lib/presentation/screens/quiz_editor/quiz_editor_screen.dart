import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/quiz_provider.dart';
import '../../../data/repositories/ai_quiz_repository.dart';
import '../../../data/repositories/quiz_repository.dart';
import '../../../data/models/quiz_model.dart';
import '../../../data/models/question_model.dart';
import '../../../data/models/answer_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/quiz_categories.dart';

class QuizEditorScreen extends ConsumerStatefulWidget {
  final String? quizId;

  const QuizEditorScreen({super.key, this.quizId});

  @override
  ConsumerState<QuizEditorScreen> createState() => _QuizEditorScreenState();
}

class _QuizEditorScreenState extends ConsumerState<QuizEditorScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _bannerImageUrlController = TextEditingController();
  final List<_QuestionData> _questions = [];
  String? _selectedCategory;
  bool _isNew = true;
  bool _isSaving = false;
  bool _isLoading = false;
  bool _isGeneratingWithAi = false;

  @override
  void initState() {
    super.initState();
    _isNew = widget.quizId == null || widget.quizId == 'new';

    if (_isNew) {
      // Start with one empty question
      _addEmptyQuestion();
    } else {
      _loadExistingQuiz();
    }
  }

  Future<void> _loadExistingQuiz() async {
    setState(() => _isLoading = true);

    try {
      // Use repository directly to avoid autoDispose issues
      final repository = ref.read(quizRepositoryProvider);
      final quiz = await repository.getQuizWithQuestions(widget.quizId!);

      if (mounted) {
        _titleController.text = quiz.title;
        _descriptionController.text = quiz.description ?? '';
        _bannerImageUrlController.text = quiz.bannerImageUrl ?? '';
        _selectedCategory = quiz.category;

        _questions.clear();
        for (final question in quiz.questions) {
          final sortedAnswers = [...question.answers]
            ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
          final questionData = _QuestionData(
            id: question.id,
            questionController:
                TextEditingController(text: question.questionText),
            questionType: question.questionType,
            points: question.points,
            timeLimit: question.timeLimitSeconds,
          );

          for (final answer in sortedAnswers) {
            questionData.answers.add(_AnswerData(
              id: answer.id,
              controller: TextEditingController(text: answer.answerText),
              isCorrect: answer.isCorrect,
            ));
          }

          // Ensure at least 2 answers
          while (questionData.answers.length < 2) {
            questionData.answers.add(_AnswerData(
              controller: TextEditingController(),
              isCorrect: false,
            ));
          }

          _questions.add(questionData);
        }

        // If no questions, add one empty
        if (_questions.isEmpty) {
          _addEmptyQuestion();
        }

        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        _showError('Failed to load quiz: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _addEmptyQuestion() {
    final question = _QuestionData(
      questionController: TextEditingController(),
      questionType: QuestionType.singleChoice,
      points: AppConstants.defaultPoints,
      timeLimit: AppConstants.defaultTimeLimit,
    );
    // Add 4 empty answers by default
    for (int i = 0; i < 4; i++) {
      question.answers.add(_AnswerData(
        controller: TextEditingController(),
        isCorrect: false,
      ));
    }
    setState(() => _questions.add(question));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _bannerImageUrlController.dispose();
    for (final q in _questions) {
      q.questionController.dispose();
      for (final a in q.answers) {
        a.controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3ECFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3ECFA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF2F1E55)),
          onPressed: () {
            ref.invalidate(myQuizzesProvider);
            context.go('/home');
          },
        ),
        title: Text(
          'Quiz Editor',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2F1E55),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: OutlinedButton.icon(
              onPressed: _isSaving || _isLoading || _isGeneratingWithAi
                  ? null
                  : _startAIGeneration,
              icon: _isGeneratingWithAi
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.auto_awesome_outlined, size: 18),
              label: Text(
                _isGeneratingWithAi ? 'Generating...' : 'AI Generate',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              onPressed: _isSaving ? null : _saveQuiz,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              ),
              child: _isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Save',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
          if (!_isNew)
            IconButton(
              onPressed: _isSaving ? null : _deleteQuiz,
              icon: const Icon(Icons.delete_outline, color: AppColors.error),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppTheme.spacing8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Quiz Info Card
                        _buildQuizInfoCard(),
                        const SizedBox(height: AppTheme.spacing8),

                        // Questions Header
                        Row(
                          children: [
                            Text(
                              'Questions',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD5C0FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${_questions.length} Questions',
                                style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF4D2E7A),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spacing6),

                        // Questions List
                        ..._questions.asMap().entries.map((entry) {
                          return _buildQuestionCard(entry.key, entry.value);
                        }),

                        // Add Question Button
                        const SizedBox(height: AppTheme.spacing6),
                        OutlinedButton.icon(
                          onPressed: _addEmptyQuestion,
                          icon: const Icon(Icons.add, size: 24),
                          label: Text(
                            'Add New Question',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF3D2A5B),
                            padding: const EdgeInsets.symmetric(vertical: 22),
                            side: BorderSide(
                              color: const Color(0xFFD7C8EA),
                              style: BorderStyle.solid,
                            ),
                            backgroundColor: const Color(0xFFF1E8F8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildQuizInfoCard() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing8),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE1F5),
        borderRadius: AppTheme.borderRadiusXxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quiz Details',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1F1236),
            ),
          ),
          const SizedBox(height: AppTheme.spacing6),
          TextField(
            controller: _titleController,
            style: GoogleFonts.manrope(fontSize: 16),
            decoration: InputDecoration(
              labelText: 'Quiz Title *',
              hintText: 'e.g., Geography Trivia',
              filled: true,
              fillColor: const Color(0xFFD5C0FF),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: AppTheme.spacing6),
          TextField(
            controller: _descriptionController,
            style: GoogleFonts.manrope(fontSize: 14),
            maxLines: 2,
            decoration: InputDecoration(
              labelText: 'Short Description (optional)',
              hintText: 'Brief description of your quiz',
              filled: true,
              fillColor: const Color(0xFFD5C0FF),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacing6),
          TextField(
            controller: _bannerImageUrlController,
            style: GoogleFonts.manrope(fontSize: 14),
            decoration: InputDecoration(
              labelText: 'Banner Image URL (optional)',
              hintText: 'https://example.com/image.jpg',
              filled: true,
              fillColor: const Color(0xFFD5C0FF),
              prefixIcon: const Icon(Icons.image, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
            keyboardType: TextInputType.url,
          ),
          const SizedBox(height: AppTheme.spacing6),
          // Category Dropdown
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: InputDecoration(
              labelText: 'Category *',
              filled: true,
              fillColor: const Color(0xFFD5C0FF),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
            items: QuizCategories.all.map((category) {
              return DropdownMenuItem<String>(
                value: category.id,
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        _getCategoryIcon(category.id),
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacing4),
                    Text(
                      category.name,
                      style: GoogleFonts.manrope(fontSize: 14),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => _selectedCategory = value);
            },
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String categoryId) {
    switch (categoryId) {
      case 'science':
        return Icons.science;
      case 'technology':
        return Icons.computer;
      case 'culture':
        return Icons.theater_comedy;
      case 'history':
        return Icons.history_edu;
      case 'sports':
        return Icons.sports_soccer;
      case 'geography':
        return Icons.public;
      case 'entertainment':
        return Icons.movie;
      case 'general':
      default:
        return Icons.quiz;
    }
  }

  Widget _buildQuestionCard(int index, _QuestionData question) {
    final color = const Color(0xFF6F4AB6);

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing6),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE1F5),
        borderRadius: AppTheme.borderRadiusXl,
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Header
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing6),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F2FB),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppTheme.radiusXl - 1),
                topRight: Radius.circular(AppTheme.radiusXl - 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Question ${index + 1}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2A1846),
                  ),
                ),
                const Spacer(),
                if (_questions.length > 1)
                  IconButton(
                    onPressed: () => _removeQuestion(index),
                    icon: const Icon(Icons.delete_outline),
                    color: AppColors.error,
                    iconSize: 20,
                  ),
              ],
            ),
          ),

          // Question Content
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacing6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question Text
                TextField(
                  controller: question.questionController,
                  style: GoogleFonts.manrope(fontSize: 15),
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Question *',
                    hintText: 'Enter your question here',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.outlineVariant.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: AppTheme.spacing6),

                // Settings Row
                Row(
                  children: [
                    Expanded(
                      child: _buildChoiceChips(
                        label: 'Points',
                        value: question.points,
                        items: [500, 1000, 1500, 2000],
                        onChanged: (v) => setState(() => question.points = v!),
                        format: (v) => '${(v / 100).round()}',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildChoiceChips(
                        label: 'Time',
                        value: question.timeLimit,
                        items: [10, 20, 30, 45, 60],
                        onChanged: (v) =>
                            setState(() => question.timeLimit = v!),
                        format: (v) => '${v}s',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacing6),

                // Fixed answer mode
                Row(
                  children: [
                    Text(
                      'Answer Type:',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Single choice only',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacing6),

                // Answers
                Text(
                  'Answers',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF352154),
                  ),
                ),
                const SizedBox(height: AppTheme.spacing4),

                ...question.answers.asMap().entries.map((entry) {
                  return _buildAnswerField(
                      index, entry.key, entry.value, question);
                }),

                if (question.answers.length < AppConstants.maxAnswerOptions)
                  TextButton.icon(
                    onPressed: () => _addAnswer(question),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Answer'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceChips<T>({
    required String label,
    required T value,
    required List<T> items,
    required void Function(T?) onChanged,
    required String Function(T) format,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 12,
            color: const Color(0xFF4A346C),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFD5C0FF),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: items.map((item) {
              final isSelected = item == value;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(item),
                  child: Container(
                    height: 32,
                    decoration: BoxDecoration(
                      color:
                          isSelected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: Text(
                        format(item),
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF3C285A),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildAnswerField(
    int questionIndex,
    int answerIndex,
    _AnswerData answer,
    _QuestionData question,
  ) {
    final color =
        AppColors.answerColors[answerIndex % AppColors.answerColors.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: answer.isCorrect
              ? AppColors.success
              : color.withValues(alpha: 0.3),
          width: answer.isCorrect ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Color indicator + checkbox
          Container(
            width: 44,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(9),
                bottomLeft: Radius.circular(9),
              ),
            ),
            child: Center(
              child: Checkbox(
                value: answer.isCorrect,
                onChanged: (value) {
                  setState(() {
                    for (final a in question.answers) {
                      a.isCorrect = false;
                    }
                    answer.isCorrect = value ?? false;
                  });
                },
                fillColor: WidgetStateProperty.all(Colors.white),
                checkColor: color,
              ),
            ),
          ),
          // Answer text
          Expanded(
            child: TextField(
              controller: answer.controller,
              style: GoogleFonts.manrope(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Answer ${answerIndex + 1}',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
          // Remove button
          if (question.answers.length > AppConstants.minAnswerOptions)
            IconButton(
              onPressed: () => _removeAnswer(question, answerIndex),
              icon: const Icon(Icons.close, size: 18),
              color: AppColors.onSurfaceVariant,
            ),
        ],
      ),
    );
  }

  void _removeQuestion(int index) {
    if (_questions.length <= 1) return;

    setState(() {
      _questions[index].questionController.dispose();
      for (final a in _questions[index].answers) {
        a.controller.dispose();
      }
      _questions.removeAt(index);
    });
  }

  void _addAnswer(_QuestionData question) {
    if (question.answers.length >= AppConstants.maxAnswerOptions) return;

    setState(() {
      question.answers.add(_AnswerData(
        controller: TextEditingController(),
        isCorrect: false,
      ));
    });
  }

  void _removeAnswer(_QuestionData question, int index) {
    if (question.answers.length <= AppConstants.minAnswerOptions) return;

    setState(() {
      question.answers[index].controller.dispose();
      question.answers.removeAt(index);
    });
  }

  Future<void> _saveQuiz() async {
    // Validation
    if (_titleController.text.trim().isEmpty) {
      _showError('Please enter a quiz title');
      return;
    }

    if (_selectedCategory == null || _selectedCategory!.trim().isEmpty) {
      _showError('Please select a category');
      return;
    }

    if (_questions.isEmpty) {
      _showError('Quiz must contain at least one question');
      return;
    }

    for (int i = 0; i < _questions.length; i++) {
      final q = _questions[i];
      if (q.questionController.text.trim().isEmpty) {
        _showError('Question ${i + 1} is empty');
        return;
      }

      if (q.answers.length < 2) {
        _showError('Question ${i + 1} needs at least 2 answers');
        return;
      }

      if (q.answers.any((a) => a.controller.text.trim().isEmpty)) {
        _showError('All answer fields are required for question ${i + 1}');
        return;
      }

      final correctCount = q.answers.where((a) => a.isCorrect).length;
      if (correctCount != 1) {
        _showError('Question ${i + 1} must have exactly one correct answer');
        return;
      }
    }

    setState(() => _isSaving = true);

    try {
      // Use repository directly to avoid autoDispose issues
      final repository = ref.read(quizRepositoryProvider);

      if (_isNew) {
        // Create new quiz
        final quiz = await repository.createQuiz(
          CreateQuizModel(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            category: _selectedCategory,
            bannerImageUrl: _bannerImageUrlController.text.trim().isEmpty
                ? null
                : _bannerImageUrlController.text.trim(),
          ),
        );

        // Create all questions and answers
        for (int i = 0; i < _questions.length; i++) {
          if (!mounted) return;

          final q = _questions[i];
          final question = await repository.createQuestion(
            CreateQuestionModel(
              quizId: quiz.id,
              orderIndex: i,
              questionText: q.questionController.text.trim(),
              questionType: QuestionType.singleChoice,
              points: q.points,
              timeLimitSeconds: q.timeLimit,
            ),
          );

          int answerIndex = 0;
          for (final a in q.answers) {
            if (!mounted) return;
            await repository.createAnswer(
              CreateAnswerModel(
                questionId: question.id,
                orderIndex: answerIndex++,
                answerText: a.controller.text.trim(),
                isCorrect: a.isCorrect,
              ),
            );
          }
        }
      } else {
        // Update existing quiz
        await repository.updateQuiz(
          widget.quizId!,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          category: _selectedCategory,
          bannerImageUrl: _bannerImageUrlController.text.trim().isEmpty
              ? null
              : _bannerImageUrlController.text.trim(),
        );

        // For simplicity, delete all existing questions and recreate
        final existingQuiz =
            await repository.getQuizWithQuestions(widget.quizId!);

        for (final existingQ in existingQuiz.questions) {
          if (!mounted) return;
          await repository.deleteQuestion(existingQ.id);
        }

        // Create all questions fresh
        for (int i = 0; i < _questions.length; i++) {
          if (!mounted) return;

          final q = _questions[i];
          final question = await repository.createQuestion(
            CreateQuestionModel(
              quizId: widget.quizId!,
              orderIndex: i,
              questionText: q.questionController.text.trim(),
              questionType: QuestionType.singleChoice,
              points: q.points,
              timeLimitSeconds: q.timeLimit,
            ),
          );

          int answerIndex = 0;
          for (final a in q.answers) {
            if (!mounted) return;
            await repository.createAnswer(
              CreateAnswerModel(
                questionId: question.id,
                orderIndex: answerIndex++,
                answerText: a.controller.text.trim(),
                isCorrect: a.isCorrect,
              ),
            );
          }
        }
      }

      ref.invalidate(myQuizzesProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isNew ? 'Quiz created!' : 'Quiz saved!'),
            backgroundColor: AppColors.success,
          ),
        );
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        _showError('Error: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _startAIGeneration() async {
    final params = await _showAIGenerationDialog();
    if (params == null || !mounted) return;

    var shouldReplace = true;
    final hasContent = _titleController.text.trim().isNotEmpty ||
        _descriptionController.text.trim().isNotEmpty ||
        _questions.any(
          (q) =>
              q.questionController.text.trim().isNotEmpty ||
              q.answers.any((a) => a.controller.text.trim().isNotEmpty),
        );

    if (hasContent) {
      shouldReplace = await _confirmReplaceExistingContent() ?? false;
    }

    if (!shouldReplace || !mounted) return;

    setState(() => _isGeneratingWithAi = true);

    try {
      final aiRepository = ref.read(aiQuizRepositoryProvider);
      final draft = await aiRepository.generateQuiz(
        topic: params.topic,
        difficulty: params.difficulty,
        questionCount: params.questionCount,
        language: params.language,
        additionalInstructions: params.additionalInstructions,
      );

      if (!mounted) return;
      _applyAIDraft(draft);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Generated ${draft.questions.length} questions with AI.'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      await _showAIGenerationErrorDialog(_getAIGenerationErrorMessage(e));
    } finally {
      if (mounted) {
        setState(() => _isGeneratingWithAi = false);
      }
    }
  }

  void _applyAIDraft(GeneratedQuizDraft draft) {
    for (final question in _questions) {
      question.questionController.dispose();
      for (final answer in question.answers) {
        answer.controller.dispose();
      }
    }
    _questions.clear();

    _titleController.text = draft.title;
    _descriptionController.text = draft.description ?? '';
    _bannerImageUrlController.clear();
    _selectedCategory = draft.category;

    for (final q in draft.questions) {
      final mapped = _QuestionData(
        questionController: TextEditingController(text: q.questionText),
        questionType: QuestionType.singleChoice,
        points: q.points,
        timeLimit: q.timeLimitSeconds,
      );

      final answers = q.answers.take(AppConstants.maxAnswerOptions).toList();
      for (final answer in answers) {
        mapped.answers.add(
          _AnswerData(
            controller: TextEditingController(text: answer.answerText),
            isCorrect: answer.isCorrect,
          ),
        );
      }

      while (mapped.answers.length < AppConstants.minAnswerOptions) {
        mapped.answers.add(
          _AnswerData(controller: TextEditingController(), isCorrect: false),
        );
      }

      _questions.add(mapped);
    }

    if (_questions.isEmpty) {
      _addEmptyQuestion();
      return;
    }

    setState(() {});
  }

  Future<_AIGenerationParams?> _showAIGenerationDialog() async {
    String topic = '';
    String additionalInstructions = '';
    String difficulty = 'medium';
    String language = 'anglais';
    int questionCount = 5;

    final result = await showDialog<_AIGenerationParams>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Generate Quiz with AI'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      onChanged: (value) => topic = value,
                      decoration: const InputDecoration(
                        labelText: 'Topic *',
                        hintText: 'e.g. Solar System for grade 6',
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: difficulty,
                      decoration:
                          const InputDecoration(labelText: 'Difficulty'),
                      items: const [
                        DropdownMenuItem(value: 'easy', child: Text('Easy')),
                        DropdownMenuItem(
                            value: 'medium', child: Text('Medium')),
                        DropdownMenuItem(value: 'hard', child: Text('Hard')),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setDialogState(() => difficulty = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<int>(
                      value: questionCount,
                      decoration: const InputDecoration(
                        labelText: 'Question count',
                      ),
                      items: const [
                        DropdownMenuItem(value: 3, child: Text('3')),
                        DropdownMenuItem(value: 5, child: Text('5')),
                        DropdownMenuItem(value: 8, child: Text('8')),
                        DropdownMenuItem(value: 10, child: Text('10')),
                        DropdownMenuItem(value: 12, child: Text('12')),
                        DropdownMenuItem(value: 15, child: Text('15')),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setDialogState(() => questionCount = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: language,
                      decoration: const InputDecoration(labelText: 'Language'),
                      items: const [
                        DropdownMenuItem(
                          value: 'anglais',
                          child: Text('Anglais'),
                        ),
                        DropdownMenuItem(
                          value: 'francais',
                          child: Text('Francais'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setDialogState(() => language = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      onChanged: (value) => additionalInstructions = value,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Extra instructions (optional)',
                        hintText: 'Focus on practical examples',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    final normalizedTopic = topic.trim();
                    if (normalizedTopic.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Topic is required to generate a quiz.'),
                        ),
                      );
                      return;
                    }
                    Navigator.pop(
                      context,
                      _AIGenerationParams(
                        topic: normalizedTopic,
                        difficulty: difficulty,
                        questionCount: questionCount,
                        language: language,
                        additionalInstructions: additionalInstructions.trim(),
                      ),
                    );
                  },
                  child: const Text('Generate'),
                ),
              ],
            );
          },
        );
      },
    );
    return result;
  }

  Future<bool?> _confirmReplaceExistingContent() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Replace current draft?'),
          content: const Text(
            'AI generation will replace your current quiz title, description, and questions.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Keep current'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Replace'),
            ),
          ],
        );
      },
    );
  }

  String _getAIGenerationErrorMessage(Object error) {
    final message = error.toString();

    if (message.contains('session expired') || message.contains('sign in')) {
      return 'Your session is no longer valid. Please sign in again, then retry AI generation.';
    }
    if (message.contains('Too many') || message.contains('429')) {
      return 'You reached the AI rate limit. Wait a bit and try again.';
    }
    if (message.contains('provider') || message.contains('unavailable')) {
      return 'Gemini service is temporarily unavailable. Please retry in a few minutes.';
    }
    if (message.contains('language must be anglais or francais')) {
      return 'Only Anglais and Francais are allowed for AI generation.';
    }

    return 'AI generation failed. Please verify your settings and try again.';
  }

  Future<void> _showAIGenerationErrorDialog(String message) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('AI Generation Failed'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                _startAIGeneration();
              },
              child: const Text('Retry'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteQuiz() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Quiz'),
        content: const Text('Are you sure? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && widget.quizId != null) {
      try {
        final repository = ref.read(quizRepositoryProvider);
        await repository.deleteQuiz(widget.quizId!);
        ref.invalidate(myQuizzesProvider);

        if (mounted) {
          context.go('/home');
        }
      } catch (e) {
        _showError('Failed to delete: $e');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }
}

class _QuestionData {
  final String? id;
  final TextEditingController questionController;
  String questionType;
  int points;
  int timeLimit;
  final List<_AnswerData> answers = [];

  _QuestionData({
    this.id,
    required this.questionController,
    required this.questionType,
    required this.points,
    required this.timeLimit,
  });
}

class _AnswerData {
  final String? id;
  final TextEditingController controller;
  bool isCorrect;

  _AnswerData({
    this.id,
    required this.controller,
    required this.isCorrect,
  });
}

class _AIGenerationParams {
  final String topic;
  final String difficulty;
  final int questionCount;
  final String language;
  final String? additionalInstructions;

  const _AIGenerationParams({
    required this.topic,
    required this.difficulty,
    required this.questionCount,
    required this.language,
    this.additionalInstructions,
  });
}
