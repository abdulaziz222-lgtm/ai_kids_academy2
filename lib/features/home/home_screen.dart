import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/bouncy_card.dart';
import '../../core/widgets/child_app_bar.dart';
import '../../core/widgets/child_mode_scaffold.dart';
import '../../core/widgets/daily_challenge_card.dart';
import '../../core/widgets/mascot_bubble.dart';
import '../../models/child_profile.dart';
import '../../models/daily_challenge.dart';
import '../../services/storage_service.dart';
import '../../services/tts_service.dart';

import '../achievements/achievements_screen.dart';
import '../ai_chat/ai_chat_screen.dart';
import '../child_profile/profile_screen.dart';
import '../drawing/ai_drawing_screen.dart';
import '../letters/letters_screen.dart';
import '../math/math_screen.dart';
import '../memory_game/memory_game_screen.dart';
import '../parent_dashboard/pin_lock_screen.dart';
import '../shop/avatar_shop_screen.dart';
import '../story/story_generator_screen.dart';
import '../voice_chat/voice_chat_screen.dart';

/// Main Home Dashboard for Kids
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ChildProfile _profile;
  bool _isLoading = true;
  bool _isSpeakingMascot = false;
  final TTSService _tts = TTSService();

  final String _greetingMessage = "Hi! I am your AI learning buddy! What fun game shall we play today?";

  @override
  void initState() {
    super.initState();
    _tts.init();
    _loadData();
  }

  Future<void> _loadData() async {
    final storage = await StorageService.getInstance();
    setState(() {
      _profile = storage.getProfile();
      _isLoading = false;
    });
  }

  void _speakMascot() {
    setState(() => _isSpeakingMascot = true);
    _tts.speak(_greetingMessage).then((_) {
      if (mounted) setState(() => _isSpeakingMascot = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const ChildModeScaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return ChildModeScaffold(
      appBar: ChildAppBar(
        avatar: _profile.avatar,
        childName: _profile.name,
        coins: _profile.coins,
        stars: _profile.stars,
        onAvatarTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProfileScreen(onProfileUpdated: _loadData),
            ),
          ).then((_) => _loadData());
        },
        onParentLockTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PinLockScreen()),
          );
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mascot Greeting Bubble
            MascotBubble(
              text: _greetingMessage,
              mascotEmoji: _profile.avatar,
              onSpeakTap: _speakMascot,
              isSpeaking: _isSpeakingMascot,
            ),
            const SizedBox(height: 20),
            // Daily Goal Preview
            Text('Daily Quest 🌟', style: AppTextStyles.heading2),
            const SizedBox(height: 8),
            DailyChallengeCard(
              challenge: DailyChallenge.dailyDefaults.first,
            ),
            const SizedBox(height: 20),
            // Learning Hub Modules
            Text('Learning Hub 🚀', style: AppTextStyles.heading2),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.15,
              children: [
                _buildModuleTile(
                  title: 'Alphabet & Words',
                  subtitle: '26 Letters',
                  icon: '🔤',
                  color: AppColors.pastelPink,
                  onTap: () => _navigateTo(LettersScreen(ageGroup: _profile.ageGroup)),
                ),
                _buildModuleTile(
                  title: 'Fun Math',
                  subtitle: 'Numbers & Shapes',
                  icon: '🧮',
                  color: AppColors.pastelPurple,
                  onTap: () => _navigateTo(MathScreen(ageGroup: _profile.ageGroup)),
                ),
                _buildModuleTile(
                  title: '3D Memory Flip',
                  subtitle: 'Brain Workout',
                  icon: '🧩',
                  color: AppColors.pastelBlue,
                  onTap: () => _navigateTo(const MemoryGameScreen()),
                ),
                _buildModuleTile(
                  title: 'AI Buddy Chat',
                  subtitle: 'Ask Anything',
                  icon: '💬',
                  color: AppColors.pastelYellow,
                  onTap: () => _navigateTo(AIChatScreen(childProfile: _profile)),
                ),
                _buildModuleTile(
                  title: 'AI Story World',
                  subtitle: 'Magic Tales',
                  icon: '📖',
                  color: AppColors.pastelOrange,
                  onTap: () => _navigateTo(StoryGeneratorScreen(childProfile: _profile)),
                ),
                _buildModuleTile(
                  title: 'AI Canvas Art',
                  subtitle: 'Draw & Color',
                  icon: '🎨',
                  color: AppColors.pastelGreen,
                  onTap: () => _navigateTo(const AIDrawingScreen()),
                ),
                _buildModuleTile(
                  title: 'Voice Buddy',
                  subtitle: 'Speak & Listen',
                  icon: '🎙️',
                  color: AppColors.secondary,
                  onTap: () => _navigateTo(VoiceChatScreen(childProfile: _profile)),
                ),
                _buildModuleTile(
                  title: 'Achievements',
                  subtitle: '100+ Badges',
                  icon: '🏆',
                  color: AppColors.warning,
                  onTap: () => _navigateTo(const AchievementsScreen()),
                ),
                _buildModuleTile(
                  title: 'Avatar Shop',
                  subtitle: 'Unlock Rewards',
                  icon: '🛍️',
                  color: AppColors.accent,
                  onTap: () => _navigateTo(AvatarShopScreen(onPurchased: _loadData)),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleTile({
    required String title,
    required String subtitle,
    required String icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return BouncyCard(
      backgroundColor: color.withOpacity(0.35),
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icon, style: const TextStyle(fontSize: 40)),
          const SizedBox(height: 8),
          Text(
            title,
            style: AppTextStyles.heading3.copyWith(fontSize: 16),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subtitle,
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _navigateTo(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page)).then((_) => _loadData());
  }
}
