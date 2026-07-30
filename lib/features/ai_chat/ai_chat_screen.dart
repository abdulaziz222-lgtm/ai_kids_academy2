import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/child_mode_scaffold.dart';
import '../../models/child_profile.dart';
import '../../services/ai_service.dart';
import '../../services/speech_service.dart';
import '../../services/tts_service.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({required this.text, required this.isUser, required this.timestamp});
}

/// AI Buddy Chat Screen powered by Anthropic Claude API
class AIChatScreen extends StatefulWidget {
  final ChildProfile childProfile;
  const AIChatScreen({super.key, required this.childProfile});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AIService _aiService = AIService();
  final TTSService _tts = TTSService();
  final SpeechService _speech = SpeechService();

  bool _isTyping = false;
  bool _isListening = false;

  final List<String> _quickSuggestions = [
    'Why is the sky blue? ☁️',
    'Tell me a funny joke! 😂',
    'How do rockets fly? 🚀',
    'Why do dinosaurs roar? 🦖',
  ];

  @override
  void initState() {
    super.initState();
    _tts.init();
    _messages.add(
      ChatMessage(
        text: "Hello ${widget.childProfile.name}! 🌟 Ask me any fun question about stars, animals, or world wonders!",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  void _sendMessage([String? customText]) async {
    final messageText = customText ?? _textController.text.trim();
    if (messageText.isEmpty) return;

    _textController.clear();
    setState(() {
      _messages.add(ChatMessage(text: messageText, isUser: true, timestamp: DateTime.now()));
      _isTyping = true;
    });
    _scrollToBottom();

    final responseText = await _aiService.sendMessageToClaude(
      userMessage: messageText,
      childName: widget.childProfile.name,
      childAge: widget.childProfile.age,
    );

    if (mounted) {
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(text: responseText, isUser: false, timestamp: DateTime.now()));
      });
      _scrollToBottom();
      _tts.speak(responseText);
    }
  }

  void _listenVoice() async {
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
    } else {
      setState(() => _isListening = true);
      await _speech.listen(
        onResult: (text) {
          setState(() {
            _textController.text = text;
            _isListening = false;
          });
          _sendMessage(text);
        },
      );
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChildModeScaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(widget.childProfile.avatar, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 8),
                Text('AI Buddy Chat 💬', style: AppTextStyles.heading2),
              ],
            ),
          ),
          // Quick Prompt Pills
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _quickSuggestions.length,
              itemBuilder: (context, index) {
                final sug = _quickSuggestions[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: Text(sug, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary)),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: AppColors.primaryLight),
                    onPressed: () => _sendMessage(sug),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildBubble(msg);
              },
            ),
          ),
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                  ),
                  const SizedBox(width: 8),
                  Text('AI Buddy is thinking... ✨', style: AppTextStyles.bodySmall),
                ],
              ),
            ),
          // Input Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                    color: _isListening ? Colors.redAccent : AppColors.primary,
                  ),
                  onPressed: _listenVoice,
                ),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Ask your question...',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: AppColors.primary),
                  onPressed: () => _sendMessage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(ChatMessage msg) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: msg.isUser ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 3))],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                msg.text,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: msg.isUser ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
            if (!msg.isUser) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _tts.speak(msg.text),
                child: const Icon(Icons.volume_up_rounded, size: 20, color: AppColors.primary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
