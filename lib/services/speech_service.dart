import 'package:speech_to_text/speech_to_text.dart' as stt;

/// SpeechService wrapping speech_to_text package for hands-free child voice input
class SpeechService {
  static final SpeechService _instance = SpeechService._internal();
  factory SpeechService() => _instance;
  SpeechService._internal();

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;

  Future<bool> initialize() async {
    if (_isInitialized) return true;
    try {
      _isInitialized = await _speech.initialize(
        onError: (val) {},
        onStatus: (val) {},
      );
    } catch (_) {
      _isInitialized = false;
    }
    return _isInitialized;
  }

  bool get isListening => _speech.isListening;

  Future<void> listen({
    required Function(String text) onResult,
    Function(bool isListening)? onListeningStateChanged,
  }) async {
    final available = await initialize();
    if (available) {
      if (onListeningStateChanged != null) onListeningStateChanged(true);
      await _speech.listen(
        onResult: (result) {
          if (result.finalResult || result.recognizedWords.isNotEmpty) {
            onResult(result.recognizedWords);
          }
        },
        listenFor: const Duration(seconds: 10),
        pauseFor: const Duration(seconds: 3),
      );
    }
  }

  Future<void> stop() async {
    if (_speech.isListening) {
      await _speech.stop();
    }
  }
}
