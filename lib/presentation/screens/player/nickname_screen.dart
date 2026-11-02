import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/player_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class NicknameScreen extends ConsumerStatefulWidget {
  final String joinCode;

  const NicknameScreen({super.key, required this.joinCode});

  @override
  ConsumerState<NicknameScreen> createState() => _NicknameScreenState();
}

class _NicknameScreenState extends ConsumerState<NicknameScreen> {
  final _nicknameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Suggested nicknames for fun
  final List<String> _suggestions = [
    'QuizMaster',
    'BrainWave',
    'StarPlayer',
    'ThinkTank',
    'QuickMind',
  ];

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(playerGameProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacing8),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: AppTheme.borderRadiusMd,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
                      onPressed: () => context.go('/join'),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing6,
                      vertical: AppTheme.spacing3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: AppTheme.borderRadiusMd,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.confirmation_number_outlined,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppTheme.spacing2),
                        Text(
                          widget.joinCode,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: AppTheme.spacing12),

                      // Avatar Circle
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: AppColors.secondaryGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.secondary.withValues(alpha: 0.3),
                              blurRadius: 24,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _nicknameController.text.isEmpty
                                ? '?'
                                : _nicknameController.text.substring(0, 1).toUpperCase(),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 48,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: AppTheme.spacing12),

                      // Title
                      Text(
                        'What\'s Your\nName?',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                          color: AppColors.onSurface,
                        ),
                      ),

                      const SizedBox(height: AppTheme.spacing4),

                      Text(
                        'Choose a nickname that will appear\non the leaderboard.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.manrope(
                          fontSize: 15,
                          color: AppColors.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: AppTheme.spacing12),

                      // Nickname Input
                      Container(
                        padding: const EdgeInsets.all(AppTheme.spacing8),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest,
                          borderRadius: AppTheme.borderRadiusXxl,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _nicknameController,
                              textAlign: TextAlign.center,
                              textCapitalization: TextCapitalization.words,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onSurface,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter nickname',
                                hintStyle: GoogleFonts.plusJakartaSans(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                                ),
                                filled: true,
                                fillColor: AppColors.surfaceContainerLow,
                                border: OutlineInputBorder(
                                  borderRadius: AppTheme.borderRadiusXl,
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.spacing8,
                                  vertical: AppTheme.spacing8,
                                ),
                                counterText: '',
                              ),
                              maxLength: AppConstants.maxNicknameLength,
                              onChanged: (_) => setState(() {}),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter a nickname';
                                }
                                if (value.trim().length < AppConstants.minNicknameLength) {
                                  return 'At least ${AppConstants.minNicknameLength} characters';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) => _handleSubmit(),
                            ),

                            const SizedBox(height: AppTheme.spacing6),

                            // Suggestions
                            Text(
                              'SUGGESTIONS',
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacing4),
                            Wrap(
                              spacing: AppTheme.spacing3,
                              runSpacing: AppTheme.spacing3,
                              children: _suggestions.map((name) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _nicknameController.text = name;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppTheme.spacing5,
                                      vertical: AppTheme.spacing3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceContainerLow,
                                      borderRadius: AppTheme.borderRadiusMd,
                                    ),
                                    child: Text(
                                      name,
                                      style: GoogleFonts.manrope(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),

                      if (state.error != null) ...[
                        const SizedBox(height: AppTheme.spacing6),
                        Container(
                          padding: const EdgeInsets.all(AppTheme.spacing6),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.1),
                            borderRadius: AppTheme.borderRadiusLg,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: AppColors.error,
                                size: 20,
                              ),
                              const SizedBox(width: AppTheme.spacing4),
                              Expanded(
                                child: Text(
                                  state.error!,
                                  style: GoogleFonts.manrope(
                                    fontSize: 13,
                                    color: AppColors.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: AppTheme.spacing10),

                      // Join Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state.isLoading ? null : _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing8),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppTheme.borderRadiusXl,
                            ),
                            elevation: 0,
                          ),
                          child: state.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Enter Lobby',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: AppTheme.spacing3),
                                    const Icon(Icons.arrow_forward, size: 20),
                                  ],
                                ),
                        ),
                      ),

                      const SizedBox(height: AppTheme.spacing16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(playerGameProvider.notifier)
        .setNickname(_nicknameController.text.trim());

    if (success && mounted) {
      final state = ref.read(playerGameProvider);
      context.go(
        '/play/${state.session!.id}/lobby?playerId=${state.player!.id}',
      );
    }
  }
}
