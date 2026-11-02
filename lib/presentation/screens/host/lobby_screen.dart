import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../providers/game_session_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class LobbyScreen extends ConsumerStatefulWidget {
  final String sessionId;

  const LobbyScreen({super.key, required this.sessionId});

  @override
  ConsumerState<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends ConsumerState<LobbyScreen> {
  int _selectedTabIndex = 0;
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  int _lastSeenChatCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Only load session if not already loaded or if it's a different session
      final currentSession = ref.read(hostGameProvider).session;
      if (currentSession == null || currentSession.id != widget.sessionId) {
        ref.read(hostGameProvider.notifier).loadSession(widget.sessionId);
      }
    });
  }

  @override
  void dispose() {
    _chatController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(hostGameProvider);
    final session = ref.watch(sessionProvider(widget.sessionId));
    final players = ref.watch(sessionPlayersProvider(widget.sessionId));
    final connectedPlayersCount = players.valueOrNull?.length ?? 0;

    ref.listen(hostGameProvider, (previous, next) {
      final previousCount = previous?.chatMessages.length ?? 0;
      final hasNewMessage = next.chatMessages.length > previousCount;
      if (!mounted || !hasNewMessage || next.chatMessages.isEmpty) return;

      final last = next.chatMessages.last;
      final isOwnHostMessage = last.playerId.startsWith('host:');
      if (_selectedTabIndex != 1 && !isOwnHostMessage && !last.isSystem) {
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

      if (_selectedTabIndex == 1) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_chatScrollController.hasClients) {
            _chatScrollController.animateTo(
              _chatScrollController.position.maxScrollExtent + 100,
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF3ECFA),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  // Header with Game Pin
                  _buildHeader(session),

                  Expanded(
                    child: _selectedTabIndex == 1
                        ? _buildChatView(state)
                        : SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacing6,
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: AppTheme.spacing6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppTheme.spacing6,
                                    vertical: AppTheme.spacing3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE7D9F6),
                                    borderRadius: AppTheme.borderRadiusXl,
                                  ),
                                  child: Text(
                                    '• HOST LOBBY',
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF6A4E9B),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppTheme.spacing6),
                                Text(
                                  'Prepare to Start',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 44,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF2E1A52),
                                  ),
                                ),
                                const SizedBox(height: AppTheme.spacing2),
                                Text(
                                  'Reviewing your lineup of scholars...',
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    color: const Color(0xFF6D5A87),
                                  ),
                                ),
                                const SizedBox(height: AppTheme.spacing10),
                                Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.all(AppTheme.spacing8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEADFF4),
                                    borderRadius: AppTheme.borderRadiusXxl,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$connectedPlayersCount',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 56,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF9C86C6),
                                        ),
                                      ),
                                      Text(
                                        'Players Joined',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF24143F),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: AppTheme.spacing8),
                                session.when(
                                  data: (s) => GestureDetector(
                                    onTap: () => _copyCode(s.joinCode),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(
                                          AppTheme.spacing10),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: AppTheme.borderRadiusXxl,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primary
                                                .withValues(alpha: 0.25),
                                            blurRadius: 18,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 160,
                                            height: 160,
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: QrImageView(
                                              data: s.joinCode.toUpperCase(),
                                              version: QrVersions.auto,
                                              eyeStyle: const QrEyeStyle(
                                                color: AppColors.primary,
                                                eyeShape: QrEyeShape.square,
                                              ),
                                              dataModuleStyle:
                                                  const QrDataModuleStyle(
                                                color: AppColors.primary,
                                                dataModuleShape:
                                                    QrDataModuleShape.square,
                                              ),
                                              backgroundColor: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(
                                              height: AppTheme.spacing4),
                                          Text(
                                            'SCAN TO JOIN',
                                            style: GoogleFonts.manrope(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 3,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Point your camera here',
                                            style: GoogleFonts.manrope(
                                              fontSize: 13,
                                              color: Colors.white
                                                  .withValues(alpha: 0.75),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  loading: () => const SizedBox.shrink(),
                                  error: (_, __) => const SizedBox.shrink(),
                                ),
                                const SizedBox(height: AppTheme.spacing8),
                                players.when(
                                  data: (playerList) => playerList.isEmpty
                                      ? _buildEmptyPlayers()
                                      : _buildPlayerGrid(playerList),
                                  loading: () => const Center(
                                      child: CircularProgressIndicator()),
                                  error: (_, __) => _buildEmptyPlayers(),
                                ),
                                const SizedBox(height: AppTheme.spacing8),
                                Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.all(AppTheme.spacing6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE2D0F2),
                                    borderRadius: AppTheme.borderRadiusXxl,
                                    border: Border(
                                      left: BorderSide(
                                        color: AppColors.primary,
                                        width: 3,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.lightbulb,
                                        size: 18,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: AppTheme.spacing4),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Host Insight',
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: const Color(0xFF251740),
                                              ),
                                            ),
                                            Text(
                                              'You can kick players from the lobby once everyone is ready.',
                                              style: GoogleFonts.manrope(
                                                fontSize: 13,
                                                color: const Color(0xFF5E4A7E),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: AppTheme.spacing10),
                              ],
                            ),
                          ),
                  ),

                  // Start Button (Host only)
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacing6),
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
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: connectedPlayersCount >= 2
                            ? () => _startGame(connectedPlayersCount)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                          disabledBackgroundColor:
                              AppColors.surfaceContainerHigh,
                          disabledForegroundColor: AppColors.onSurfaceVariant,
                          padding: const EdgeInsets.symmetric(
                              vertical: AppTheme.spacing6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          connectedPlayersCount >= 2
                              ? '▶  START QUIZ'
                              : 'Waiting for at least 2 players...',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Bottom Navigation
                  _buildBottomNav(state),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader(AsyncValue session) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacing6),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              await ref.read(hostGameProvider.notifier).discardSession();
              if (!context.mounted) return;
              context.go('/home');
            },
            child: Icon(
              Icons.arrow_back,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppTheme.spacing4),
          Expanded(
            child: session.when(
              data: (s) => Text(
                'PIN:${_formatCode(s.joinCode)}',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              loading: () => Text(
                'Loading...',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ),
          // Discard session button
          IconButton(
            onPressed: () => _showDiscardDialog(),
            icon: Icon(
              Icons.cancel_outlined,
              color: AppColors.error,
            ),
            tooltip: 'Discard Session',
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildEmptyPlayers() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing10),
      child: Column(
        children: [
          Icon(
            Icons.people_outline,
            size: 48,
            color: AppColors.onSurfaceVariant,
          ),
          const SizedBox(height: AppTheme.spacing4),
          Text(
            'No players yet',
            style: GoogleFonts.manrope(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerGrid(List players) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppTheme.spacing4,
        mainAxisSpacing: AppTheme.spacing4,
        childAspectRatio: 0.9,
      ),
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFFECE2F5),
            borderRadius: AppTheme.borderRadiusXl,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    player.nickname.substring(0, 1).toUpperCase(),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacing4),
              Text(
                player.nickname,
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF261842),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomNav(HostGameState state) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing4),
      decoration: BoxDecoration(
        color: const Color(0xFFECE2F5),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.people, 'Lobby', 0),
          _buildNavItem(
            Icons.chat_bubble_outline,
            'Chat',
            1,
            showBadge: _selectedTabIndex != 1 &&
                state.chatMessages.length > _lastSeenChatCount,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    int index, {
    bool showBadge = false,
  }) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedTabIndex = index;
        if (index == 1) {
          _lastSeenChatCount = ref.read(hostGameProvider).chatMessages.length;
        }
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD8C5F1) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant,
                  size: 20,
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
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color:
                    isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatView(HostGameState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing6),
      child: Column(
        children: [
          const SizedBox(height: AppTheme.spacing4),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Quiz Subject',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 42,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing5,
                  vertical: AppTheme.spacing3,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFA58AEC),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.flash_on,
                        size: 14, color: Color(0xFF261842)),
                    const SizedBox(width: 4),
                    Text(
                      'LIVE',
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF261842),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing8),
          Expanded(
            child: ListView.builder(
              controller: _chatScrollController,
              itemCount: state.chatMessages.length,
              itemBuilder: (context, index) {
                final message = state.chatMessages[index];
                if (message.isSystem) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppTheme.spacing4),
                    child: Center(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppTheme.spacing6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9C5F2),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'SYSTEM UPDATE',
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              message.message,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF2A1846),
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                final isHost = message.playerId.startsWith('host:');
                final isYou = isHost;

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: AppTheme.spacing3),
                  child: Column(
                    crossAxisAlignment: isYou
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        isYou ? 'You' : message.nickname,
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF5D4A7D),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: isYou
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (!isYou) ...[
                            Container(
                              width: 36,
                              height: 36,
                              margin: const EdgeInsets.only(
                                  right: AppTheme.spacing3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE7D9F6),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.25),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  message.nickname
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppTheme.spacing6,
                                vertical: AppTheme.spacing5,
                              ),
                              decoration: BoxDecoration(
                                color: isYou
                                    ? AppColors.primary
                                    : const Color(0xFFEADFF4),
                                borderRadius: BorderRadius.circular(28),
                              ),
                              child: Text(
                                message.message,
                                style: GoogleFonts.plusJakartaSans(
                                  color: isYou
                                      ? Colors.white
                                      : const Color(0xFF24143F),
                                  fontSize: 18,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ),
                          if (isYou) ...[
                            const SizedBox(width: AppTheme.spacing3),
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE7D9F6),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.25),
                                ),
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 18,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: AppTheme.spacing3,
              bottom: AppTheme.spacing6,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing3,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFD9C5F2),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.12),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add_circle, size: 30),
                  color: const Color(0xFF8A72C8),
                ),
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendHostMessage(),
                    style: GoogleFonts.plusJakartaSans(fontSize: 18),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF9B8AB9),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _sendHostMessage,
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send_rounded, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendHostMessage() {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;
    ref.read(hostGameProvider.notifier).sendChatMessage(
          nickname: 'Host',
          message: text,
        );
    _chatController.clear();
  }

  String _formatCode(String code) {
    if (code.length == 6) {
      return '${code.substring(0, 3)}-${code.substring(3)}';
    }
    return code;
  }

  void _copyCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Code copied to clipboard', style: GoogleFonts.manrope()),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppTheme.borderRadiusMd),
      ),
    );
  }

  Future<void> _startGame(int connectedPlayersCount) async {
    if (connectedPlayersCount < 2) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'At least 2 players are required to start the quiz.',
            style: GoogleFonts.manrope(),
          ),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: AppTheme.borderRadiusMd),
        ),
      );
      return;
    }

    await ref.read(hostGameProvider.notifier).startGame();
    if (mounted) {
      context.go('/host/${widget.sessionId}/game');
    }
  }

  Future<void> _showDiscardDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Discard Session',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to discard this game session? All players will be disconnected and the session will be cancelled.',
          style: GoogleFonts.manrope(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(hostGameProvider.notifier).discardSession();
      if (mounted) {
        context.go('/home');
      }
    }
  }
}
