import 'package:flutter/material.dart';

/// Violet Pulse Design System Colors
/// Based on "The Kinetic Gallery" creative direction
class AppColors {
  AppColors._();

  // ============================================
  // PRIMARY PALETTE
  // ============================================
  static const Color primary = Color(0xFF644DA1);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFBBA2FD);
  static const Color onPrimaryContainer = Color(0xFF38264C);

  // ============================================
  // SECONDARY PALETTE
  // ============================================
  static const Color secondary = Color(0xFF836E99);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFEFDBFF);
  static const Color onSecondaryContainer = Color(0xFF38264C);

  // ============================================
  // SURFACE HIERARCHY (Tonal Layering)
  // No borders - use these for visual separation
  // ============================================
  static const Color surface = Color(0xFFFDF3FF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF9ECFF);
  static const Color surfaceContainer = Color(0xFFF3E5FC);
  static const Color surfaceContainerHigh = Color(0xFFEFDBFF);
  static const Color surfaceContainerHighest = Color(0xFFEBD4FF);
  static const Color surfaceDim = Color(0xFFE5CAFF);

  // ============================================
  // ON-SURFACE (Text & Icons)
  // ============================================
  static const Color onSurface = Color(0xFF38264C);
  static const Color onSurfaceVariant = Color(0xFF5C4A6E);
  static const Color outline = Color(0xFF836E99);
  static const Color outlineVariant = Color(0xFFBBA4D2);

  // ============================================
  // SEMANTIC COLORS
  // ============================================
  static const Color success = Color(0xFF4CAF50);
  static const Color onSuccess = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color warning = Color(0xFFFF9800);

  // ============================================
  // TEXT HIERARCHY (Based on on-surface)
  // ============================================
  static const Color textPrimary = onSurface;
  static const Color textSecondary = onSurfaceVariant;
  static const Color textLight = outlineVariant;
  static const Color textHint = Color(0xFF9D8AB0);

  // ============================================
  // ANSWER COLORS (Softer, on-brand)
  // ============================================
  static const Color answerViolet = Color(0xFF7C5CBF);
  static const Color answerPink = Color(0xFFD56FA0);
  static const Color answerTeal = Color(0xFF4DB6AC);
  static const Color answerAmber = Color(0xFFFFB74D);

  static const List<Color> answerColors = [
    answerViolet,
    answerPink,
    answerTeal,
    answerAmber,
  ];

  // ============================================
  // GRADIENTS
  // ============================================
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryContainer],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryContainer],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF644DA1), Color(0xFF9575CD)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient progressGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // ============================================
  // SHADOWS (Ambient Tinted - No grey shadows!)
  // ============================================
  static List<BoxShadow> get ambientShadow => [
        BoxShadow(
          color: onSurface.withValues(alpha: 0.06),
          blurRadius: 48,
          offset: const Offset(0, 12),
        ),
      ];

  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: primary.withValues(alpha: 0.08),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];
}
