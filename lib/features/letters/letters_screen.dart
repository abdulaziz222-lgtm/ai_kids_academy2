import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/bouncy_card.dart';
import '../../core/widgets/child_mode_scaffold.dart';
import '../../models/letter_item.dart';
import '../../services/tts_service.dart';
import 'letter_detail_screen.dart';

/// Alphabet Explorer Screen displaying 26 Letters & Quiz Launcher
class LettersScreen extends StatefulWidget {
  final String ageGroup;
  const LettersScreen({super.key, required this.ageGroup});

  @override
  State<LettersScreen> createState() => _LettersScreenState();
}

class _LettersScreenState extends State<LettersScreen> {
  final List<LetterItem> _alphabet = LetterItem.alphabetList;
  final TTSService _tts = TTSService();

  @override
  void initState() {
    super.initState();
    _tts.init();
  }

  void _speakLetter(LetterItem item) {
    _tts.speak('${item.letter}. ${item.word}.');
  }

  void _openDetail(LetterItem item) {
    _speakLetter(item);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LetterDetailScreen(letterItem: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChildModeScaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
                  onPressed: () => Navigator.pop(context),
                ),
                Text('Alphabet Kingdom 🔤', style: AppTextStyles.heading2),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.95,
              ),
              itemCount: _alphabet.length,
              itemBuilder: (context, index) {
                final item = _alphabet[index];
                return Hero(
                  tag: 'letter_${item.letter}',
                  child: BouncyCard(
                    backgroundColor: Colors.white,
                    onTap: () => _openDetail(item),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.letter,
                          style: AppTextStyles.heading1.copyWith(
                            fontSize: 36,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(item.emoji, style: const TextStyle(fontSize: 22)),
                        Text(
                          item.word,
                          style: AppTextStyles.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
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
