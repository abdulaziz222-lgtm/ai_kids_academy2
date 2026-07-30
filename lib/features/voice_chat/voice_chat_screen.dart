import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/child_mode_scaffold.dart';
import '../../models/child_profile.dart';
import '../../services/ai_service.dart';
import '../../services/speech_service.dart';
import '../../services/tts_service.dart';

/// Interactive Voice Conversation Screen with Mascot Visualizer
class VoiceChatScreen extends StatefulWidget {
  final ChildProfile childProfile;
  const VoiceChatScreen({super.key, required this.childProfile});

  @override
  State<VoiceChatScreen> createState() => _VoiceChatScreenState();
}

class _VoiceChatScreenState extends State<VoiceChatScreen> with SingleTickerProviderStateMixin {
  final SpeechService _speech = SpeechService();
  final AIService _ai = AIService();
  final TTSService _tts = TTSService();

  late AnimationController _pulseController;
  bool _isListening = false;
  bool _isAiThinking = false;
  String _spokenText = "Tap the big mascot and speak to your AI buddy!";
  String _aiResponse = "";

  @override
  void initState() {
    super.initState();
    _tts.init();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _tts.stop();
    _speech.stop();
    super.dispose();
  }

  void _toggleVoiceConversation() async {
    if (_isListening) {
      await _speech.stop();
      _pulseController.stop();
      setState(() => _isListening = false);
    } else {
      await _tts.stop();
      setState(() {
        _isListening = true;
        _spokenText = "Listening to you... 👂";
      });
      _pulseController.repeat(reverse: true);

      await _speech.listen(
        onResult: (text) async {
          _pulseController.stop();
          setState(() {
            _isListening = false;
            _isAiThinking = true;
            _spokenText = text;
          });

          final reply = await _ai.sendMessageToClaude(
            userMessage: text,
            childName: widget.childProfile.name,
            childAge: widget.childProfile.age,
          );

          if (mounted) {
            setState(() {
              _isAiThinking = false;
              _aiResponse = reply;
            });
            _tts.speak(reply);
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChildModeScaffold(
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
                Text('Voice Buddy 🎙️', style: AppTextStyles.heading2),
              ],
            ),
            const Spacer(),
            // Animated Pulsing Mascot Button
            GestureDetector(
              onTap: _toggleVoiceConversation,
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final scale = 1.0 + (_pulseController.value * 0.15);
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isListening ? AppColors.secondary : AppColors.primary,
                        boxShadow: [
                          BoxShadow(
                            color: (_isListening ? AppColors.secondary : AppColors.primary).withOpacity(0.4),
                            blurRadius: 28,
                            spreadRadius: 6,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          widget.childProfile.avatar,
                          style: const TextStyle(fontSize: 84),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            Text(
              _isListening
                  ? "I'm listening! Speak now... 🎤"
                  : (_isAiThinking ? "AI is thinking... ✨" : "Tap Mascot to Talk!"),
              style: AppTextStyles.heading2.copyWith(color: AppColors.primary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 12, offset: Offset(0, 4))],
              ),
              child: Column(
                children: [
                  Text('You said:', style: AppTextStyles.bodySmall),
                  Text(_spokenText, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
                  if (_aiResponse.isNotEmpty) ...[
                    const Divider(height: 20),
                    Text('AI replied:', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary)),
                    Text(_aiResponse, style: AppTextStyles.bodyLarge, textAlign: TextAlign.center),
                  ],
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
