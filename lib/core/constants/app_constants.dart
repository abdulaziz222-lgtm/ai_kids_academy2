/// Application Constants
class AppConstants {
  AppConstants._();

  static const String appName = 'AI Kids Academy';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String keyChildName = 'child_name';
  static const String keyChildAge = 'child_age';
  static const String keyChildAvatar = 'child_avatar';
  static const String keyCoins = 'coins_count';
  static const String keyStars = 'stars_count';
  static const String keyCompletedLessons = 'completed_lessons';
  static const String keyUnlockedItems = 'unlocked_shop_items';
  static const String keyUnlockedAchievements = 'unlocked_achievements';
  static const String keyParentPin = 'parent_pin';
  static const String keyStudyTimeMinutes = 'study_time_minutes';
  static const String keyDailyChallenges = 'daily_challenges';

  // Default values
  static const String defaultParentPin = '1234';
  static const String defaultAvatar = '🐱';
  static const int defaultCoins = 100;
  static const int defaultStars = 5;

  // Age Groups
  static const String ageGroup3To5 = '3-5';
  static const String ageGroup6To7 = '6-7';
  static const String ageGroup8To10 = '8-10';
}
