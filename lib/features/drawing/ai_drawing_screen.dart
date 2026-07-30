import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/big_round_button.dart';
import '../../core/widgets/child_mode_scaffold.dart';
import '../../core/widgets/reward_dialog.dart';
import '../../services/storage_service.dart';

class DrawnPoint {
  final Offset offset;
  final Paint paint;
  DrawnPoint({required this.offset, required this.paint});
}

/// AI Interactive Drawing & Coloring Board Screen
class AIDrawingScreen extends StatefulWidget {
  const AIDrawingScreen({super.key});

  @override
  State<AIDrawingScreen> createState() => _AIDrawingScreenState();
}

class _AIDrawingScreenState extends State<AIDrawingScreen> {
  List<DrawnPoint?> _points = [];
  Color _selectedColor = AppColors.primary;
  double _strokeWidth = 6.0;
  bool _isEraser = false;

  final List<Color> _colors = [
    AppColors.primary,
    AppColors.secondaryDark,
    AppColors.warning,
    AppColors.success,
    Colors.redAccent,
    Colors.purpleAccent,
    Colors.black,
  ];

  final List<String> _promptIdeas = ['Robot 🤖', 'Dinosaur 🦖', 'Rocket 🚀', 'Rainbow 🌈', 'Butterfly 🦋'];
  String _currentIdea = 'Robot 🤖';

  void _clearCanvas() {
    setState(() {
      _points.clear();
    });
  }

  void _saveDrawing() async {
    final storage = await StorageService.getInstance();
    await storage.addCoins(20);
    await storage.addStars(1);

    if (mounted) {
      showDialog(
        context: context,
        builder: (_) => RewardDialog(
          earnedCoins: 20,
          earnedStars: 1,
          title: 'Masterpiece Saved! 🎨',
          onContinue: () {
            Navigator.pop(context);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChildModeScaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
                  onPressed: () => Navigator.pop(context),
                ),
                Text('AI Canvas Studio 🎨', style: AppTextStyles.heading2),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                  onPressed: _clearCanvas,
                  tooltip: 'Clear Canvas',
                ),
              ],
            ),
          ),
          // Prompt suggestions
          SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _promptIdeas.length,
              itemBuilder: (context, index) {
                final idea = _promptIdeas[index];
                final isSelected = idea == _currentIdea;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text('Draw $idea', style: AppTextStyles.bodySmall.copyWith(color: isSelected ? Colors.white : AppColors.textPrimary)),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    onSelected: (val) {
                      if (val) setState(() => _currentIdea = idea);
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // Drawing Canvas
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 12, offset: Offset(0, 4))],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: GestureDetector(
                  onPanUpdate: (details) {
                    RenderBox renderBox = context.findRenderObject() as RenderBox;
                    final localPos = renderBox.globalToLocal(details.globalPosition);
                    setState(() {
                      _points.add(
                        DrawnPoint(
                          offset: localPos,
                          paint: Paint()
                            ..color = _isEraser ? Colors.white : _selectedColor
                            ..strokeCap = StrokeCap.round
                            ..strokeWidth = _isEraser ? 24.0 : _strokeWidth,
                        ),
                      );
                    });
                  },
                  onPanEnd: (details) {
                    _points.add(null);
                  },
                  child: CustomPaint(
                    painter: CanvasPainter(points: _points),
                    size: Size.infinite,
                  ),
                ),
              ),
            ),
          ),
          // Color & Tool Palette
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ..._colors.map((col) {
                      final isSelected = !_isEraser && _selectedColor == col;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColor = col;
                            _isEraser = false;
                          });
                        },
                        child: AnimatedScale(
                          scale: isSelected ? 1.25 : 1.0,
                          duration: const Duration(milliseconds: 150),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: col,
                              border: Border.all(
                                color: isSelected ? AppColors.primary : Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    IconButton(
                      icon: Icon(
                        Icons.cleaning_services_rounded,
                        color: _isEraser ? AppColors.primary : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() => _isEraser = !_isEraser);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                BigRoundButton(
                  text: 'Save Artwork ✨',
                  backgroundColor: AppColors.success,
                  onTap: _saveDrawing,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CanvasPainter extends CustomPainter {
  final List<DrawnPoint?> points;
  CanvasPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!.offset, points[i + 1]!.offset, points[i]!.paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CanvasPainter oldDelegate) => true;
}
