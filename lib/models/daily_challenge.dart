/// Daily Challenge Model for Gamification
class DailyChallenge {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int rewardCoins;
  final int targetCount;
  final int currentCount;
  final bool isCompleted;

  DailyChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.rewardCoins,
    required this.targetCount,
    this.currentCount = 0,
    this.isCompleted = false,
  });

  DailyChallenge copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    int? rewardCoins,
    int? targetCount,
    int? currentCount,
    bool? isCompleted,
  }) {
    return DailyChallenge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      rewardCoins: rewardCoins ?? this.rewardCoins,
      targetCount: targetCount ?? this.targetCount,
      currentCount: currentCount ?? this.currentCount,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  static List<DailyChallenge> get dailyDefaults => [
        DailyChallenge(
          id: 'dc_letters',
          title: 'Alphabet Master',
          description: 'Explore 5 new letters today',
          icon: '🔤',
          rewardCoins: 30,
          targetCount: 5,
          currentCount: 3,
        ),
        DailyChallenge(
          id: 'dc_math',
          title: 'Math Whiz',
          description: 'Solve 3 math puzzles',
          icon: '🧮',
          rewardCoins: 40,
          targetCount: 3,
          currentCount: 2,
        ),
        DailyChallenge(
          id: 'dc_memory',
          title: 'Memory Match',
          description: 'Win 1 Memory Flip game',
          icon: '🧩',
          rewardCoins: 35,
          targetCount: 1,
          currentCount: 1,
          isCompleted: true,
        ),
      ];
}
