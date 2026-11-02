import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';
import '../../providers/quiz_provider.dart';
import '../../providers/game_session_provider.dart';
import '../../providers/settings_provider.dart';
import '../../../data/models/quiz_model.dart';
import '../../../data/models/game_session_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/quiz_categories.dart';
import '../../../data/repositories/quiz_repository.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  String? _publishingQuizId;

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(currentProfileProvider);
    final quizzes = ref.watch(myQuizzesProvider);
    final sessions = ref.watch(mySessionsLiveProvider);
    final playerCounts = ref.watch(mySessionPlayerCountsProvider);
    final hostState = ref.watch(hostGameProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: _selectedIndex == 0
            ? _buildHomeContent(
                context,
                profile,
                quizzes,
                sessions,
                playerCounts,
                hostState,
              )
            : _selectedIndex == 1
                ? _buildQuizzesContent(context, quizzes)
                : _buildProfileContent(context, profile),
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/quiz/new'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildHomeContent(
    BuildContext context,
    AsyncValue profile,
    AsyncValue<List<QuizModel>> quizzes,
    AsyncValue<List<GameSessionModel>> sessions,
    AsyncValue<Map<String, int>> playerCounts,
    HostGameState hostState,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(profile),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroCard(context),
                const SizedBox(height: AppTheme.spacing12),
                _buildStatsRow(quizzes, sessions, playerCounts, hostState),
                const SizedBox(height: AppTheme.spacing12),
                _buildMyQuizzesSection(context, quizzes),
                const SizedBox(height: AppTheme.spacing20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AsyncValue profile) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacing8),
      child: Row(
        children: [
          InkWell(
            borderRadius: AppTheme.borderRadiusMd,
            onTap: () => setState(() => _selectedIndex = 2),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: AppTheme.borderRadiusMd,
              ),
              child: Center(
                child: profile.when(
                  data: (p) => Text(
                    p?.displayName?.substring(0, 1).toUpperCase() ?? 'U',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  loading: () => const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  error: (_, __) =>
                      const Icon(Icons.person, color: AppColors.primary),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacing6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'QuizNova Studio',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                profile.when(
                  data: (p) => Text(
                    'Welcome back, ${p?.displayName ?? 'Creator'}',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacing12),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: AppTheme.borderRadius3xl,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing4,
              vertical: AppTheme.spacing2,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: AppTheme.borderRadiusSm,
            ),
            child: Text(
              'CREATOR DASHBOARD',
              style: GoogleFonts.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            'Design quizzes your\nplayers will love',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              height: 1.15,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppTheme.spacing6),
          Text(
            'Craft engaging questions, launch fast,\nand track live participation.',
            style: GoogleFonts.manrope(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.85),
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppTheme.spacing10),
          ElevatedButton.icon(
            onPressed: () => context.go('/quiz/new'),
            icon: const Icon(Icons.add, size: 20),
            label: const Text('Create New Quiz'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              elevation: 0,
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
    );
  }

  Widget _buildStatsRow(
    AsyncValue<List<QuizModel>> quizzes,
    AsyncValue<List<GameSessionModel>> sessions,
    AsyncValue<Map<String, int>> playerCounts,
    HostGameState hostState,
  ) {
    bool isActiveStatus(GameSessionModel s) =>
        s.status == GameStatus.lobby ||
        s.status == GameStatus.inProgress ||
        s.status == GameStatus.questionActive ||
        s.status == GameStatus.showingResults;

    final allQuizzes = quizzes.valueOrNull ?? const <QuizModel>[];
    final allSessions = sessions.valueOrNull ?? const <GameSessionModel>[];
    final liveCounts = playerCounts.valueOrNull ?? const <String, int>{};
    final latestActiveSessionByQuizId = <String, GameSessionModel>{};
    for (final session in allSessions) {
      if (!isActiveStatus(session)) continue;
      final current = latestActiveSessionByQuizId[session.quizId];
      if (current == null) {
        latestActiveSessionByQuizId[session.quizId] = session;
        continue;
      }
      final currentTime =
          current.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final candidateTime =
          session.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      if (candidateTime.isAfter(currentTime)) {
        latestActiveSessionByQuizId[session.quizId] = session;
      }
    }
    final latestActiveSessions = latestActiveSessionByQuizId.values.toList();

    final totalPlayers = latestActiveSessions.fold<int>(
      0,
      (sum, session) =>
          sum +
          (liveCounts[session.id] ?? (session.playerCount - 1).clamp(0, 99999)),
    );

    final activeQuizIds = <String>{};
    for (final session in latestActiveSessions) {
      final isCurrentHostSession = hostState.session?.id == session.id;
      final connectedPlayers = isCurrentHostSession
          ? hostState.totalPlayers
          : (liveCounts[session.id] ??
              (session.playerCount - 1).clamp(0, 99999));
      if (connectedPlayers > 0) {
        activeQuizIds.add(session.quizId);
      }
    }

    final playedPublishedQuizIds =
        allSessions.map((session) => session.quizId).toSet();
    final publishedQuizIds = allQuizzes
        .where((quiz) => quiz.isPublished)
        .map((quiz) => quiz.id)
        .toSet();
    final playedPublishedCount = publishedQuizIds
        .where((quizId) => playedPublishedQuizIds.contains(quizId))
        .length;

    final completionRate = publishedQuizIds.isEmpty
        ? 0
        : ((playedPublishedCount / publishedQuizIds.length) * 100).round();

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.people_outline,
            iconColor: AppColors.primary,
            iconBgColor: AppColors.primaryContainer,
            value: '$totalPlayers',
            label: 'Total Players',
          ),
        ),
        const SizedBox(width: AppTheme.spacing4),
        Expanded(
          child: _buildStatCard(
            icon: Icons.bolt,
            iconColor: AppColors.secondary,
            iconBgColor: AppColors.secondaryContainer,
            value: '${activeQuizIds.length}',
            label: 'Active Quizzes',
          ),
        ),
        const SizedBox(width: AppTheme.spacing4),
        Expanded(
          child: _buildStatCard(
            icon: Icons.auto_awesome,
            iconColor: AppColors.success,
            iconBgColor: AppColors.success.withValues(alpha: 0.15),
            value: '$completionRate%',
            label: 'Completion Rate',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String value,
    required String label,
    String? trend,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: AppTheme.borderRadiusXl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing2),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: AppTheme.borderRadiusSm,
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              if (trend != null)
                Text(
                  trend,
                  style: GoogleFonts.manrope(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: AppColors.success,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing4),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 11,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyQuizzesSection(BuildContext context, AsyncValue quizzes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Quizzes',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                Text(
                  'Manage and monitor your\ncurated galleries.',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    color: AppColors.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {},
              child: Row(
                children: [
                  Text(
                    'View\nArchive',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: AppColors.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacing8),
        quizzes.when(
          data: (quizList) => quizList.isEmpty
              ? _buildEmptyQuizzes(context)
              : Column(
                  children: quizList
                      .map<Widget>((quiz) => _buildQuizCard(context, ref, quiz))
                      .toList(),
                ),
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, _) => _buildErrorState(error.toString()),
        ),
      ],
    );
  }

  Widget _buildEmptyQuizzes(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: AppTheme.borderRadiusXxl,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing8),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.quiz_outlined,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            'No quizzes yet',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppTheme.spacing2),
          Text(
            'Create your first quiz to get started',
            style: GoogleFonts.manrope(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppTheme.spacing8),
          ElevatedButton.icon(
            onPressed: () => context.go('/quiz/new'),
            icon: const Icon(Icons.add),
            label: const Text('Create Quiz'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizCard(BuildContext context, WidgetRef ref, QuizModel quiz) {
    final gradients = [
      AppColors.primaryGradient,
      AppColors.secondaryGradient,
      const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1F2A44), Color(0xFF0D111E)],
      ),
    ];
    final gradientIndex = quiz.id.hashCode % gradients.length;
    final category = QuizCategories.getById(quiz.category);
    final categoryImage = quiz.bannerImageUrl?.isNotEmpty == true
        ? quiz.bannerImageUrl
        : category?.imagePath;
    final questionCount =
        quiz.questionCount > 0 ? quiz.questionCount : quiz.questions.length;

    final hostState = ref.watch(hostGameProvider);
    final allSessions = ref.watch(mySessionsLiveProvider).valueOrNull ??
        const <GameSessionModel>[];
    final liveCounts = ref.watch(mySessionPlayerCountsProvider).valueOrNull ??
        const <String, int>{};
    GameSessionModel? latestActiveQuizSession;
    for (final session in allSessions.where((s) =>
        s.quizId == quiz.id &&
        (s.status == GameStatus.lobby ||
            s.status == GameStatus.inProgress ||
            s.status == GameStatus.questionActive ||
            s.status == GameStatus.showingResults))) {
      final current = latestActiveQuizSession;
      if (current == null) {
        latestActiveQuizSession = session;
        continue;
      }
      final currentTime =
          current.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final candidateTime =
          session.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      if (candidateTime.isAfter(currentTime)) {
        latestActiveQuizSession = session;
      }
    }
    final totalPlayersForQuiz = latestActiveQuizSession == null
        ? 0
        : (liveCounts[latestActiveQuizSession.id] ??
            (latestActiveQuizSession.playerCount - 1).clamp(0, 99999));
    final isCurrentActiveHostSession = hostState.session != null &&
        latestActiveQuizSession != null &&
        hostState.session!.id == latestActiveQuizSession.id;
    final isInLobby = latestActiveQuizSession?.status == GameStatus.lobby;
    final isStarted = latestActiveQuizSession != null &&
        (latestActiveQuizSession!.status == GameStatus.inProgress ||
            latestActiveQuizSession.status == GameStatus.questionActive ||
            latestActiveQuizSession.status == GameStatus.showingResults);
    final displayedPlayers = isCurrentActiveHostSession
        ? hostState.totalPlayers
        : totalPlayersForQuiz;
    final actionLabel = isStarted
        ? 'Live Quiz'
        : isInLobby
            ? 'Go Lobby'
            : _publishingQuizId == quiz.id
                ? 'Starting...'
                : 'Start Quiz';

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3ECFA),
        borderRadius: AppTheme.borderRadiusXxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppTheme.radiusXxl),
              topRight: Radius.circular(AppTheme.radiusXxl),
            ),
            child: SizedBox(
              height: 190,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: categoryImage == null
                        ? DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: gradients[gradientIndex],
                            ),
                          )
                        : categoryImage.startsWith('http')
                            ? Image.network(
                                categoryImage,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: gradients[gradientIndex],
                                  ),
                                ),
                              )
                            : Image.asset(
                                categoryImage,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: gradients[gradientIndex],
                                  ),
                                ),
                              ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.10),
                            Colors.black.withValues(alpha: 0.45),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: AppTheme.spacing4,
                    bottom: AppTheme.spacing6,
                    child: Row(
                      children: [
                        _buildGlassIconButton(
                          icon: Icons.edit_rounded,
                          onTap: () => context.go('/quiz/${quiz.id}'),
                        ),
                        const SizedBox(width: AppTheme.spacing2),
                        _buildGlassIconButton(
                          icon: Icons.delete,
                          color: const Color(0xFF4E0E25),
                          onTap: () =>
                              _deleteQuiz(context, ref, quiz.id, quiz.title),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: AppTheme.spacing6,
                    bottom: AppTheme.spacing6,
                    child: Row(
                      children: [
                        if (category != null)
                          _buildChip(category.name, Colors.white),
                        if (category != null)
                          const SizedBox(width: AppTheme.spacing2),
                        _buildChip('$questionCount Questions', Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacing8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quiz.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF3F2A5B),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing4),
                Text(
                  (quiz.description?.isNotEmpty == true)
                      ? quiz.description!
                      : 'Challenge your audience with this engaging quiz experience.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    color: const Color(0xFF6D5B84),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing8),
                Divider(
                  height: 1,
                  color: AppColors.outlineVariant.withValues(alpha: 0.25),
                ),
                const SizedBox(height: AppTheme.spacing8),
                Row(
                  children: [
                    _buildAudienceAvatars(displayedPlayers),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _publishingQuizId == quiz.id
                          ? null
                          : isStarted
                              ? () => context.go(
                                  '/host/${latestActiveQuizSession!.id}/game')
                              : isInLobby
                                  ? () => context.go(
                                      '/host/${latestActiveQuizSession!.id}/lobby')
                                  : () => _publishQuiz(context, ref, quiz.id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            AppColors.primary.withValues(alpha: 0.45),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacing12,
                          vertical: AppTheme.spacing4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Text(
                        actionLabel,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String text, Color bgColor) {
    final isLightChip = bgColor.computeLuminance() > 0.8;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing4,
        vertical: AppTheme.spacing2,
      ),
      decoration: BoxDecoration(
        color: isLightChip ? Colors.white : bgColor.withValues(alpha: 0.2),
        borderRadius: AppTheme.borderRadiusSm,
        border: Border.all(
          color: isLightChip
              ? Colors.white.withValues(alpha: 0.75)
              : bgColor.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.manrope(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isLightChip ? const Color(0xFF4B3B68) : bgColor,
        ),
      ),
    );
  }

  Widget _buildGlassIconButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: (color ?? Colors.black).withValues(alpha: 0.55),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: Colors.white),
      ),
    );
  }

  Widget _buildPlayerAvatarCircle(Color color) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }

  Widget _buildAudienceAvatars(int playerCount) {
    if (playerCount <= 0) {
      return const SizedBox(width: 1, height: 38);
    }

    final hasOverflow = playerCount > 2;
    final overflowCount = playerCount - 2;

    return SizedBox(
      width: hasOverflow ? 102 : 72,
      height: 38,
      child: Stack(
        children: [
          _buildPlayerAvatarCircle(const Color(0xFF9F8CFF)),
          if (playerCount > 1)
            Positioned(
              left: 24,
              child: _buildPlayerAvatarCircle(const Color(0xFFD6C7FF)),
            ),
          if (hasOverflow)
            Positioned(
              left: 48,
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFF78DBA),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    '+$overflowCount',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF5E2A49),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing8),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: AppTheme.borderRadiusLg,
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error),
          const SizedBox(width: AppTheme.spacing4),
          Expanded(
            child: Text(
              'Error: $error',
              style: GoogleFonts.manrope(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizzesContent(BuildContext context, AsyncValue quizzes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppTheme.spacing8),
          child: Text(
            'All Quizzes',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
        ),
        Expanded(
          child: quizzes.when(
            data: (quizList) => quizList.isEmpty
                ? _buildEmptyQuizzes(context)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing8),
                    itemCount: quizList.length,
                    itemBuilder: (context, index) =>
                        _buildQuizCard(context, ref, quizList[index]),
                  ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) =>
                Center(child: _buildErrorState(error.toString())),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileContent(BuildContext context, AsyncValue profile) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacing8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppTheme.spacing12),
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing10),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: AppTheme.borderRadiusXxl,
            ),
            child: profile.when(
              data: (p) => Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        p?.displayName?.substring(0, 1).toUpperCase() ?? 'U',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing6),
                  Text(
                    p?.displayName ?? 'User',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                  Text(
                    p?.email ?? '',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Text('Error loading profile'),
            ),
          ),
          const SizedBox(height: AppTheme.spacing8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: AppTheme.borderRadiusXl,
            ),
            child: Column(
              children: [
                _buildProfileOption(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  onTap: () => _showSettingsDialog(context),
                ),
                Divider(
                    height: 1,
                    color: AppColors.outlineVariant.withValues(alpha: 0.2)),
                _buildProfileOption(
                  icon: Icons.help_outline,
                  label: 'Help & Support',
                  onTap: () {},
                ),
                Divider(
                    height: 1,
                    color: AppColors.outlineVariant.withValues(alpha: 0.2)),
                _buildProfileOption(
                  icon: Icons.auto_awesome_rounded,
                  label: 'AI Generation',
                  onTap: () => _showAiSettingsDialog(context),
                ),
                Divider(
                    height: 1,
                    color: AppColors.outlineVariant.withValues(alpha: 0.2)),
                _buildProfileOption(
                  icon: Icons.logout,
                  label: 'Sign Out',
                  isDestructive: true,
                  onTap: () async {
                    await ref.read(authNotifierProvider.notifier).signOut();
                    if (context.mounted) {
                      context.go('/login');
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppColors.error : AppColors.onSurfaceVariant,
      ),
      title: Text(
        label,
        style: GoogleFonts.manrope(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: isDestructive ? AppColors.error : AppColors.onSurface,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: isDestructive ? AppColors.error : AppColors.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacing8,
            vertical: AppTheme.spacing4,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.quiz_outlined,
                activeIcon: Icons.quiz,
                label: 'Quizzes',
                index: 1,
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
                index: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showSettingsDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Settings',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
          ),
          content: Text(
            'Coming Soon',
            style: GoogleFonts.manrope(),
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAiSettingsDialog(BuildContext context) async {
    final aiSettings = ref.read(aiGenerationSettingsProvider);
    final apiUrlController = TextEditingController(text: aiSettings.apiUrl);
    final apiKeyController = TextEditingController(text: aiSettings.apiKey);
    final modelController = TextEditingController(text: aiSettings.modelName);

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'AI Generation Settings',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: apiUrlController,
                decoration: const InputDecoration(
                  labelText: 'API URL',
                  helperText:
                      'For Flutter Web, use your proxy/edge function URL.',
                ),
              ),
              const SizedBox(height: AppTheme.spacing4),
              TextField(
                controller: apiKeyController,
                decoration: const InputDecoration(labelText: 'API Key'),
                obscureText: true,
              ),
              const SizedBox(height: AppTheme.spacing4),
              TextField(
                controller: modelController,
                decoration: const InputDecoration(labelText: 'Model Name'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              await ref.read(aiGenerationSettingsProvider.notifier).update(
                    apiUrl: apiUrlController.text,
                    apiKey: apiKeyController.text,
                    modelName: modelController.text,
                  );
              if (context.mounted) Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    apiUrlController.dispose();
    apiKeyController.dispose();
    modelController.dispose();
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      borderRadius: AppTheme.borderRadiusMd,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing8,
          vertical: AppTheme.spacing4,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color:
                  isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color:
                    isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _publishQuiz(
    BuildContext context,
    WidgetRef ref,
    String quizId,
  ) async {
    final quizzes =
        ref.read(myQuizzesProvider).valueOrNull ?? const <QuizModel>[];
    QuizModel? targetQuiz;
    for (final quiz in quizzes) {
      if (quiz.id == quizId) {
        targetQuiz = quiz;
        break;
      }
    }
    final questionCount =
        targetQuiz?.questionCount ?? targetQuiz?.questions.length ?? 0;
    if (questionCount < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Quiz must contain at least one question before publishing.'),
        ),
      );
      return;
    }

    if (mounted) {
      setState(() {
        _publishingQuizId = quizId;
      });
    }

    try {
      final session =
          await ref.read(hostGameProvider.notifier).getOrCreateSession(quizId);

      if (!context.mounted) {
        return;
      }

      if (session == null) {
        final providerError = ref.read(hostGameProvider).error;
        final friendlyMessage = providerError != null &&
                providerError.toLowerCase().contains('websocket')
            ? 'Lobby created, but live connection failed. Check internet/VPN and retry from Lobby.'
            : providerError ?? 'Unable to publish quiz. Please try again.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(friendlyMessage),
          ),
        );
        return;
      }

      final providerError = ref.read(hostGameProvider).error;
      if (providerError != null &&
          providerError.toLowerCase().contains('websocket') &&
          context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Lobby opened. Realtime unavailable (WebSocket). Some live updates may be delayed.',
            ),
          ),
        );
      }

      if (session.status == GameStatus.lobby) {
        context.go('/host/${session.id}/lobby');
      } else {
        context.go('/host/${session.id}/game');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error publishing quiz: $e')),
        );
      }
    } finally {
      if (mounted && _publishingQuizId == quizId) {
        setState(() {
          _publishingQuizId = null;
        });
      }
    }
  }

  Future<void> _deleteQuiz(
    BuildContext context,
    WidgetRef ref,
    String quizId,
    String quizTitle,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Quiz'),
        content: Text(
            'Are you sure you want to delete "$quizTitle"? This action cannot be undone.'),
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

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(quizRepositoryProvider).deleteQuiz(quizId);
        ref.invalidate(myQuizzesProvider);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Quiz deleted successfully')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting quiz: $e')),
          );
        }
      }
    }
  }
}
