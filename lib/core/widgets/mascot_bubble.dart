import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Mascot Character Widget with animated speech bubble
class MascotBubble extends StatelessWidget {
  final String text;
  final String mascotEmoji;
  final VoidCallback? onSpeakTap;
  final bool isSpeaking;

  const MascotBubble({
    super.key,
    required this.text,
    this.mascotEmoji = '🦊',
    this.onSpeakTap,
    this.isSpeaking = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onSpeakTap,
          child: AnimatedScale(
            scale: isSpeaking ? 1.15 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Center(
                child: Text(
                  mascotEmoji,
                  style: const TextStyle(fontSize: 34),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 14,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                  ),
                ),
                if (onSpeakTap != null)
                  IconButton(
                    icon: Icon(
                      isSpeaking ? Icons.volume_up_rounded : Icons.volume_mute_rounded,
                      color: AppColors.primary,
                    ),
                    onPressed: onSpeakTap,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
