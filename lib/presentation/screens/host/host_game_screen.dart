import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/game_session_provider.dart';
import '../leaderboard/leaderboard_screen.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class HostGameScreen extends ConsumerWidget {
  final String sessionId;

  const HostGameScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(hostGameProvider);

    if (state.isLoading || state.quiz == null || state.session == null) {
      return Scaffold(
        backgroundColor: AppColors.surface,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Game finished
    if (state.session!.status == GameStatus.finished) {
      return _buildFinishedScreen(context, ref);
    }
    if (state.isShowingRoundLeaderboard) {
      return _buildHostRoundLeaderboard(context, ref, state);
    }

    final currentQuestion =
        state.session!.currentQuestionIndex < state.quiz!.questions.length
            ? state.quiz!.questions[state.session!.currentQuestionIndex]
            : null;
    if (currentQuestion == null) {
      return Scaffold(
        backgroundColor: AppColors.surface,
        body: const SafeArea(child: Center(child: CircularProgressIndicator())),
      );
    }

    final questionNumber = state.session!.currentQuestionIndex + 1;
    final totalQuestions = state.quiz!.questions.length;
    final isLastQuestion = questionNumber >= totalQuestions;
    final totalPlayers = state.totalPlayers;
    final answeredCount = state.answeredCount;
    final completion = totalPlayers > 0 ? answeredCount / totalPlayers : 0.0;
    final remaining =
        state.remainingSeconds.clamp(0, currentQuestion.timeLimitSeconds);
    final timerProgress = currentQuestion.timeLimitSeconds > 0
        ? remaining / currentQuestion.timeLimitSeconds
        : 0.0;
    final isQuestionActive = state.session!.status == GameStatus.questionActive;

    final answerCounts = <String, int>{
      for (final answer in currentQuestion.answers)
        answer.id: state.answerDistribution[answer.id] ?? 0,
    };
    final orderedAnswers = [...currentQuestion.answers]
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    final maxAnswerCount =
        answerCounts.values.fold<int>(0, (a, b) => a > b ? a : b);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, ref, state.isPaused),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.spacing6,
                  AppTheme.spacing8,
                  AppTheme.spacing6,
                  AppTheme.spacing10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppTheme.spacing8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: AppTheme.borderRadiusXxl,
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: -20,
                            right: -8,
                            child: Text(
                              questionNumber.toString().padLeft(2, '0'),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 110,
                                fontWeight: FontWeight.w800,
                                color: AppColors.outlineVariant
                                    .withValues(alpha: 0.32),
                                height: 0.9,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.spacing5,
                                  vertical: AppTheme.spacing3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryContainer,
                                  borderRadius: AppTheme.borderRadiusXl,
                                ),
                                child: Text(
                                  'QUESTION $questionNumber OF $totalQuestions',
                                  style: GoogleFonts.manrope(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.onPrimaryContainer,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppTheme.spacing8),
                              Text(
                                currentQuestion.questionText,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onSurface,
                                  height: 1.15,
                                ),
                              ),
                              const SizedBox(height: AppTheme.spacing8),
                              ...orderedAnswers.map((answer) {
                                final count = answerCounts[answer.id] ?? 0;
                                final progress = maxAnswerCount > 0
                                    ? count / maxAnswerCount
                                    : 0.0;
                                final isLeading = maxAnswerCount > 0 &&
                                    count == maxAnswerCount;
                                final isCorrectRevealed =
                                    state.isQuestionRevealed &&
                                        state.revealedCorrectAnswerIds
                                            .contains(answer.id);
                                final isCorrect = state.revealedCorrectAnswerIds
                                    .contains(answer.id);
                                final playerLabel =
                                    count == 1 ? 'player' : 'players';

                                return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: AppTheme.spacing6),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.all(AppTheme.spacing3),
                                    decoration: BoxDecoration(
                                      color: isCorrectRevealed
                                          ? AppColors.success
                                              .withValues(alpha: 0.12)
                                          : Colors.transparent,
                                      borderRadius: AppTheme.borderRadiusXl,
                                      border: isCorrectRevealed
                                          ? Border.all(
                                              color: AppColors.success,
                                              width: 2,
                                            )
                                          : null,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                answer.answerText,
                                                style: GoogleFonts.manrope(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w600,
                                                  color: isCorrectRevealed
                                                      ? AppColors.success
                                                      : AppColors.onSurface,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (isCorrectRevealed &&
                                                isCorrect) ...[
                                              const SizedBox(
                                                  width: AppTheme.spacing2),
                                              const Icon(
                                                Icons.check_circle_rounded,
                                                color: AppColors.success,
                                                size: 22,
                                              ),
                                            ],
                                            const SizedBox(
                                                width: AppTheme.spacing4),
                                            Text(
                                              '$count $playerLabel',
                                              style: GoogleFonts.manrope(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                            height: AppTheme.spacing3),
                                        Container(
                                          height: 16,
                                          decoration: BoxDecoration(
                                            color: AppColors
                                                .surfaceContainerHighest,
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: FractionallySizedBox(
                                              widthFactor:
                                                  progress.clamp(0.0, 1.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  gradient: isLeading
                                                      ? AppColors
                                                          .primaryGradient
                                                      : null,
                                                  color: isCorrectRevealed
                                                      ? AppColors.success
                                                      : isLeading
                                                          ? null
                                                          : AppColors
                                                              .outlineVariant
                                                              .withValues(
                                                              alpha: 0.7,
                                                            ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppTheme.spacing6),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: AppTheme.borderRadiusXl,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Icon(
                              Icons.groups_rounded,
                              color: AppColors.onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacing4),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'PARTICIPATION',
                                  style: GoogleFonts.manrope(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.onSurface,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '$answeredCount/$totalPlayers ',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 32,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.onSurface,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'have answered',
                                        style: GoogleFonts.manrope(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppTheme.spacing6),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: AppTheme.borderRadiusXl,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Icon(
                              Icons.trending_up_rounded,
                              color: AppColors.onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacing4),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'LIVE ACTIVITY',
                                  style: GoogleFonts.manrope(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.onSurface,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '${(completion * 100).round()}% ',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 32,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.onSurface,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Completion',
                                        style: GoogleFonts.manrope(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing8,
                        vertical: AppTheme.spacing8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: AppTheme.borderRadiusXxl,
                        boxShadow: AppColors.ambientShadow,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'TIME REMAINING',
                            style: GoogleFonts.manrope(
                              fontSize: 16,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacing4),
                          Text(
                            '$remaining',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 72,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacing6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: LinearProgressIndicator(
                              value: timerProgress.clamp(0.0, 1.0),
                              minHeight: 8,
                              backgroundColor:
                                  AppColors.surfaceContainerHighest,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    if (state.isPaused) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppTheme.spacing5),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.15),
                          borderRadius: AppTheme.borderRadiusXl,
                        ),
                        child: Text(
                          'Quiz paused. Players are waiting for resume.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w700,
                            color: AppColors.warning,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing8),
                    ],
                    if (!isLastQuestion) ...[
                      SizedBox(
                        height: 72,
                        child: FilledButton(
                          onPressed: state.canGoToNextQuestion
                              ? () => ref
                                  .read(hostGameProvider.notifier)
                                  .goToNextQuestion()
                              : isQuestionActive &&
                                      !state.isQuestionRevealed &&
                                      !state.isPaused
                                  ? () => ref
                                      .read(hostGameProvider.notifier)
                                      .skipQuestion()
                                  : null,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.surfaceDim,
                            disabledBackgroundColor: AppColors.surfaceDim,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppTheme.borderRadiusXl,
                            ),
                          ),
                          child: Text(
                            state.canGoToNextQuestion
                                ? 'Next Question'
                                : 'Validate Question',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing6),
                    ],
                    if (isLastQuestion && state.canGoToNextQuestion) ...[
                      SizedBox(
                        height: 72,
                        child: FilledButton(
                          onPressed: () =>
                              ref.read(hostGameProvider.notifier).endGame(),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.surfaceDim,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppTheme.borderRadiusXl,
                            ),
                          ),
                          child: Text(
                            'View Final Leaderboard',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing6),
                    ],
                    const SizedBox(height: AppTheme.spacing8),
                    const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
            _buildBottomNav(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHostRoundLeaderboard(
    BuildContext context,
    WidgetRef ref,
    HostGameState state,
  ) {
    return LeaderboardScreen(
      sessionId: sessionId,
      isHostView: true,
      onNextQuestion: () =>
          ref.read(hostGameProvider.notifier).goToNextQuestion(),
      nextQuestionCountdownSeconds: state.nextQuestionCountdownSeconds,
      onNextCountdownStarted: () {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: const Text(
                'Next question starts in 10 seconds.',
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.primary,
              duration: const Duration(seconds: 3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
      },
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, bool isPaused) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacing6,
        AppTheme.spacing4,
        AppTheme.spacing6,
        AppTheme.spacing2,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.go('/host/$sessionId/lobby'),
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppColors.primary,
          ),
          IconButton(
            onPressed: () => _showDiscardDialog(context, ref),
            icon: const Icon(Icons.close_rounded),
            color: AppColors.primary,
          ),
          const Spacer(),
          TextButton(
            onPressed: () => ref.read(hostGameProvider.notifier).togglePause(),
            child: Text(
              isPaused ? 'Resume' : 'Pause',
              style: GoogleFonts.manrope(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDiscardDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Discard Session',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'This will cancel the live session for everyone. Do you want to continue?',
          style: GoogleFonts.manrope(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(hostGameProvider.notifier).discardSession();
      if (context.mounted) {
        context.go('/home');
      }
    }
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacing4,
        AppTheme.spacing3,
        AppTheme.spacing4,
        AppTheme.spacing6,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppTheme.radius3xl),
          topRight: Radius.circular(AppTheme.radius3xl),
        ),
        boxShadow: AppColors.ambientShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBottomNavItem(
            icon: Icons.help_outline_rounded,
            label: 'Quiz',
            isActive: true,
            onTap: () {},
          ),
          _buildBottomNavItem(
            icon: Icons.bar_chart_rounded,
            label: 'Leaderboard',
            isActive: false,
            onTap: () => context.go('/leaderboard/$sessionId?view=host'),
          ),
          _buildBottomNavItem(
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Chat',
            isActive: false,
            onTap: () => context.go('/host/$sessionId/lobby'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppTheme.borderRadiusXl,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.surfaceContainerHigh : Colors.transparent,
          borderRadius: AppTheme.borderRadiusXl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color:
                    isActive ? AppColors.primary : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinishedScreen(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacing10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(AppTheme.spacing8),
                    decoration: BoxDecoration(
                      color: AppColors.warning,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacing12),
                Text(
                  'Quiz Complete!',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing4),
                Text(
                  'Great job hosting the quiz!',
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: AppTheme.spacing16),
                ElevatedButton.icon(
                  onPressed: () =>
                      context.go('/leaderboard/$sessionId?view=host'),
                  icon: const Icon(Icons.leaderboard),
                  label: const Text('View Final Leaderboard'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing10,
                      vertical: AppTheme.spacing6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppTheme.borderRadiusXl,
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacing6),
                OutlinedButton.icon(
                  onPressed: () async {
                    final discarded = await ref
                        .read(hostGameProvider.notifier)
                        .discardSession();
                    if (!context.mounted) return;
                    if (!discarded) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Could not close session for players. Try again.'),
                        ),
                      );
                      return;
                    }
                    context.go('/home');
                  },
                  icon: const Icon(Icons.home_outlined),
                  label: const Text('Back to Home'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side:
                        BorderSide(color: Colors.white.withValues(alpha: 0.5)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing10,
                      vertical: AppTheme.spacing6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppTheme.borderRadiusXl,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
