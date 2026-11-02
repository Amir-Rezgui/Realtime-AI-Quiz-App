import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/game_session_provider.dart';
import '../../providers/player_provider.dart';
import '../../providers/quiz_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  final String sessionId;
  final bool isHostView;
  final String? currentPlayerId;
  final String playerActiveTab;
  final VoidCallback? onQuizTab;
  final VoidCallback? onLeaderboardTab;
  final VoidCallback? onChatTab;
  final VoidCallback? onNextQuestion;
  final int? nextQuestionCountdownSeconds;
  final VoidCallback? onNextCountdownStarted;

  const LeaderboardScreen({
    super.key,
    required this.sessionId,
    this.isHostView = false,
    this.currentPlayerId,
    this.playerActiveTab = 'leaderboard',
    this.onQuizTab,
    this.onLeaderboardTab,
    this.onChatTab,
    this.onNextQuestion,
    this.nextQuestionCountdownSeconds,
    this.onNextCountdownStarted,
  });

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  int _rankingsPage = 0;

  @override
  Widget build(BuildContext context) {
    final leaderboard = ref.watch(leaderboardProvider(widget.sessionId));
    final playerState = ref.watch(playerGameProvider);
    final hostState =
        widget.isHostView ? ref.watch(hostGameProvider) : const HostGameState();
    final liveSession = ref.watch(sessionProvider(widget.sessionId)).valueOrNull;
    final quizId = liveSession?.quizId ??
        (widget.isHostView ? hostState.session?.quizId : playerState.session?.quizId);
    final quizFromProvider = quizId != null
        ? ref.watch(quizProvider(quizId)).valueOrNull
        : null;
    final computedTotalQuestions = widget.isHostView
        ? (hostState.quiz?.questions.length ??
            quizFromProvider?.questions.length ??
            hostState.quiz?.questionCount ??
            quizFromProvider?.questionCount ??
            0)
        : (quizFromProvider?.questions.length ?? quizFromProvider?.questionCount ?? 0);
    final totalQuestions = computedTotalQuestions > 0 ? computedTotalQuestions : null;
    final payloadRoundNumber = !widget.isHostView
        ? playerState.leaderboard?.roundNumber
        : null;
    final payloadTotalQuestions = !widget.isHostView
        ? playerState.leaderboard?.totalQuestions
        : null;
    final currentIndex = liveSession?.currentQuestionIndex ??
        (widget.isHostView
            ? hostState.session?.currentQuestionIndex
            : playerState.session?.currentQuestionIndex) ??
        playerState.currentQuestion?.questionIndex;
    final completedRound = payloadRoundNumber ?? ((currentIndex ?? -1) + 1);
    final resolvedTotalQuestions = payloadTotalQuestions ?? totalQuestions;
    final roundText = resolvedTotalQuestions == null || completedRound <= 0
        ? 'Round complete'
        : 'Round ${completedRound.clamp(1, resolvedTotalQuestions)} of $resolvedTotalQuestions complete';
    final isRoundLeaderboard = !widget.isHostView &&
        playerState.phase == GamePhase.leaderboard &&
        playerState.session?.status != 'finished';
    final countdown = widget.nextQuestionCountdownSeconds ??
        (isRoundLeaderboard ? playerState.nextQuestionCountdownSeconds : 0);
    final hasStartedCountdown = countdown > 0;
    final realtimeEntries = !widget.isHostView
        ? (playerState.leaderboard?.entries ?? const <Map<String, dynamic>>[])
        : const <Map<String, dynamic>>[];

    return Scaffold(
      backgroundColor: const Color(0xFFF2EAF8),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),

            // Content
            Expanded(
              child: realtimeEntries.isNotEmpty
                  ? _buildLeaderboard(context, realtimeEntries, roundText)
                  : leaderboard.when(
                      data: (entries) => _buildLeaderboard(context, entries, roundText),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(
                        child: Text(
                          'Error: $e',
                          style: GoogleFonts.manrope(color: AppColors.error),
                        ),
                      ),
                    ),
            ),

            // Current Player Card (fixed at bottom)
            if (!widget.isHostView)
              realtimeEntries.isNotEmpty
                  ? _buildCurrentPlayerCard(
                      realtimeEntries,
                      widget.currentPlayerId ?? playerState.player?.id,
                    )
                  : leaderboard.when(
                      data: (entries) => entries.isNotEmpty
                          ? _buildCurrentPlayerCard(
                              entries,
                              widget.currentPlayerId ?? playerState.player?.id,
                            )
                          : const SizedBox.shrink(),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),

            // Progress Bar
            if ((isRoundLeaderboard && hasStartedCountdown) ||
                (widget.isHostView &&
                    widget.onNextQuestion != null &&
                    hasStartedCountdown))
              _buildProgressBar(countdown),

            if (widget.isHostView && widget.onNextQuestion != null)
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing6),
                color: AppColors.surfaceContainerLow,
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                      onPressed: () {
                        if (countdown > 0) return;
                        widget.onNextQuestion?.call();
                        widget.onNextCountdownStarted?.call();
                      },
                    child: Text(
                      countdown > 0
                          ? 'Next Question in ${countdown}s'
                          : 'Next Question',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

            // Bottom Navigation
            _buildBottomNav(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacing6,
        AppTheme.spacing5,
        AppTheme.spacing6,
        AppTheme.spacing3,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF0DCC8),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFAA8CF0), width: 2),
            ),
            child: Center(
              child: Icon(
                Icons.menu_book_rounded,
                color: const Color(0xFF8763DA),
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacing4),
          Text(
            'Kinetic Quiz',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF5E45A1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboard(BuildContext context, List entries, String roundText) {
    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 64,
              color: AppColors.onSurfaceVariant,
            ),
            const SizedBox(height: AppTheme.spacing6),
            Text(
              'No players yet',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing8),
      child: Column(
        children: [
          const SizedBox(height: AppTheme.spacing4),
          Text(
            'Leaderboard',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 48,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2C1A4A),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            roundText,
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B5A8D),
            ),
          ),

          const SizedBox(height: AppTheme.spacing8),

          // Podium
          _buildPodium(entries),

          const SizedBox(height: AppTheme.spacing12),

          // Rankings Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing2),
            child: Row(
              children: [
                Text(
                  'RANKINGS',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    color: const Color(0xFF5D4B80),
                  ),
                ),
                const Spacer(),
                Text(
                  'POINTS',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    color: const Color(0xFF5D4B80),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppTheme.spacing4),

          // Rankings list with pagination (starting from 4th place)
          if (entries.length > 3) ...[
            ..._currentRankingsPage(entries).asMap().entries.map((entry) {
              final index = _rankingsPage * _rankingsPageSize + entry.key + 4;
              final player = entry.value;
              return _buildRankingRow(player, index);
            }),
          ],

          const SizedBox(height: AppTheme.spacing6),

          // Pagination Dots
          if (_rankingsTotalPages(entries) > 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_rankingsTotalPages(entries), (i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: GestureDetector(
                    onTap: () => setState(() => _rankingsPage = i),
                    child: _buildDot(i == _rankingsPage),
                  ),
                );
              }),
            ),

          const SizedBox(height: AppTheme.spacing10),
        ],
      ),
    );
  }

  Widget _buildPodium(List entries) {
    final avatarColors = [
      const Color(0xFF8E9CA9),
      const Color(0xFF5D49A6),
      const Color(0xFFD7B790),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 2nd Place (Left)
        if (entries.length >= 2)
          Expanded(
            child: _buildPodiumPlace(
              entry: entries[1],
              rank: 2,
              avatarColor: avatarColors[0],
              podiumHeight: 116,
              avatarSize: 56,
              showStar: false,
            ),
          )
        else
          const Expanded(child: SizedBox()),

        // 1st Place (Center)
        Expanded(
          child: _buildPodiumPlace(
            entry: entries[0],
            rank: 1,
            avatarColor: avatarColors[1],
            podiumHeight: 156,
            avatarSize: 80,
            showStar: true,
          ),
        ),

        // 3rd Place (Right)
        if (entries.length >= 3)
          Expanded(
            child: _buildPodiumPlace(
              entry: entries[2],
              rank: 3,
              avatarColor: avatarColors[2],
              podiumHeight: 100,
              avatarSize: 56,
              showStar: false,
            ),
          )
        else
          const Expanded(child: SizedBox()),
      ],
    );
  }

  Widget _buildPodiumPlace({
    required dynamic entry,
    required int rank,
    required Color avatarColor,
    required double podiumHeight,
    required double avatarSize,
    required bool showStar,
  }) {
    return Column(
      children: [
        // Star for 1st place
        if (showStar)
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFFD8C4F3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.star_rounded,
              size: 16,
              color: const Color(0xFF8062D8),
            ),
          )
        else
          const SizedBox(height: 28),

        const SizedBox(height: 4),

        // Avatar with ring
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: avatarSize + 8,
              height: avatarSize + 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFBDA0F5),
                  width: 3,
                ),
              ),
              child: Center(
                child: Container(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    color: avatarColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                      child: Text(
                        _entryNickname(entry).substring(0, 1).toUpperCase(),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: avatarSize * 0.4,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Rank badge
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFFC9B0F0),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF4A327E),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: AppTheme.spacing3),

        // Podium base with name and score
        Container(
          height: podiumHeight,
          decoration: BoxDecoration(
            color: const Color(0xFFD7C7EE),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(34),
              topRight: Radius.circular(34),
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _entryNickname(entry),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: rank == 1 ? 16 : 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2C1A4A),
                    ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${_entryTotalScore(entry)}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: rank == 1 ? 18 : 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF5E45A1),
                    ),
                  ),
                ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRankingRow(dynamic entry, int rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing3),
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing6,
        vertical: AppTheme.spacing5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEADFF5),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 44,
            child: Text(
              '$rank',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 34,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF6C588F),
              ),
            ),
          ),

          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFE6D4BA),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _entryNickname(entry).substring(0, 1).toUpperCase(),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF553A8E),
                ),
              ),
            ),
          ),

          const SizedBox(width: AppTheme.spacing4),

          // Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _entryNickname(entry),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D1B4A),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.local_fire_department_rounded,
                      size: 16,
                      color: _entryCurrentStreak(entry) > 0
                          ? const Color(0xFFB42856)
                          : const Color(0xFFB7A9CB),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${_entryCurrentStreak(entry)} STREAK',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _entryCurrentStreak(entry) > 0
                            ? const Color(0xFFB42856)
                            : const Color(0xFFB7A9CB),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Score
          Text(
            _formatScore(_entryTotalScore(entry)),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF5E45A1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.surfaceContainerHigh,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildCurrentPlayerCard(List entries, String? currentPlayerId) {
    if (currentPlayerId == null) return const SizedBox.shrink();
    final currentIndex = entries.indexWhere(
      (entry) => _entryPlayerId(entry) == currentPlayerId,
    );
    if (currentIndex < 0) return const SizedBox.shrink();
    final currentPlayer = entries[currentIndex];
    final currentRank = currentIndex + 1;
    if (currentPlayer == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacing6),
      padding: const EdgeInsets.all(AppTheme.spacing5),
      decoration: BoxDecoration(
        color: const Color(0xFF6D4FB4),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          // Rank
          Text(
            '$currentRank',
              style: GoogleFonts.plusJakartaSans(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),

          const SizedBox(width: AppTheme.spacing4),

          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
                child: Text(
                  _entryNickname(currentPlayer).substring(0, 1).toUpperCase(),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(width: AppTheme.spacing4),

          // Name and stats
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_entryNickname(currentPlayer)} (You)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${_entryCorrectAnswers(currentPlayer)} ${_entryCorrectAnswers(currentPlayer) == 1 ? 'ANSWER' : 'ANSWERS'}',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withValues(alpha: 0.86),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      Icons.local_fire_department_rounded,
                      size: 15,
                      color: _entryCurrentStreak(currentPlayer) > 0
                          ? const Color(0xFFFFD1DF)
                          : Colors.white54,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${_entryCurrentStreak(currentPlayer)} STREAK',
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _entryCurrentStreak(currentPlayer) > 0
                            ? const Color(0xFFFFD1DF)
                            : Colors.white54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Score
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatScore(_entryTotalScore(currentPlayer)),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Text(
                'points',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(int countdown) {
    final safeCountdown = countdown.clamp(0, 10);
    final progress = (10 - safeCountdown) / 10;
    return Container(
      margin: const EdgeInsets.only(
        left: AppTheme.spacing6,
        right: AppTheme.spacing6,
      ),
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacing6,
        AppTheme.spacing4,
        AppTheme.spacing6,
        AppTheme.spacing5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFD8C3F1),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Next question start in',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF60469E),
                ),
              ),
              Text(
                '0:${safeCountdown.toString().padLeft(2, '0')}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF5A497F),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing3),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: const Color(0xFFE8DAF6),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7B63D7)),
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    Future<void> handleHostBackHome() async {
      final discarded = await ref.read(hostGameProvider.notifier).discardSession();
      if (!context.mounted) return;
      if (!discarded) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not close session for players. Try again.'),
          ),
        );
        return;
      }
      context.go('/home');
    }

    if (!widget.isHostView &&
        widget.onQuizTab != null &&
        widget.onLeaderboardTab != null &&
        widget.onChatTab != null) {
      final isQuiz = widget.playerActiveTab == 'quiz';
      final isLeaderboard = widget.playerActiveTab == 'leaderboard';
      final isChat = widget.playerActiveTab == 'chat';
      return Container(
        padding: const EdgeInsets.fromLTRB(
          AppTheme.spacing6,
          AppTheme.spacing4,
          AppTheme.spacing6,
          AppTheme.spacing5,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF0EEF3),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(34),
            topRight: Radius.circular(34),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            isQuiz
                ? _buildNavItemActive(Icons.quiz, 'Quiz', widget.onQuizTab!)
                : _buildNavItem(
                    Icons.quiz_outlined,
                    'Quiz',
                    false,
                    widget.onQuizTab!,
                  ),
            isLeaderboard
                ? _buildNavItemActive(
                    Icons.bar_chart_rounded,
                    'Leaderboard',
                    widget.onLeaderboardTab!,
                  )
                : _buildNavItem(
                    Icons.bar_chart_outlined,
                    'Leaderboard',
                    false,
                    widget.onLeaderboardTab!,
                  ),
            isChat
                ? _buildNavItemActive(Icons.chat_rounded, 'Chat', widget.onChatTab!)
                : _buildNavItem(
                    Icons.chat_bubble_outline_rounded,
                    'Chat',
                    false,
                    widget.onChatTab!,
                  ),
          ],
        ),
      );
    }

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
          _buildNavItem(
            Icons.home_outlined,
            'Home',
            false,
            widget.isHostView ? () => handleHostBackHome() : () => context.go('/home'),
          ),
           _buildNavItemActive(
             Icons.quiz,
             'Quizzes',
             widget.isHostView ? () => handleHostBackHome() : () => context.go('/home'),
           ),
           _buildNavItem(Icons.person_outline, 'Profile', false, () {}),
          ],
        ),
      );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: const Color(0xFF7E6AAB),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF7E6AAB),
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
          horizontal: AppTheme.spacing12,
          vertical: AppTheme.spacing4,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFDCCAF5),
          borderRadius: BorderRadius.circular(26),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF5F49A2), size: 28),
            const SizedBox(width: AppTheme.spacing3),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF5F49A2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const int _rankingsPageSize = 2;

  int _rankingsTotalPages(List entries) {
    final count = entries.length > 3 ? entries.length - 3 : 0;
    if (count <= 0) return 1;
    return (count / _rankingsPageSize).ceil();
  }

  List _currentRankingsPage(List entries) {
    final rankings = entries.length > 3 ? entries.skip(3).toList() : <dynamic>[];
    final totalPages = _rankingsTotalPages(entries);
    final safePage = _rankingsPage.clamp(0, totalPages - 1);
    if (safePage != _rankingsPage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() => _rankingsPage = safePage);
      });
    }
    final start = safePage * _rankingsPageSize;
    final end = (start + _rankingsPageSize).clamp(0, rankings.length);
    return rankings.sublist(start, end);
  }

  String _entryPlayerId(dynamic entry) {
    if (entry is Map<String, dynamic>) {
      return (entry['player_id'] ?? '').toString();
    }
    return (entry.playerId ?? '').toString();
  }

  String _entryNickname(dynamic entry) {
    if (entry is Map<String, dynamic>) {
      final value = (entry['nickname'] ?? '').toString();
      return value.isEmpty ? '?' : value;
    }
    final value = (entry.nickname ?? '').toString();
    return value.isEmpty ? '?' : value;
  }

  int _entryTotalScore(dynamic entry) {
    if (entry is Map<String, dynamic>) {
      return (entry['total_score'] as num?)?.toInt() ?? 0;
    }
    return (entry.totalScore as num?)?.toInt() ?? 0;
  }

  int _entryCurrentStreak(dynamic entry) {
    if (entry is Map<String, dynamic>) {
      return (entry['current_streak'] as num?)?.toInt() ?? 0;
    }
    return (entry.currentStreak as num?)?.toInt() ?? 0;
  }

  int _entryCorrectAnswers(dynamic entry) {
    if (entry is Map<String, dynamic>) {
      return (entry['correct_answers'] as num?)?.toInt() ?? 0;
    }
    return (entry.correctAnswers as num?)?.toInt() ?? 0;
  }

  String _formatScore(int value) {
    final text = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      final char = text[text.length - 1 - i];
      if (i > 0 && i % 3 == 0) buffer.write(',');
      buffer.write(char);
    }
    return buffer.toString().split('').reversed.join();
  }
}
