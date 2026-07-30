import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/achievement_card.dart';
import '../../core/widgets/child_mode_scaffold.dart';
import '../../models/achievement_model.dart';
import '../../services/storage_service.dart';

/// Achievements Gallery Screen showcasing 100+ unlockable badges
class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  late List<AchievementModel> _achievements;
  String _selectedCategory = 'All';

  final List<String> _categories = ['All', 'Beginner', 'Letters', 'Math', 'Games', 'Stories', 'AI Chat'];

  @override
  void initState() {
    super.initState();
    _achievements = AchievementModel.allAchievements;
  }

  void _claimReward(AchievementModel achievement) async {
    if (!achievement.isUnlocked) return;
    final storage = await StorageService.getInstance();
    await storage.addCoins(achievement.rewardCoins);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Claimed +${achievement.rewardCoins} coins! 🪙', style: AppTextStyles.badgeText.copyWith(color: Colors.white)),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedCategory == 'All'
        ? _achievements
        : _achievements.where((a) => a.category == _selectedCategory).toList();

    return ChildModeScaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
                  onPressed: () => Navigator.pop(context),
                ),
                Text('100+ Achievements 🏆', style: AppTextStyles.heading2),
              ],
            ),
          ),
          // Category Filter Chips
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat, style: AppTextStyles.badgeText.copyWith(color: isSelected ? Colors.white : AppColors.textPrimary)),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    onSelected: (val) {
                      if (val) setState(() => _selectedCategory = cat);
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final ach = filtered[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AchievementCard(
                    achievement: ach,
                    onTap: () => _claimReward(ach),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
