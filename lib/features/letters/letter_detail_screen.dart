import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/bouncy_card.dart';
import '../../core/widgets/child_mode_scaffold.dart';
import '../../core/widgets/confetti_overlay.dart';
import '../../core/widgets/reward_dialog.dart';
import '../../models/letter_item.dart';
import '../../services/storage_service.dart';
import '../../services/tts_service.dart';

/// Detail Screen for Individual Letter with Sound & Interactive Quiz
class LetterDetailScreen extends StatefulWidget {
  final LetterItem letterItem;
  const LetterDetailScreen({super.key, required this.letterItem});

  @override
  State<LetterDetailScreen> createState() => _LetterDetailScreenState();
}

class _LetterDetailScreenState extends State<LetterDetailScreen> {
  final TTSService _tts = TTSService();
  late ConfettiController _confetti;
  String? _selectedQuizAnswer;

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

  void _playSound() {
    _tts.speak('${widget.letterItem.letter} is for ${widget.letterItem.word}!');
  }

  void _checkQuiz(String selected) async {
    setState(() {
      _selectedQuizAnswer = selected;
    });

    if (selected == widget.letterItem.word) {
      _confetti.play();
      final storage = await StorageService.getInstance();
      await storage.addCoins(15);
      await storage.addStars(1);

      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => RewardDialog(
            earnedCoins: 15,
            earnedStars: 1,
            title: 'Correct! 🌟',
            onContinue: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.letterItem;
    return ConfettiOverlay(
      controller: _confetti,
      child: ChildModeScaffold(
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text('Letter ${item.letter}', style: AppTextStyles.heading2),
                ],
              ),
              const SizedBox(height: 12),
              Hero(
                tag: 'letter_${item.letter}',
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 16, offset: Offset(0, 6))],
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${item.uppercase} ${item.lowercase}',
                        style: AppTextStyles.headingHero.copyWith(fontSize: 72, color: AppColors.primary),
                      ),
                      const SizedBox(height: 8),
                      Text(item.emoji, style: const TextStyle(fontSize: 64)),
                      const SizedBox(height: 8),
                      Text(item.word, style: AppTextStyles.heading1),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _playSound,
                        icon: const Icon(Icons.volume_up_rounded, color: Colors.white),
                        label: Text('Listen Sound', style: AppTextStyles.buttonText.copyWith(fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryDark,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Letter Mini Quiz
              Text('Quick Quiz: What starts with ${item.letter}?', style: AppTextStyles.heading3),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: item.quizOptions.map((opt) {
                  final isChosen = _selectedQuizAnswer == opt;
                  final isCorrect = opt == item.word;
                  Color bgColor = Colors.white;
                  if (isChosen) {
                    bgColor = isCorrect ? AppColors.success : Colors.redAccent.shade100;
                  }
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: BouncyCard(
                        backgroundColor: bgColor,
                        onTap: () => _checkQuiz(opt),
                        child: Center(
                          child: Text(
                            opt,
                            style: AppTextStyles.badgeText.copyWith(
                              color: isChosen ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
