import 'package:flutter/material.dart';
import '../../models/daily_challenge.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Card Component displaying Daily Challenge Progress
class DailyChallengeCard extends StatelessWidget {
  final DailyChallenge challenge;

  const DailyChallengeCard({super.key, required this.challenge});

  @override
  Widget build(BuildContext context) {
    final progress = (challenge.currentCount / challenge.targetCount).clamp(0.0, 1.0);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Text(challenge.icon, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(challenge.title, style: AppTextStyles.heading3),
                    Text(
                      '${challenge.currentCount}/${challenge.targetCount}',
                      style: AppTextStyles.badgeText.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      challenge.isCompleted ? AppColors.success : AppColors.secondaryDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Text('🪙', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                Text('+${challenge.rewardCoins}', style: AppTextStyles.badgeText),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
