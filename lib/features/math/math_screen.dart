import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/big_round_button.dart';
import '../../core/widgets/bouncy_card.dart';
import '../../core/widgets/child_mode_scaffold.dart';
import '../../core/widgets/confetti_overlay.dart';
import '../../core/widgets/reward_dialog.dart';
import '../../models/math_problem.dart';
import '../../services/storage_service.dart';

/// Fun Math Quiz & Practice Screen
class MathScreen extends StatefulWidget {
  final String ageGroup;
  const MathScreen({super.key, required this.ageGroup});

  @override
  State<MathScreen> createState() => _MathScreenState();
}

class _MathScreenState extends State<MathScreen> {
  late MathProblem _currentProblem;
  int _score = 0;
  int? _selectedOption;
  late ConfettiController _confetti;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 2));
    _generateNextProblem();
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  void _generateNextProblem() {
    setState(() {
      _selectedOption = null;
      _currentProblem = MathProblem.generateForAgeGroup(widget.ageGroup);
    });
  }

  void _selectOption(int option) async {
    if (_selectedOption != null) return;
    setState(() {
      _selectedOption = option;
    });

    if (option == _currentProblem.correctAnswer) {
      setState(() => _score += 1);
      _confetti.play();
      final storage = await StorageService.getInstance();
      await storage.addCoins(20);
      await storage.addStars(1);

      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => RewardDialog(
            earnedCoins: 20,
            earnedStars: 1,
            title: 'Math Master! 🧮',
            onContinue: () {
              Navigator.pop(context);
              _generateNextProblem();
            },
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConfettiOverlay(
      controller: _confetti,
      child: ChildModeScaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text('Fun Math 🧮', style: AppTextStyles.heading2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text('Score: $_score', style: AppTextStyles.badgeText),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Math Problem Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 16, offset: Offset(0, 6))],
                ),
                child: Column(
                  children: [
                    Text(_currentProblem.question, style: AppTextStyles.headingHero),
                    const SizedBox(height: 16),
                    // Visual object counter support for younger kids
                    if (_currentProblem.visualCount1 > 0) ...[
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: List.generate(
                          _currentProblem.visualCount1,
                          (_) => Text(_currentProblem.emojiIcon, style: const TextStyle(fontSize: 32)),
                        ),
                      ),
                      if (_currentProblem.visualCount2 > 0) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(_currentProblem.operatorSymbol, style: AppTextStyles.heading1),
                        ),
                        Wrap(
                          alignment: WrapAlignment.center,
                          children: List.generate(
                            _currentProblem.visualCount2,
                            (_) => Text(_currentProblem.emojiIcon, style: const TextStyle(fontSize: 32)),
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Text('Pick the right answer:', style: AppTextStyles.heading3),
              const SizedBox(height: 16),
              Column(
                children: _currentProblem.options.map((opt) {
                  final isSelected = _selectedOption == opt;
                  final isCorrect = opt == _currentProblem.correctAnswer;
                  Color bgColor = Colors.white;
                  if (isSelected) {
                    bgColor = isCorrect ? AppColors.success : Colors.redAccent.shade100;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: BouncyCard(
                      backgroundColor: bgColor,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      onTap: () => _selectOption(opt),
                      child: Center(
                        child: Text(
                          '$opt',
                          style: AppTextStyles.heading1.copyWith(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const Spacer(),
              BigRoundButton(
                text: 'Next Question ➡️',
                backgroundColor: AppColors.primary,
                onTap: _generateNextProblem,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
