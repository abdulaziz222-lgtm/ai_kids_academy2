import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../models/child_profile.dart';

/// StorageService handling local data persistence via SharedPreferences
class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _prefs;

  StorageService._();

  static Future<StorageService> getInstance() async {
    _instance ??= StorageService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // Profile Methods
  ChildProfile getProfile() {
    final String? profileJson = _prefs?.getString(AppConstants.keyChildName);
    if (profileJson != null && profileJson.isNotEmpty) {
      try {
        return ChildProfile.fromJson(profileJson);
      } catch (_) {}
    }
    return ChildProfile(
      name: 'Super Star',
      age: 5,
      avatar: '🐱',
      ageGroup: '3-5',
      coins: getCoins(),
      stars: getStars(),
    );
  }

  Future<bool> saveProfile(ChildProfile profile) async {
    await saveCoins(profile.coins);
    await saveStars(profile.stars);
    return await _prefs?.setString(AppConstants.keyChildName, profile.toJson()) ?? false;
  }

  // Coins & Stars
  int getCoins() {
    return _prefs?.getInt(AppConstants.keyCoins) ?? AppConstants.defaultCoins;
  }

  Future<bool> saveCoins(int coins) async {
    return await _prefs?.setInt(AppConstants.keyCoins, coins) ?? false;
  }

  Future<bool> addCoins(int amount) async {
    final current = getCoins();
    return await saveCoins(current + amount);
  }

  int getStars() {
    return _prefs?.getInt(AppConstants.keyStars) ?? AppConstants.defaultStars;
  }

  Future<bool> saveStars(int stars) async {
    return await _prefs?.setInt(AppConstants.keyStars, stars) ?? false;
  }

  Future<bool> addStars(int amount) async {
    final current = getStars();
    return await saveStars(current + amount);
  }

  // Parent PIN
  String getParentPin() {
    return _prefs?.getString(AppConstants.keyParentPin) ?? AppConstants.defaultParentPin;
  }

  Future<bool> setParentPin(String newPin) async {
    return await _prefs?.setString(AppConstants.keyParentPin, newPin) ?? false;
  }

  // Unlocked Items
  List<String> getUnlockedItems() {
    return _prefs?.getStringList(AppConstants.keyUnlockedItems) ?? ['cat_avatar'];
  }

  Future<bool> unlockItem(String itemId) async {
    final items = getUnlockedItems();
    if (!items.contains(itemId)) {
      items.add(itemId);
      return await _prefs?.setStringList(AppConstants.keyUnlockedItems, items) ?? false;
    }
    return true;
  }

  // Study Time Tracker
  int getStudyTimeMinutes() {
    return _prefs?.getInt(AppConstants.keyStudyTimeMinutes) ?? 45;
  }

  Future<bool> addStudyTimeMinutes(int minutes) async {
    final current = getStudyTimeMinutes();
    return await _prefs?.setInt(AppConstants.keyStudyTimeMinutes, current + minutes) ?? false;
  }
}
