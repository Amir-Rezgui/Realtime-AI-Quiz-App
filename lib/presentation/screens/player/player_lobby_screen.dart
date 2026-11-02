import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/player_provider.dart';
import '../../providers/game_session_provider.dart';
import '../../providers/quiz_provider.dart';
import '../../../data/models/player_model.dart';
import '../../../data/models/quiz_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class PlayerLobbyScreen extends ConsumerStatefulWidget {
  final String sessionId;
  final String playerId;

  const PlayerLobbyScreen({
    super.key,
    required this.sessionId,
    required this.playerId,
  });

  @override
  ConsumerState<PlayerLobbyScreen> createState() => _PlayerLobbyScreenState();
}

class _PlayerLobbyScreenState extends ConsumerState<PlayerLobbyScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ringController;
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  int _selectedTabIndex = 0;
  int _lastSeenChatCount = 0;
  bool _handledCancellation = false;

  @override
  void initState() {
    super.initState();
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(playerGameProvider.notifier)
          .loadExistingSession(widget.sessionId, widget.playerId);
    });
  }

  @override
  void dispose() {
    _ringController.dispose();
    _chatController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(playerGameProvider);
    final session = ref.watch(sessionProvider(widget.sessionId));
    final players = ref.watch(sessionPlayersProvider(widget.sessionId));

    final AsyncValue<QuizModel> quiz = session.when(
      data: (s) => ref.watch(quizProvider(s.quizId)),
      loading: () => const AsyncValue<QuizModel>.loading(),
      error: (_, __) => const AsyncValue<QuizModel>.loading(),
    );

    ref.listen(playerGameProvider, (previous, next) {
      if (next.phase == GamePhase.question && mounted) {
        context
            .go('/play/${widget.sessionId}/game?playerId=${widget.playerId}');
      } else if (next.phase == GamePhase.cancelled && mounted) {
        if (_handledCancellation) return;
        _handledCancellation = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Host left the session. Redirecting to login...'),
            duration: Duration(seconds: 2),
          ),
        );
        Future.microtask(() => context.go('/login'));
      }

      final previousCount = previous?.chatMessages.length ?? 0;
      final hasNewMessage = next.chatMessages.length > previousCount;
      if (hasNewMessage && mounted) {
        final last =
            next.chatMessages.isNotEmpty ? next.chatMessages.last : null;
        final isOwn = last?.playerId == widget.playerId;
        final isSystem = last?.isSystem ?? false;
        if (_selectedTabIndex != 1 && !isOwn && !isSystem && last != null) {
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

      if (next.chatMessages.length != (previous?.chatMessages.length ?? 0) &&
          _selectedTabIndex == 1 &&
          mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_chatScrollController.hasClients) {
            _chatScrollController.animateTo(
              _chatScrollController.position.maxScrollExtent + 120,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _selectedTabIndex == 0
                  ? _buildLobbyView(state, quiz, players)
                  : _buildChatView(state, quiz),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(state),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacing8,
        AppTheme.spacing8,
        AppTheme.spacing8,
        AppTheme.spacing6,
      ),
      child: Row(
        children: [
          Icon(Icons.videogame_asset_rounded, color: AppColors.primary),
          const SizedBox(width: AppTheme.spacing3),
          Text(
            _selectedTabIndex == 0 ? 'Quiz Lobby' : 'Quiz Subject',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const Spacer(),
          if (_selectedTabIndex == 1)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing5,
                vertical: AppTheme.spacing3,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: AppTheme.borderRadiusXl,
              ),
              child: Row(
                children: [
                  const Icon(Icons.bolt, size: 14, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(
                    'LIVE',
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w700,
                      color: AppColors.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLobbyView(
    PlayerGameState state,
    AsyncValue<QuizModel> quiz,
    AsyncValue<List<PlayerModel>> players,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacing8,
        0,
        AppTheme.spacing8,
        AppTheme.spacing12,
      ),
      child: Column(
        children: [
          const SizedBox(height: AppTheme.spacing6),
          _buildWaitingHero(),
          const SizedBox(height: AppTheme.spacing10),
          _buildConfirmedCard(state),
          const SizedBox(height: AppTheme.spacing10),
          _buildPlayersCard(players),
          const SizedBox(height: AppTheme.spacing10),
          _buildProTipCard(),
          const SizedBox(height: AppTheme.spacing8),
          quiz.when(
            data: (q) => Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppTheme.spacing2),
              child: Text(
                q.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildWaitingHero() {
    return Column(
      children: [
        SizedBox(
          width: 180,
          height: 180,
          child: AnimatedBuilder(
            animation: _ringController,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 132,
                    height: 132,
                    child: CircularProgressIndicator(
                      value: 1,
                      strokeWidth: 11,
                      color: AppColors.primaryContainer.withValues(alpha: 0.45),
                    ),
                  ),
                  Transform.rotate(
                    angle: _ringController.value * 6.28318,
                    child: SizedBox(
                      width: 132,
                      height: 132,
                      child: CircularProgressIndicator(
                        value: 0.33,
                        strokeCap: StrokeCap.round,
                        strokeWidth: 11,
                        color: AppColors.primary,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                  Container(
                    width: 78,
                    height: 78,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                    child: const Icon(
                      Icons.hourglass_bottom_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: AppTheme.spacing8),
        Text(
          'Waiting for Host',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 52,
            fontWeight: FontWeight.w800,
            height: 1.05,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: AppTheme.spacing4),
        Text(
          'Hang tight! The quiz will begin as soon as the host hits the start button.',
          textAlign: TextAlign.center,
          style: GoogleFonts.manrope(
            fontSize: 22,
            color: AppColors.onSurfaceVariant,
            height: 1.35,
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmedCard(PlayerGameState state) {
    final nickname = state.player?.nickname ?? 'Player';
    final letter = nickname.isNotEmpty ? nickname[0].toUpperCase() : 'P';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacing10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withValues(alpha: 0.45),
        borderRadius: AppTheme.borderRadiusXxl,
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 122,
                height: 122,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceContainerLowest,
                  border:
                      Border.all(color: AppColors.primaryContainer, width: 5),
                ),
                child: Center(
                  child: Text(
                    letter,
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.primary,
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: -2,
                bottom: 6,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing6),
          Text(
            'CONFIRMED',
            style: GoogleFonts.manrope(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 3.2,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppTheme.spacing3),
          Text(
            'You are in!',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 44,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppTheme.spacing6),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing8,
              vertical: AppTheme.spacing4,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withValues(alpha: 0.42),
              borderRadius: AppTheme.borderRadiusXl,
            ),
            child: Text(
              nickname,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayersCard(AsyncValue<List<PlayerModel>> players) {
    return players.when(
      data: (playerList) {
        final onlinePlayers = playerList.where((p) => p.isConnected).toList();
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppTheme.spacing8),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: AppTheme.borderRadiusXxl,
            boxShadow: AppColors.ambientShadow,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.groups_rounded, color: AppColors.primary),
                  const SizedBox(width: AppTheme.spacing3),
                  Expanded(
                    child: Text(
                      '${onlinePlayers.length} Players\nJoined',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                  _buildJoinedAvatars(onlinePlayers),
                ],
              ),
              const SizedBox(height: AppTheme.spacing8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: onlinePlayers.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppTheme.spacing4,
                  crossAxisSpacing: AppTheme.spacing4,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  final player = onlinePlayers[index];
                  return _buildPlayerTile(
                      player.nickname, player.id == widget.playerId);
                },
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildJoinedAvatars(List<PlayerModel> players) {
    final preview = players.take(4).toList();
    return Row(
      children: [
        ...preview.map(
          (p) => Transform.translate(
            offset: const Offset(-5, 0),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Center(
                child: Text(
                  p.nickname[0].toUpperCase(),
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w700,
                    color: AppColors.onPrimaryContainer,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (players.length > 4)
          Transform.translate(
            offset: const Offset(-5, 0),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.secondaryContainer,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Center(
                child: Text(
                  '+${players.length - 4}',
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlayerTile(String nickname, bool isCurrentUser) {
    final initial = nickname.isNotEmpty ? nickname[0].toUpperCase() : 'P';
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: AppTheme.borderRadiusXl,
      ),
      padding: const EdgeInsets.all(AppTheme.spacing4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isCurrentUser ? AppColors.primaryContainer : Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initial,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacing3),
          Text(
            nickname,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          if (isCurrentUser) ...[
            const SizedBox(height: 2),
            Text(
              'YOU',
              style: GoogleFonts.manrope(
                fontSize: 10,
                letterSpacing: 1,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProTipCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacing6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withValues(alpha: 0.45),
        borderRadius: AppTheme.borderRadiusXl,
        border:
            Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb, color: AppColors.primary),
          const SizedBox(width: AppTheme.spacing4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PRO TIP',
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing2),
                Text(
                  'Did you know? Answering questions faster gives you more points in the Blitz rounds!',
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatView(PlayerGameState state, AsyncValue<QuizModel> quiz) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacing6,
        0,
        AppTheme.spacing6,
        AppTheme.spacing6,
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _chatScrollController,
              itemCount: state.chatMessages.length,
              padding: const EdgeInsets.only(top: AppTheme.spacing3),
              itemBuilder: (context, index) {
                final chat = state.chatMessages[index];
                if (chat.isSystem) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppTheme.spacing4),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacing6,
                          vertical: AppTheme.spacing5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          borderRadius: AppTheme.borderRadiusXxl,
                        ),
                        child: Column(
                          children: [
                            Text(
                              chat.nickname.toUpperCase(),
                              style: GoogleFonts.manrope(
                                fontSize: 10,
                                letterSpacing: 2,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacing2),
                            Text(
                              chat.message,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 17,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                final isMine = chat.playerId == widget.playerId;
                return _buildChatBubble(chat, isMine);
              },
            ),
          ),
          if (quiz.valueOrNull != null)
            Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacing3),
              child: Text(
                quiz.valueOrNull!.title,
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          _buildChatInput(),
        ],
      ),
    );
  }

  Widget _buildChatBubble(PlayerChatMessage chat, bool isMine) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing3),
      child: Row(
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMine) ...[
            _buildMiniAvatar(chat.nickname),
            const SizedBox(width: AppTheme.spacing3),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  isMine ? 'You' : chat.nickname,
                  style: GoogleFonts.plusJakartaSans(
                    color:
                        isMine ? AppColors.primary : AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing6,
                    vertical: AppTheme.spacing5,
                  ),
                  decoration: BoxDecoration(
                    color: isMine
                        ? AppColors.primary
                        : AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(AppTheme.radiusXl),
                      topRight: const Radius.circular(AppTheme.radiusXl),
                      bottomLeft:
                          Radius.circular(isMine ? AppTheme.radiusXl : 6),
                      bottomRight:
                          Radius.circular(isMine ? 6 : AppTheme.radiusXl),
                    ),
                    boxShadow: isMine ? AppColors.softShadow : null,
                  ),
                  child: Text(
                    chat.message,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      color: isMine ? Colors.white : AppColors.onSurface,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isMine) ...[
            const SizedBox(width: AppTheme.spacing3),
            _buildMiniAvatar(chat.nickname, isMine: true),
          ],
        ],
      ),
    );
  }

  Widget _buildMiniAvatar(String nickname, {bool isMine = false}) {
    final letter = nickname.isNotEmpty ? nickname[0].toUpperCase() : 'P';
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            isMine ? AppColors.primaryContainer : AppColors.secondaryContainer,
        border: isMine
            ? null
            : Border.all(color: AppColors.primaryContainer, width: 2),
      ),
      child: Center(
        child: Text(
          letter,
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing4,
        vertical: AppTheme.spacing3,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withValues(alpha: 0.45),
        borderRadius: AppTheme.borderRadiusXxl,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: null,
            icon: const Icon(Icons.add_circle, color: AppColors.outline),
          ),
          Expanded(
            child: TextField(
              controller: _chatController,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
              decoration: InputDecoration(
                isDense: true,
                fillColor: Colors.transparent,
                hintText: 'Type a message...',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintStyle: GoogleFonts.plusJakartaSans(
                  color: AppColors.outline,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 54,
              height: 54,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;
    ref.read(playerGameProvider.notifier).sendChatMessage(text);
    _chatController.clear();
  }

  Widget _buildBottomNav(PlayerGameState state) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest.withValues(alpha: 0.92),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppTheme.radius3xl),
          topRight: Radius.circular(AppTheme.radius3xl),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacing12,
            vertical: AppTheme.spacing4,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(
                icon: Icons.groups_rounded,
                label: 'Lobby',
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.chat_bubble_rounded,
                label: 'Chat',
                index: 1,
                showBadge: _selectedTabIndex != 1 &&
                    state.chatMessages.length > _lastSeenChatCount,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    bool showBadge = false,
  }) {
    final isSelected = _selectedTabIndex == index;
    return InkWell(
      onTap: () => setState(() {
        _selectedTabIndex = index;
        if (index == 1) {
          _lastSeenChatCount = ref.read(playerGameProvider).chatMessages.length;
        }
      }),
      borderRadius: AppTheme.borderRadiusXl,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing10,
          vertical: AppTheme.spacing4,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryContainer.withValues(alpha: 0.65)
              : null,
          borderRadius: AppTheme.borderRadiusXl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant,
                ),
                if (showBadge)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                letterSpacing: 1,
                color:
                    isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
