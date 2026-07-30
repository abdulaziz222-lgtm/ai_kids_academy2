import 'package:flutter/material.dart';
import '../../models/achievement_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Card Component displaying individual Achievement progress & state
class AchievementCard extends StatelessWidget {
  final AchievementModel achievement;
  final VoidCallback onTap;

  const AchievementCard({
    super.key,
    required this.achievement,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUnlocked = achievement.isUnlocked;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUnlocked ? Colors.white : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isUnlocked
              ? [const BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 4))]
              : [],
          border: Border.all(
            color: isUnlocked ? AppColors.secondary : Colors.grey.shade300,
            width: isUnlocked ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isUnlocked ? AppColors.accent.withOpacity(0.4) : Colors.grey.shade300,
              ),
              child: Center(
                child: Text(
                  achievement.icon,
                  style: TextStyle(fontSize: 26, color: isUnlocked ? null : Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement.title,
                    style: AppTextStyles.heading3.copyWith(
                      color: isUnlocked ? AppColors.textPrimary : AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    achievement.description,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isUnlocked ? AppColors.textSecondary : AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isUnlocked ? AppColors.warning.withOpacity(0.2) : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🪙', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  Text(
                    '+${achievement.rewardCoins}',
                    style: AppTextStyles.badgeText.copyWith(
                      color: isUnlocked ? AppColors.textPrimary : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
