import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/player_provider.dart';
import '../leaderboard/leaderboard_screen.dart';
import '../../../domain/services/scoring_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class PlayerGameScreen extends ConsumerStatefulWidget {
  final String sessionId;
  final String playerId;

  const PlayerGameScreen({
    super.key,
    required this.sessionId,
    required this.playerId,
  });

  @override
  ConsumerState<PlayerGameScreen> createState() => _PlayerGameScreenState();
}

class _PlayerGameScreenState extends ConsumerState<PlayerGameScreen> {
  String _activeTab = 'quiz';
  final TextEditingController _chatController = TextEditingController();
  late final ProviderSubscription<PlayerGameState> _playerStateSubscription;
  int _lastSeenChatCount = 0;
  bool _handledCancellation = false;

  @override
  void initState() {
    super.initState();
    _playerStateSubscription =
        ref.listenManual(playerGameProvider, (previous, next) {
      if (!mounted) return;

      final previousCount = previous?.chatMessages.length ?? 0;
      final hasNewMessage = next.chatMessages.length > previousCount;
      if (hasNewMessage && next.chatMessages.isNotEmpty) {
        final last = next.chatMessages.last;
        final isOwn = last.playerId == widget.playerId;
        if (_activeTab != 'chat' && !isOwn && !last.isSystem) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${last.nickname}: ${last.message}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }

      if (previous?.phase != next.phase) {
        if (next.phase == GamePhase.leaderboard) {
          setState(() => _activeTab = 'leaderboard');
        } else if (next.phase == GamePhase.question &&
            _activeTab == 'leaderboard') {
          setState(() => _activeTab = 'quiz');
        }
      }

      if (next.phase == GamePhase.cancelled && !_handledCancellation) {
        _handledCancellation = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Host left the session. Redirecting to login...'),
            duration: Duration(seconds: 2),
          ),
        );
        Future.microtask(() => context.go('/login'));
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(playerGameProvider);
      if (state.session == null) {
        ref
            .read(playerGameProvider.notifier)
            .loadExistingSession(widget.sessionId, widget.playerId);
      }
    });
  }

  @override
  void dispose() {
    _playerStateSubscription.close();
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(playerGameProvider);

    if (state.phase == GamePhase.finished) {
      return _buildFinishedScreen(state);
    }

    if (state.phase == GamePhase.lobby) {
      return _buildWaitingScreen();
    }

    if (_activeTab == 'leaderboard') {
      return LeaderboardScreen(
        sessionId: widget.sessionId,
        isHostView: false,
        currentPlayerId: widget.playerId,
        playerActiveTab: 'leaderboard',
        onQuizTab: () => setState(() => _activeTab = 'quiz'),
        onLeaderboardTab: () => setState(() => _activeTab = 'leaderboard'),
        onChatTab: () {
          setState(() {
            _activeTab = 'chat';
            _lastSeenChatCount = state.chatMessages.length;
          });
        },
      );
    }

    if (_activeTab == 'chat') {
      return _buildChatScreen(state);
    }

    return _buildQuestionScreen(state);
  }

  Widget _buildCancelledScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacing8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cancel_outlined,
                  size: 68,
                  color: AppColors.error,
                ),
                const SizedBox(height: AppTheme.spacing6),
                Text(
                  'Session ended by host',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacing3),
                Text(
                  'The host returned home. You can join another quiz now.',
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    color: AppColors.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacing10),
                FilledButton.icon(
                  onPressed: () => context.go('/join'),
                  icon: const Icon(Icons.login_rounded),
                  label: const Text('Go to Join'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacing10),
              Text(
                'Get Ready...',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: AppTheme.spacing3),
              Text(
                'Next question is coming',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionScreen(PlayerGameState state) {
    final question = state.currentQuestion;
    if (question == null) return _buildWaitingScreen();
    final orderedAnswers = [...question.answers]
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    final completion = state.totalPlayers > 0
        ? state.answeredPlayers / state.totalPlayers
        : 0.0;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppTheme.spacing6),
                child: Column(
                  children: [
                    const SizedBox(height: AppTheme.spacing8),

                    // Circular Timer
                    _CircularTimer(
                      remainingSeconds: state.remainingSeconds,
                      totalSeconds: question.timeLimit,
                    ),

                    const SizedBox(height: AppTheme.spacing10),

                    if (state.isPaused) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppTheme.spacing5),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.15),
                          borderRadius: AppTheme.borderRadiusXl,
                        ),
                        child: Text(
                          'Quiz paused by host. Please wait...',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w700,
                            color: AppColors.warning,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing6),
                    ],

                    // Question Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppTheme.spacing8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: AppTheme.borderRadiusXxl,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.06),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Question Counter
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      '${(question.questionIndex + 1).toString().padLeft(2, '0')}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                                TextSpan(
                                  text: ' / 10',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacing4),
                          // Question Text
                          Text(
                            question.questionText,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppTheme.spacing6),

                    // Answer Options (Vertical List)
                    ...orderedAnswers.map((answer) {
                      final isSelected =
                          state.selectedAnswerIds.contains(answer.id);
                      final canAnswerNow =
                          !state.isPaused && state.remainingSeconds > 0;
                      final lockSelection = state.hasAnswered || !canAnswerNow;
                      final correctAnswerIds =
                          state.results?.correctAnswerIds ?? const <String>[];
                      final isCorrectAnswer =
                          correctAnswerIds.contains(answer.id);
                      final showCorrectHighlight =
                          state.phase == GamePhase.results &&
                              state.results != null;
                      final answerBackground =
                          showCorrectHighlight && isCorrectAnswer
                              ? AppColors.success.withValues(alpha: 0.16)
                              : isSelected
                                  ? AppColors.primaryContainer
                                  : AppColors.surfaceContainerLowest;
                      final answerBorder = showCorrectHighlight &&
                              isCorrectAnswer
                          ? Border.all(color: AppColors.success, width: 2)
                          : isSelected
                              ? Border.all(color: AppColors.primary, width: 2)
                              : null;

                      return GestureDetector(
                        onTap: lockSelection
                            ? null
                            : () => ref
                                .read(playerGameProvider.notifier)
                                .selectAnswer(answer.id),
                        child: Container(
                          margin:
                              const EdgeInsets.only(bottom: AppTheme.spacing3),
                          decoration: BoxDecoration(
                            color: answerBackground,
                            borderRadius: AppTheme.borderRadiusXl,
                            border: answerBorder,
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacing6,
                              vertical: AppTheme.spacing2,
                            ),
                            title: Text(
                              answer.text,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: AppColors.onSurface,
                              ),
                            ),
                            trailing: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: showCorrectHighlight && isCorrectAnswer
                                    ? AppColors.success
                                    : isSelected
                                        ? AppColors.primary
                                        : Colors.transparent,
                                shape: BoxShape.circle,
                                border:
                                    (showCorrectHighlight && isCorrectAnswer) ||
                                            isSelected
                                        ? null
                                        : Border.all(
                                            color: AppColors.outlineVariant,
                                            width: 2,
                                          ),
                              ),
                              child:
                                  (showCorrectHighlight && isCorrectAnswer) ||
                                          isSelected
                                      ? const Icon(
                                          Icons.check_rounded,
                                          color: Colors.white,
                                          size: 18,
                                        )
                                      : null,
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: AppTheme.spacing3),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (!state.isPaused &&
                                state.remainingSeconds > 0 &&
                                !state.hasAnswered &&
                                state.selectedAnswerIds.isNotEmpty)
                            ? () => ref
                                .read(playerGameProvider.notifier)
                                .confirmAnswer()
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                          disabledBackgroundColor:
                              AppColors.surfaceContainerHigh,
                          disabledForegroundColor: AppColors.onSurfaceVariant,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppTheme.spacing4,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppTheme.borderRadiusXl,
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          state.hasAnswered
                              ? 'Wait for timer to finish'
                              : state.selectedAnswerIds.isEmpty
                                  ? 'Select one answer'
                                  : 'Confirm selection',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppTheme.spacing6),

                    // Participants Progress Card
                    if (state.phase == GamePhase.question || state.hasAnswered)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppTheme.spacing6),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest,
                          borderRadius: AppTheme.borderRadiusXl,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.hourglass_bottom_rounded,
                                  size: 20,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: AppTheme.spacing3),
                                Text(
                                  'Wait for others to answer',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppTheme.spacing4),
                            ClipRRect(
                              borderRadius: AppTheme.borderRadiusSm,
                              child: LinearProgressIndicator(
                                value: completion.clamp(0.0, 1.0),
                                backgroundColor: AppColors.surfaceContainerHigh,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primary),
                                minHeight: 8,
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacing3),
                            Row(
                              children: [
                                Text(
                                  '${state.answeredPlayers}/${state.totalPlayers} participants done',
                                  style: GoogleFonts.manrope(
                                    fontSize: 13,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${(completion * 100).round()}%',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: AppTheme.spacing10),
                  ],
                ),
              ),
            ),

            // Bottom Navigation
            _buildBottomNav('quiz', state),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacing6),
      child: Row(
        children: [
          // Logo
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.15),
              borderRadius: AppTheme.borderRadiusMd,
            ),
            child: Center(
              child: Icon(
                Icons.quiz_outlined,
                color: AppColors.warning,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacing4),
          Text(
            'Kinetic Quiz',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnsweredState() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing10),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: AppTheme.borderRadiusXxl,
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: AppTheme.spacing6),
          Text(
            'Answer Submitted!',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(String activeTab, PlayerGameState state) {
    final hasUnreadChat =
        activeTab != 'chat' && state.chatMessages.length > _lastSeenChatCount;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(
          top: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          activeTab == 'quiz'
              ? _buildNavItemActive(
                  Icons.quiz,
                  'Quiz',
                  () => setState(() => _activeTab = 'quiz'),
                )
              : _buildNavItem(
                  Icons.quiz_outlined,
                  'Quiz',
                  false,
                  () => setState(() => _activeTab = 'quiz'),
                ),
          activeTab == 'leaderboard'
              ? _buildNavItemActive(
                  Icons.bar_chart_rounded,
                  'Leaderboard',
                  () => setState(() => _activeTab = 'leaderboard'),
                )
              : _buildNavItem(
                  Icons.bar_chart_outlined,
                  'Leaderboard',
                  false,
                  () => setState(() => _activeTab = 'leaderboard'),
                ),
          activeTab == 'chat'
              ? _buildNavItemActive(
                  Icons.chat_rounded,
                  'Chat',
                  () => setState(() {
                    _activeTab = 'chat';
                    _lastSeenChatCount = state.chatMessages.length;
                  }),
                )
              : _buildNavItem(
                  Icons.chat_bubble_outline_rounded,
                  'Chat',
                  false,
                  () => setState(() {
                    _activeTab = 'chat';
                    _lastSeenChatCount = state.chatMessages.length;
                  }),
                  showBadge: hasUnreadChat,
                ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isSelected,
    VoidCallback onTap, {
    bool showBadge = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                icon,
                color: AppColors.onSurfaceVariant,
              ),
              if (showBadge)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItemActive(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing6,
          vertical: AppTheme.spacing3,
        ),
        decoration: BoxDecoration(
          color: AppColors.primaryContainer,
          borderRadius: AppTheme.borderRadiusXl,
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: AppTheme.spacing2),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsScreen(PlayerGameState state) {
    final isCorrect = state.results != null &&
        ScoringService.checkAnswer(
          selectedIds: state.selectedAnswerIds,
          correctIds: state.results!.correctAnswerIds,
          isMultipleChoice:
              state.currentQuestion?.questionType == 'multiple_choice',
        );

    return Scaffold(
      backgroundColor: isCorrect ? AppColors.success : AppColors.error,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isCorrect ? Icons.check_rounded : Icons.close_rounded,
                      size: 56,
                      color: isCorrect ? AppColors.success : AppColors.error,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacing10),
              Text(
                isCorrect ? 'Correct!' : 'Incorrect',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              if (isCorrect && state.pointsEarned != null) ...[
                const SizedBox(height: AppTheme.spacing6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing8,
                    vertical: AppTheme.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: AppTheme.borderRadiusXl,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add, color: Colors.white, size: 24),
                      Text(
                        '${state.pointsEarned} points',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatScreen(PlayerGameState state) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing6,
                  vertical: AppTheme.spacing4,
                ),
                itemCount: state.chatMessages.length,
                itemBuilder: (context, index) {
                  final chat = state.chatMessages[index];
                  final isMine = chat.playerId == widget.playerId;
                  return Align(
                    alignment:
                        isMine ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: AppTheme.spacing3),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing4,
                        vertical: AppTheme.spacing3,
                      ),
                      constraints: const BoxConstraints(maxWidth: 300),
                      decoration: BoxDecoration(
                        color: isMine
                            ? AppColors.primaryContainer
                            : AppColors.surfaceContainerLow,
                        borderRadius: AppTheme.borderRadiusLg,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chat.nickname,
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            chat.message,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.spacing6,
                AppTheme.spacing3,
                AppTheme.spacing6,
                AppTheme.spacing5,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _chatController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacing3),
                  IconButton(
                    onPressed: () async {
                      final text = _chatController.text.trim();
                      if (text.isEmpty) return;
                      _chatController.clear();
                      await ref
                          .read(playerGameProvider.notifier)
                          .sendChatMessage(text);
                    },
                    icon: const Icon(Icons.send_rounded),
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
            _buildBottomNav('chat', state),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardScreen(PlayerGameState state) {
    final entries = state.leaderboard?.entries ?? [];

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppTheme.spacing6),
                child: Column(
                  children: [
                    Text(
                      'Leaderboard',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    ...entries.take(5).toList().asMap().entries.map((entry) {
                      final index = entry.key;
                      final player = entry.value;
                      final isMe = player['player_id'] == widget.playerId;

                      return Container(
                        margin:
                            const EdgeInsets.only(bottom: AppTheme.spacing3),
                        padding: const EdgeInsets.all(AppTheme.spacing4),
                        decoration: BoxDecoration(
                          color: isMe
                              ? AppColors.primaryContainer
                              : AppColors.surfaceContainerLowest,
                          borderRadius: AppTheme.borderRadiusLg,
                          border: isMe
                              ? Border.all(color: AppColors.primary, width: 2)
                              : null,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: index < 3
                                    ? [
                                        AppColors.warning,
                                        Colors.grey,
                                        Colors.brown
                                      ][index]
                                    : AppColors.surfaceContainerHigh,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: index < 3
                                        ? Colors.white
                                        : AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacing4),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    player['nickname'] ?? '',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                  if (isMe)
                                    Text(
                                      'You',
                                      style: GoogleFonts.manrope(
                                        fontSize: 12,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Text(
                              '${player['total_score'] ?? 0}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            _buildBottomNav('leaderboard', state),
          ],
        ),
      ),
    );
  }

  Widget _buildFinishedScreen(PlayerGameState state) {
    final entries = state.leaderboard?.entries ?? [];
    final myEntry = entries.firstWhere(
      (e) => e['player_id'] == widget.playerId,
      orElse: () => {},
    );
    final rank = myEntry['rank'] ?? (entries.indexOf(myEntry) + 1);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: AppColors.warning,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.emoji_events,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacing10),
                Text(
                  'Quiz Complete!',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing8),
                if (myEntry.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing8,
                      vertical: AppTheme.spacing6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppTheme.borderRadiusXxl,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'You placed',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          '#$rank',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          '${myEntry['total_score'] ?? 0} points',
                          style: GoogleFonts.manrope(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: AppTheme.spacing12),
                ElevatedButton.icon(
                  onPressed: () => context.go('/join'),
                  icon: const Icon(Icons.replay),
                  label: const Text('Play Again'),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CircularTimer extends StatelessWidget {
  final int remainingSeconds;
  final int totalSeconds;

  const _CircularTimer({
    required this.remainingSeconds,
    required this.totalSeconds,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalSeconds > 0 ? remainingSeconds / totalSeconds : 0.0;

    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          SizedBox(
            width: 160,
            height: 160,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: 8,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.surfaceContainerHigh,
              ),
            ),
          ),
          // Progress arc
          SizedBox(
            width: 160,
            height: 160,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 8,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              strokeCap: StrokeCap.round,
            ),
          ),
          // Center content
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$remainingSeconds',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              Text(
                'SECONDS',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
