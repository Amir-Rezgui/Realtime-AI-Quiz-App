import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/quiz_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class QuestionEditorScreen extends ConsumerStatefulWidget {
  final String quizId;
  final String? questionId;

  const QuestionEditorScreen({
    super.key,
    required this.quizId,
    this.questionId,
  });

  @override
  ConsumerState<QuestionEditorScreen> createState() =>
      _QuestionEditorScreenState();
}

class _QuestionEditorScreenState extends ConsumerState<QuestionEditorScreen> {
  final _questionController = TextEditingController();
  String _questionType = QuestionType.singleChoice;
  int _points = AppConstants.defaultPoints;
  int _timeLimit = AppConstants.defaultTimeLimit;
  final List<_AnswerField> _answers = [];
  bool _isNew = true;
  bool _isSaving = false;

  bool _isQuizLoaded = false;

  @override
  void initState() {
    super.initState();
    _isNew = widget.questionId == null;

    // Always load the quiz first
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadQuizAndQuestion();
    });

    if (_isNew) {
      // Start with 2 empty answers
      _answers.addAll([
        _AnswerField(controller: TextEditingController(), isCorrect: false),
        _AnswerField(controller: TextEditingController(), isCorrect: false),
      ]);
    }
  }

  Future<void> _loadQuizAndQuestion() async {
    // Load the quiz first
    await ref.read(quizEditorProvider.notifier).loadQuiz(widget.quizId);

    if (mounted) {
      setState(() => _isQuizLoaded = true);

      // If editing existing question, load its data
      if (!_isNew) {
        _loadQuestion();
      }
    }
  }

  void _loadQuestion() {
    final state = ref.read(quizEditorProvider);
    if (state.quiz == null) return;

    final question = state.quiz!.questions.firstWhere(
      (q) => q.id == widget.questionId,
      orElse: () => throw Exception('Question not found'),
    );

    _questionController.text = question.questionText;
    _questionType = question.questionType;
    _points = question.points;
    _timeLimit = question.timeLimitSeconds;

    final sortedAnswers = [...question.answers]
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    _answers.clear();
    for (final answer in sortedAnswers) {
      _answers.add(
        _AnswerField(
          id: answer.id,
          controller: TextEditingController(text: answer.answerText),
          isCorrect: answer.isCorrect,
        ),
      );
    }

    if (_answers.isEmpty) {
      _answers.addAll([
        _AnswerField(controller: TextEditingController(), isCorrect: false),
        _AnswerField(controller: TextEditingController(), isCorrect: false),
      ]);
    }

    setState(() {});
  }

  @override
  void dispose() {
    _questionController.dispose();
    for (final answer in _answers) {
      answer.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizEditorProvider);

    // Show loading while quiz is being loaded
    if (state.isLoading || !_isQuizLoaded) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/quiz/${widget.quizId}'),
          ),
          title: Text(_isNew ? 'Add Question' : 'Edit Question'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/quiz/${widget.quizId}'),
        ),
        title: Text(_isNew ? 'Add Question' : 'Edit Question'),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveQuestion,
            child: _isSaving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(
                labelText: 'Question',
                hintText: 'Enter your question',
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Points',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<int>(
                        value: _points,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: [500, 1000, 1500, 2000]
                            .map(
                              (p) =>
                                  DropdownMenuItem(value: p, child: Text('$p')),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() => _points = value!);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Time Limit',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<int>(
                        value: _timeLimit,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: [10, 15, 20, 30, 45, 60, 90, 120]
                            .map(
                              (t) => DropdownMenuItem(
                                value: t,
                                child: Text('${t}s'),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() => _timeLimit = value!);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text(
                  'Answer Type',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: QuestionType.singleChoice,
                      label: Text('Single'),
                    ),
                    ButtonSegment(
                      value: QuestionType.multipleChoice,
                      label: Text('Multiple'),
                    ),
                  ],
                  selected: {_questionType},
                  onSelectionChanged: (value) {
                    setState(() {
                      _questionType = value.first;
                      if (_questionType == QuestionType.singleChoice) {
                        // Ensure only one is selected
                        int correctCount = _answers
                            .where((a) => a.isCorrect)
                            .length;
                        if (correctCount > 1) {
                          for (final answer in _answers) {
                            answer.isCorrect = false;
                          }
                        }
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Answers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              _questionType == QuestionType.singleChoice
                  ? 'Tap the checkbox to mark the correct answer'
                  : 'Tap checkboxes to mark all correct answers',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            ..._buildAnswerFields(),
            if (_answers.length < AppConstants.maxAnswerOptions) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _addAnswer,
                icon: const Icon(Icons.add),
                label: const Text('Add Answer'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAnswerFields() {
    return List.generate(_answers.length, (index) {
      final answer = _answers[index];
      final color =
          AppColors.answerColors[index % AppColors.answerColors.length];

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: answer.isCorrect
                ? AppColors.success
                : color.withValues(alpha: 0.3),
            width: answer.isCorrect ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 56,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(11),
                  bottomLeft: Radius.circular(11),
                ),
              ),
              child: Center(
                child: Checkbox(
                  value: answer.isCorrect,
                  onChanged: (value) => _toggleCorrect(index, value!),
                  fillColor: WidgetStateProperty.all(Colors.white),
                  checkColor: color,
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: answer.controller,
                decoration: InputDecoration(
                  hintText: 'Answer ${index + 1}',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
            if (_answers.length > AppConstants.minAnswerOptions)
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => _removeAnswer(index),
                color: AppColors.textSecondary,
              ),
          ],
        ),
      );
    });
  }

  void _addAnswer() {
    if (_answers.length >= AppConstants.maxAnswerOptions) return;

    setState(() {
      _answers.add(
        _AnswerField(controller: TextEditingController(), isCorrect: false),
      );
    });
  }

  void _removeAnswer(int index) {
    if (_answers.length <= AppConstants.minAnswerOptions) return;

    setState(() {
      _answers[index].controller.dispose();
      _answers.removeAt(index);
    });
  }

  void _toggleCorrect(int index, bool value) {
    setState(() {
      if (_questionType == QuestionType.singleChoice) {
        // Single choice: only one can be correct
        for (int i = 0; i < _answers.length; i++) {
          _answers[i].isCorrect = i == index && value;
        }
      } else {
        // Multiple choice: toggle individually
        _answers[index].isCorrect = value;
      }
    });
  }

  Future<void> _saveQuestion() async {
    if (_questionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a question')));
      return;
    }

    final validAnswers = _answers
        .where((a) => a.controller.text.trim().isNotEmpty)
        .toList();

    if (validAnswers.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter at least 2 answers')),
      );
      return;
    }

    if (!validAnswers.any((a) => a.isCorrect)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please mark at least one correct answer'),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final notifier = ref.read(quizEditorProvider.notifier);

      // Ensure quiz is loaded
      final editorState = ref.read(quizEditorProvider);
      if (editorState.quiz == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Quiz not loaded. Please try again.')),
        );
        return;
      }

      if (_isNew) {
        // Create question
        final question = await notifier.addQuestion(
          questionText: _questionController.text.trim(),
          questionType: _questionType,
          points: _points,
          timeLimitSeconds: _timeLimit,
        );

        if (question != null) {
          // Add answers
          for (int i = 0; i < validAnswers.length; i++) {
            await notifier.addAnswer(
              question.id,
              answerText: validAnswers[i].controller.text.trim(),
              isCorrect: validAnswers[i].isCorrect,
            );
          }

          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Question saved!')));
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Failed to save: ${editorState.error ?? "Unknown error"}',
                ),
              ),
            );
            return;
          }
        }
      } else {
        // Update question
        await notifier.updateQuestion(
          widget.questionId!,
          questionText: _questionController.text.trim(),
          questionType: _questionType,
          points: _points,
          timeLimitSeconds: _timeLimit,
        );

        // Update/create/delete answers
        // This is simplified - in production you'd diff the answers
      }

      if (mounted) {
        context.go('/quiz/${widget.quizId}');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}

class _AnswerField {
  final String? id;
  final TextEditingController controller;
  bool isCorrect;

  _AnswerField({this.id, required this.controller, required this.isCorrect});
}
