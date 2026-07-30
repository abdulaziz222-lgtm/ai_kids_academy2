import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'big_round_button.dart';

/// Celebration Reward Dialog showing coins and stars earned
class RewardDialog extends StatelessWidget {
  final int earnedCoins;
  final int earnedStars;
  final String title;
  final VoidCallback onContinue;

  const RewardDialog({
    super.key,
    required this.earnedCoins,
    required this.earnedStars,
    this.title = 'Super Job!',
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      elevation: 16,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 12),
            Text(title, style: AppTextStyles.headingHero),
            const SizedBox(height: 8),
            Text('You earned awesome rewards!', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Text('🪙', style: TextStyle(fontSize: 22)),
                      const SizedBox(width: 6),
                      Text('+$earnedCoins', style: AppTextStyles.heading2),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Text('⭐', style: TextStyle(fontSize: 22)),
                      const SizedBox(width: 6),
                      Text('+$earnedStars', style: AppTextStyles.heading2),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            BigRoundButton(
              text: 'Awesome!',
              backgroundColor: AppColors.success,
              onTap: onContinue,
            ),
          ],
        ),
      ),
    );
  }
}
