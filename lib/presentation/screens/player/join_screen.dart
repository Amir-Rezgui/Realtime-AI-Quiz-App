import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../providers/player_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class JoinScreen extends ConsumerStatefulWidget {
  const JoinScreen({super.key});

  @override
  ConsumerState<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends ConsumerState<JoinScreen> {
  final _codeController = TextEditingController();
  bool _isScanning = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(playerGameProvider);

    final defaultPinTheme = PinTheme(
      width: 48,
      height: 56,
      textStyle: GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.onSurface,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: AppTheme.borderRadiusLg,
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: AppTheme.borderRadiusLg,
      ),
    );

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
                      icon: const Icon(Icons.arrow_back,
                          color: AppColors.onSurface),
                      onPressed: () => context.go('/login'),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Kinetic Quiz',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48), // Balance for back button
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppTheme.spacing10),
                child: Column(
                  children: [
                    const SizedBox(height: AppTheme.spacing16),

                    // Illustration Container
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: AppTheme.borderRadius3xl,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 32,
                            offset: const Offset(0, 16),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.rocket_launch_rounded,
                          size: 72,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppTheme.spacing16),

                    // Title
                    Text(
                      'Join the\nExperience',
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
                      'Enter the 6-character code displayed\non the host screen.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        fontSize: 15,
                        color: AppColors.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: AppTheme.spacing16),

                    // Pin Input Container
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacing10),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: AppTheme.borderRadiusXxl,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'GAME PIN',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacing6),
                          Pinput(
                            controller: _codeController,
                            length: AppConstants.joinCodeLength,
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: focusedPinTheme,
                            submittedPinTheme: defaultPinTheme.copyWith(
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer,
                                borderRadius: AppTheme.borderRadiusLg,
                              ),
                            ),
                            onCompleted: _handleJoin,
                            onChanged: (_) => setState(() {}),
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.characters,
                            pinAnimationType: PinAnimationType.scale,
                            animationDuration:
                                const Duration(milliseconds: 200),
                          ),
                        ],
                      ),
                    ),

                    if (state.error != null) ...[
                      const SizedBox(height: AppTheme.spacing8),
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
                        onPressed: state.isLoading ||
                                _codeController.text.length !=
                                    AppConstants.joinCodeLength
                            ? null
                            : () => _handleJoin(_codeController.text),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                          padding: const EdgeInsets.symmetric(
                              vertical: AppTheme.spacing8),
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
                            : Text(
                                'Join Quiz',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: AppTheme.spacing8),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _isScanning ? null : _openQrScanner,
                        icon: _isScanning
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.qr_code_scanner_rounded),
                        label: Text(
                          _isScanning ? 'Opening scanner...' : 'Scan QR Code',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: AppTheme.spacing6),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppTheme.borderRadiusXl,
                          ),
                        ),
                      ),
                    ),

                    // Help text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.help_outline,
                          size: 16,
                          color: AppColors.onSurfaceVariant,
                        ),
                        const SizedBox(width: AppTheme.spacing2),
                        Text(
                          'Don\'t have a code? Ask your host.',
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppTheme.spacing16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleJoin(String code) async {
    final normalized = code.trim().toUpperCase();
    if (normalized.length != AppConstants.joinCodeLength) return;

    final success =
        await ref.read(playerGameProvider.notifier).joinByCode(normalized);

    if (success && mounted) {
      context.go('/join/$normalized/nickname');
    }
  }

  Future<void> _openQrScanner() async {
    setState(() => _isScanning = true);
    String? detectedCode;

    try {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.black,
        builder: (sheetContext) {
          var handled = false;
          return SizedBox(
            height: 420,
            child: MobileScanner(
              onDetect: (capture) {
                if (handled) return;
                final raw = capture.barcodes.first.rawValue;
                if (raw == null || raw.isEmpty) return;

                final parsed = _extractJoinCode(raw);
                if (parsed == null) return;

                handled = true;
                detectedCode = parsed;
                Navigator.of(sheetContext).pop();
              },
            ),
          );
        },
      );
    } finally {
      if (mounted) {
        setState(() => _isScanning = false);
      }
    }

    if (!mounted || detectedCode == null) return;

    _codeController.text = detectedCode!;
    setState(() {});
    await _handleJoin(detectedCode!);
  }

  String? _extractJoinCode(String raw) {
    final uppercase = raw.toUpperCase().trim();
    if (RegExp(r'^[A-Z0-9]{6}$').hasMatch(uppercase)) {
      return uppercase;
    }

    final match = RegExp(r'[A-Z0-9]{6}').firstMatch(uppercase);
    return match?.group(0);
  }
}
