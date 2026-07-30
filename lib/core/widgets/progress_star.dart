import 'package:flutter/material.dart';

/// Interactive Progress Star Widget showing filled/empty rating stars
class ProgressStar extends StatelessWidget {
  final int count;
  final int total;
  final double size;

  const ProgressStar({
    super.key,
    required this.count,
    this.total = 3,
    this.size = 28.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (index) {
        final isFilled = index < count;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: AnimatedScale(
            scale: isFilled ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: Icon(
              isFilled ? Icons.star_rounded : Icons.star_border_rounded,
              size: size,
              color: isFilled ? const Color(0xFFFFD166) : Colors.grey.shade300,
            ),
          ),
        );
      }),
    );
  }
}
