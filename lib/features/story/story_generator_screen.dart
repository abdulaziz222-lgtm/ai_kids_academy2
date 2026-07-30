import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/big_round_button.dart';
import '../../core/widgets/child_mode_scaffold.dart';
import '../../core/widgets/confetti_overlay.dart';
import '../../core/widgets/loading_animation.dart';
import '../../models/child_profile.dart';
import '../../models/story_model.dart';
import '../../services/ai_service.dart';
import '../../services/storage_service.dart';
import '../../services/tts_service.dart';

/// AI Fairy Tale Generator Screen
class StoryGeneratorScreen extends StatefulWidget {
  final ChildProfile childProfile;
  const StoryGeneratorScreen({super.key, required this.childProfile});

  @override
  State<StoryGeneratorScreen> createState() => _StoryGeneratorScreenState();
}

class _StoryGeneratorScreenState extends State<StoryGeneratorScreen> {
  final AIService _aiService = AIService();
  final TTSService _tts = TTSService();
  late ConfettiController _confetti;

  String _selectedTheme = 'Magic Forest';
  StoryModel? _generatedStory;
  bool _isGenerating = false;

  final List<String> _themes = ['Magic Forest', 'Space Rocket', 'Underwater Kingdom'];

  @override
  void initState() {
    super.initState();
    _tts.init();
    _confetti = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  void _createStory() async {
    setState(() => _isGenerating = true);
    _tts.stop();

    final story = await _aiService.generateAIStory(
      childName: widget.childProfile.name,
      topic: _selectedTheme,
    );

    final storage = await StorageService.getInstance();
    await storage.addCoins(25);
    await storage.addStars(1);

    if (mounted) {
      setState(() {
        _generatedStory = story;
        _isGenerating = false;
      });
      _confetti.play();
      _tts.speak('${story.title}. ${story.content}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConfettiOverlay(
      controller: _confetti,
      child: ChildModeScaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text('AI Story Generator 📖', style: AppTextStyles.heading2),
                ],
              ),
              const SizedBox(height: 16),
              Text('Pick a Magical Theme:', style: AppTextStyles.heading3),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                children: _themes.map((theme) {
                  final isSelected = _selectedTheme == theme;
                  return ChoiceChip(
                    label: Text(theme, style: AppTextStyles.badgeText.copyWith(color: isSelected ? Colors.white : AppColors.textPrimary)),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    backgroundColor: Colors.white,
                    onSelected: (val) {
                      if (val) setState(() => _selectedTheme = theme);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              BigRoundButton(
                text: 'Create New Story ✨',
                backgroundColor: AppColors.primary,
                isLoading: _isGenerating,
                onTap: _createStory,
              ),
              const SizedBox(height: 24),
              if (_isGenerating) const LoadingAnimation(message: 'Spinning a magical tale for you...'),
              if (_generatedStory != null && !_isGenerating) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 16, offset: Offset(0, 6))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(_generatedStory!.coverEmoji, style: const TextStyle(fontSize: 36)),
                          const SizedBox(width: 10),
                          Expanded(child: Text(_generatedStory!.title, style: AppTextStyles.heading2)),
                          IconButton(
                            icon: const Icon(Icons.volume_up_rounded, color: AppColors.primary),
                            onPressed: () => _tts.speak('${_generatedStory!.title}. ${_generatedStory!.content}'),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Text(_generatedStory!.content, style: AppTextStyles.bodyLarge),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Text('💡', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Moral Lesson: ${_generatedStory!.moralLesson}',
                                style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '🎨 AI Illustration Prompt: "${_generatedStory!.imagePrompt}"',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textLight, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
