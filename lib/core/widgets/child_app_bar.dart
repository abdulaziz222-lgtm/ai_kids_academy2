import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Top Bar Widget for Child Mode displaying Avatar, Coins, Stars, and Parent Gateway
class ChildAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String avatar;
  final String childName;
  final int coins;
  final int stars;
  final VoidCallback onAvatarTap;
  final VoidCallback onParentLockTap;

  const ChildAppBar({
    super.key,
    required this.avatar,
    required this.childName,
    required this.coins,
    required this.stars,
    required this.onAvatarTap,
    required this.onParentLockTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Profile & Name Button
            GestureDetector(
              onTap: onAvatarTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2))
                  ],
                ),
                child: Row(
                  children: [
                    Text(avatar, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 6),
                    Text(childName, style: AppTextStyles.badgeText),
                  ],
                ),
              ),
            ),
            const Spacer(),
            // Coins Counter
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.warning),
              ),
              child: Row(
                children: [
                  const Text('🪙', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 4),
                  Text('$coins', style: AppTextStyles.badgeText.copyWith(color: AppColors.textPrimary)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Stars Counter
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.secondaryDark),
              ),
              child: Row(
                children: [
                  const Text('⭐', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 4),
                  Text('$stars', style: AppTextStyles.badgeText.copyWith(color: AppColors.textPrimary)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Parent Dashboard Gatekeeper Lock
            IconButton(
              icon: const Icon(Icons.lock_person_rounded, color: AppColors.primary),
              onPressed: onParentLockTap,
              tooltip: 'Parent Dashboard',
            ),
          ],
        ),
      ),
    );
  }
}
