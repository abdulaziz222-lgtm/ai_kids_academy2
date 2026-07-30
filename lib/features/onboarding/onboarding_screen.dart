import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/big_round_button.dart';
import '../../core/widgets/child_mode_scaffold.dart';
import '../../models/child_profile.dart';
import '../../services/storage_service.dart';

/// Onboarding Setup Screen for Child Profile configuration
class OnboardingScreen extends StatefulWidget {
  final VoidCallback onOnboardingComplete;

  const OnboardingScreen({super.key, required this.onOnboardingComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Super Explorer');
  String _selectedAgeGroup = AppConstants.ageGroup3To5;
  int _selectedAge = 4;
  String _selectedAvatar = '🐱';

  final List<String> _avatars = ['🐱', '🐶', '🦊', '🦁', '🐼', '🦄', '🐲', '🤖'];

  void _finishSetup() async {
    final storage = await StorageService.getInstance();
    final profile = ChildProfile(
      name: _nameController.text.trim().isEmpty ? 'Explorer' : _nameController.text.trim(),
      age: _selectedAge,
      avatar: _selectedAvatar,
      ageGroup: _selectedAgeGroup,
      coins: storage.getCoins(),
      stars: storage.getStars(),
    );
    await storage.saveProfile(profile);
    widget.onOnboardingComplete();
  }

  @override
  Widget build(BuildContext context) {
    return ChildModeScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('✨ Welcome to ✨', style: TextStyle(fontSize: 18, color: AppColors.primary, fontWeight: FontWeight.bold)),
            Text('AI Kids Academy', style: AppTextStyles.headingHero),
            const SizedBox(height: 8),
            Text(
              'Let’s set up your fun learning profile!',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            // Avatar Selector
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 12, offset: Offset(0, 4))],
              ),
              child: Column(
                children: [
                  Text('Choose Your Hero Avatar', style: AppTextStyles.heading3),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _avatars.map((av) {
                      final isSelected = av == _selectedAvatar;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedAvatar = av),
                        child: AnimatedScale(
                          scale: isSelected ? 1.2 : 1.0,
                          duration: const Duration(milliseconds: 150),
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? AppColors.secondary : Colors.grey.shade100,
                              border: Border.all(
                                color: isSelected ? AppColors.primary : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(av, style: const TextStyle(fontSize: 30)),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Name Field
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'What is your name?',
                labelStyle: AppTextStyles.bodyMedium,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.star_rounded, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 20),
            // Age Group Selector
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 12, offset: Offset(0, 4))],
              ),
              child: Column(
                children: [
                  Text('Select Age Group', style: AppTextStyles.heading3),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ageChip('3–5 Years', AppConstants.ageGroup3To5, 4),
                      _ageChip('6–7 Years', AppConstants.ageGroup6To7, 6),
                      _ageChip('8–10 Years', AppConstants.ageGroup8To10, 9),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            BigRoundButton(
              text: 'Start Adventure! 🚀',
              backgroundColor: AppColors.primary,
              onTap: _finishSetup,
            ),
          ],
        ),
      ),
    );
  }

  Widget _ageChip(String label, String ageGroup, int defaultAge) {
    final isSelected = _selectedAgeGroup == ageGroup;
    return ChoiceChip(
      label: Text(label, style: AppTextStyles.badgeText.copyWith(color: isSelected ? Colors.white : AppColors.textPrimary)),
      selected: isSelected,
      selectedColor: AppColors.primary,
      backgroundColor: Colors.grey.shade100,
      onSelected: (val) {
        if (val) {
          setState(() {
            _selectedAgeGroup = ageGroup;
            _selectedAge = defaultAge;
          });
        }
      },
    );
  }
}
