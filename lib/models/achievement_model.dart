/// Achievement Model representing unlockable badges & goals
class AchievementModel {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int rewardCoins;
  final String category;
  final bool isUnlocked;

  AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.rewardCoins,
    required this.category,
    this.isUnlocked = false,
  });

  AchievementModel copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    int? rewardCoins,
    String? category,
    bool? isUnlocked,
  }) {
    return AchievementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      rewardCoins: rewardCoins ?? this.rewardCoins,
      category: category ?? this.category,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  static List<AchievementModel> get allAchievements {
    List<AchievementModel> list = [
      AchievementModel(
        id: 'first_lesson',
        title: 'First Step',
        description: 'Complete your very first lesson!',
        icon: '🚀',
        rewardCoins: 20,
        category: 'Beginner',
        isUnlocked: true,
      ),
      AchievementModel(
        id: 'alphabet_master',
        title: 'Alphabet Master',
        description: 'Learn all 26 letters of the alphabet!',
        icon: '🔤',
        rewardCoins: 50,
        category: 'Letters',
        isUnlocked: true,
      ),
      AchievementModel(
        id: 'math_genius',
        title: 'Math Genius',
        description: 'Solve 20 math problems correctly!',
        icon: '🧮',
        rewardCoins: 50,
        category: 'Math',
      ),
      AchievementModel(
        id: 'memory_king',
        title: 'Memory King',
        description: 'Win 5 Memory Flip games!',
        icon: '👑',
        rewardCoins: 40,
        category: 'Games',
      ),
      AchievementModel(
        id: 'story_lover',
        title: 'Story Lover',
        description: 'Create 3 personalized AI stories!',
        icon: '📖',
        rewardCoins: 30,
        category: 'Stories',
      ),
      AchievementModel(
        id: 'voice_buddy',
        title: 'Voice Buddy',
        description: 'Have a voice chat conversation with AI mascot!',
        icon: '🎙️',
        rewardCoins: 25,
        category: 'AI Chat',
      ),
      AchievementModel(
        id: 'artist_star',
        title: 'Young Artist',
        description: 'Create your first digital drawing!',
        icon: '🎨',
        rewardCoins: 25,
        category: 'Art',
      ),
      AchievementModel(
        id: 'daily_champion',
        title: 'Perfect Week',
        description: 'Complete daily challenges 7 days in a row!',
        icon: '🌟',
        rewardCoins: 100,
        category: 'Streak',
      ),
    ];

    // Generate up to 100+ structured achievements dynamically
    final categories = ['Letters', 'Math', 'Games', 'Stories', 'AI Chat', 'Art', 'Streak', 'Shop'];
    final icons = ['🎖️', '🏅', '🏆', '⭐', '💎', '🔥', '🎉', '⚡', '✨', '🧠'];

    for (int i = 9; i <= 100; i++) {
      final cat = categories[i % categories.length];
      final ico = icons[i % icons.length];
      list.add(
        AchievementModel(
          id: 'achievement_$i',
          title: '$cat Level ${i ~/ 8 + 1}',
          description: 'Reach milestone $i in $cat learning activities!',
          icon: ico,
          rewardCoins: 15 + (i * 2),
          category: cat,
          isUnlocked: i <= 12,
        ),
      );
    }

    return list;
  }
}
