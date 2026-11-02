import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/game_session_provider.dart';
import '../../../core/theme/app_colors.dart';

class PlayerResultsScreen extends ConsumerWidget {
  final String sessionId;
  final String playerId;
  final bool isCorrect;
  final int pointsEarned;

  const PlayerResultsScreen({
    super.key,
    required this.sessionId,
    required this.playerId,
    required this.isCorrect,
    required this.pointsEarned,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: isCorrect ? AppColors.success : AppColors.error,
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  size: 120,
                  color: Colors.white,
                ),
                const SizedBox(height: 24),
                Text(
                  isCorrect ? 'Correct!' : 'Wrong!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isCorrect) ...[
                  const SizedBox(height: 16),
                  Text(
                    '+$pointsEarned points',
                    style: const TextStyle(color: Colors.white70, fontSize: 24),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
