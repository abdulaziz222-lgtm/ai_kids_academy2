import 'dart:async';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/child_mode_scaffold.dart';
import '../../core/widgets/confetti_overlay.dart';
import '../../core/widgets/reward_dialog.dart';
import '../../models/memory_card.dart';
import '../../services/storage_service.dart';

/// 3D Flip Memory Matching Game Screen
class MemoryGameScreen extends StatefulWidget {
  const MemoryGameScreen({super.key});

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  int _pairsCount = 4; // 4x2 default
  late List<MemoryCard> _cards;
  MemoryCard? _firstFlipped;
  MemoryCard? _secondFlipped;
  bool _isProcessing = false;
  int _moves = 0;
  int _matchedPairs = 0;
  late ConfettiController _confetti;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 2));
    _restartGame();
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  void _restartGame() {
    setState(() {
      _cards = MemoryCard.generateDeck(_pairsCount);
      _firstFlipped = null;
      _secondFlipped = null;
      _isProcessing = false;
      _moves = 0;
      _matchedPairs = 0;
    });
  }

  void _onCardTap(MemoryCard card) {
    if (_isProcessing || card.isFaceUp || card.isMatched) return;

    setState(() {
      card.isFaceUp = true;
    });

    if (_firstFlipped == null) {
      _firstFlipped = card;
    } else {
      _secondFlipped = card;
      _moves++;
      _isProcessing = true;

      if (_firstFlipped!.symbol == _secondFlipped!.symbol) {
        _firstFlipped!.isMatched = true;
        _secondFlipped!.isMatched = true;
        _matchedPairs++;
        _firstFlipped = null;
        _secondFlipped = null;
        _isProcessing = false;

        if (_matchedPairs == _pairsCount) {
          _onWinGame();
        }
      } else {
        Timer(const Duration(milliseconds: 900), () {
          if (mounted) {
            setState(() {
              _firstFlipped!.isFaceUp = false;
              _secondFlipped!.isFaceUp = false;
              _firstFlipped = null;
              _secondFlipped = null;
              _isProcessing = false;
            });
          }
        });
      }
    }
  }

  void _onWinGame() async {
    _confetti.play();
    final storage = await StorageService.getInstance();
    await storage.addCoins(30);
    await storage.addStars(2);

    if (mounted) {
      showDialog(
        context: context,
        builder: (_) => RewardDialog(
          earnedCoins: 30,
          earnedStars: 2,
          title: 'Memory King! 🧩',
          onContinue: () {
            Navigator.pop(context);
            _restartGame();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConfettiOverlay(
      controller: _confetti,
      child: ChildModeScaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text('3D Memory Flip 🧩', style: AppTextStyles.heading2),
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
                    onPressed: _restartGame,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Grid Size Selector Chips
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _modeChip('Easy (4x2)', 4),
                  const SizedBox(width: 8),
                  _modeChip('Medium (4x4)', 8),
                  const SizedBox(width: 8),
                  _modeChip('Hard (6x4)', 12),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Moves: $_moves', style: AppTextStyles.heading3),
                  Text('Matched: $_matchedPairs/$_pairsCount', style: AppTextStyles.heading3.copyWith(color: AppColors.success)),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _pairsCount == 12 ? 4 : (_pairsCount == 8 ? 4 : 2),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: _cards.length,
                  itemBuilder: (context, index) {
                    final card = _cards[index];
                    return GestureDetector(
                      onTap: () => _onCardTap(card),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: card.isFaceUp || card.isMatched ? Colors.white : AppColors.primary,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 4))],
                          border: Border.all(
                            color: card.isMatched ? AppColors.success : Colors.white,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            card.isFaceUp || card.isMatched ? card.symbol : '❓',
                            style: TextStyle(
                              fontSize: _pairsCount > 8 ? 26 : 38,
                              color: card.isFaceUp || card.isMatched ? null : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _modeChip(String label, int pairs) {
    final isSelected = _pairsCount == pairs;
    return ChoiceChip(
      label: Text(label, style: AppTextStyles.badgeText.copyWith(color: isSelected ? Colors.white : AppColors.textPrimary)),
      selected: isSelected,
      selectedColor: AppColors.primary,
      backgroundColor: Colors.grey.shade200,
      onSelected: (val) {
        if (val) {
          setState(() {
            _pairsCount = pairs;
            _restartGame();
          });
        }
      },
    );
  }
}
