import 'package:flutter_tts/flutter_tts.dart';

/// TTSService wrapping flutter_tts for reading stories, AI responses, and letter sounds
class TTSService {
  static final TTSService _instance = TTSService._internal();
  factory TTSService() => _instance;
  TTSService._internal();

  final FlutterTts _tts = FlutterTts();
  bool _isSpeaking = false;

  bool get isSpeaking => _isSpeaking;

  Future<void> init() async {
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.45); // Gentle, slow pace for children
      await _tts.setPitch(1.2); // Warm friendly pitch
      await _tts.setVolume(1.0);

      _tts.setStartHandler(() {
        _isSpeaking = true;
      });

      _tts.setCompletionHandler(() {
        _isSpeaking = false;
      });

      _tts.setErrorHandler((msg) {
        _isSpeaking = false;
      });
    } catch (_) {}
  }

  Future<void> speak(String text) async {
    if (text.isEmpty) return;
    try {
      await stop();
      await _tts.speak(text);
    } catch (_) {}
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
      _isSpeaking = false;
    } catch (_) {}
  }
}
