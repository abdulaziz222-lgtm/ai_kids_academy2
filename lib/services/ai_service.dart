import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/story_model.dart';

/// AIService managing Anthropic Claude API requests & smart child-safe AI responses
class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  // Retrieve API Key via --dart-define=ANTHROPIC_API_KEY=your_key
  static const String _envApiKey = String.fromEnvironment('ANTHROPIC_API_KEY');

  Future<String> sendMessageToClaude({
    required String userMessage,
    required String childName,
    required int childAge,
  }) async {
    if (_envApiKey.isNotEmpty) {
      try {
        final response = await http.post(
          Uri.parse('https://api.anthropic.com/v1/messages'),
          headers: {
            'x-api-key': _envApiKey,
            'anthropic-version': '2023-06-01',
            'content-type': 'application/json',
          },
          body: jsonEncode({
            'model': 'claude-3-5-sonnet-20241022',
            'max_tokens': 200,
            'system': 'You are a warm, joyful, educational AI mascot for a child named $childName who is $childAge years old. '
                'RULE 1: Answer in 2 to 4 simple, delightful sentences. '
                'RULE 2: Use kid-friendly emojis. '
                'RULE 3: Never ask for personal private data (phone, address, passwords). '
                'RULE 4: Be encouraging and playful!',
            'messages': [
              {'role': 'user', 'content': userMessage}
            ],
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(utf8.decode(response.bodyBytes));
          final text = data['content'][0]['text'] as String;
          return text.trim();
        }
      } catch (_) {
        // Fallback to local smart generator if network error or invalid key
      }
    }

    // Fallback Kid-Safe Smart AI Engine
    return _generateSmartFallbackChatResponse(userMessage, childName);
  }

  Future<StoryModel> generateAIStory({
    required String childName,
    required String topic,
  }) async {
    if (_envApiKey.isNotEmpty) {
      try {
        final response = await http.post(
          Uri.parse('https://api.anthropic.com/v1/messages'),
          headers: {
            'x-api-key': _envApiKey,
            'anthropic-version': '2023-06-01',
            'content-type': 'application/json',
          },
          body: jsonEncode({
            'model': 'claude-3-5-sonnet-20241022',
            'max_tokens': 600,
            'system': 'Generate a delightful short fairy tale story for a child named $childName about $topic. '
                'Return a valid JSON object with keys: title, content, moralLesson, imagePrompt, coverEmoji.',
            'messages': [
              {'role': 'user', 'content': 'Create a magical story about $topic starring $childName.'}
            ],
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(utf8.decode(response.bodyBytes));
          final text = data['content'][0]['text'] as String;
          final jsonStart = text.indexOf('{');
          final jsonEnd = text.lastIndexOf('}');
          if (jsonStart != -1 && jsonEnd != -1) {
            final jsonString = text.substring(jsonStart, jsonEnd + 1);
            final map = jsonDecode(jsonString);
            return StoryModel(
              title: map['title'] ?? 'The Magical Adventure of $childName',
              content: map['content'] ?? '',
              childName: childName,
              theme: topic,
              moralLesson: map['moralLesson'] ?? 'Always believe in yourself and be kind.',
              imagePrompt: map['imagePrompt'] ?? 'A fairytale illustration of $topic',
              coverEmoji: map['coverEmoji'] ?? '✨',
              createdAt: DateTime.now(),
            );
          }
        }
      } catch (_) {}
    }

    // High quality offline fallback story
    return _generateFallbackStory(childName, topic);
  }

  String _generateSmartFallbackChatResponse(String input, String childName) {
    final lower = input.toLowerCase();
    if (lower.contains('hello') || lower.contains('hi') || lower.contains('salom')) {
      return 'Hello $childName! 🌟 I am so excited to explore and learn with you today! What fun activity shall we try next?';
    } else if (lower.contains('star') || lower.contains('space') || lower.contains('koinot')) {
      return 'Stars are giant glowing balls of light far away in space! 🚀 Astronauts fly in rockets to explore them. Would you like to be a space explorer?';
    } else if (lower.contains('dinosaur') || lower.contains('dino')) {
      return 'Dinosaurs lived millions of years ago! 🦖 Some were huge like T-Rex, and some were tiny like little birds! Roar!';
    } else if (lower.contains('math') || lower.contains('number')) {
      return 'Math is like a magical code puzzle! 🧮 2 + 2 always equals 4! You are becoming a super math whiz!';
    } else if (lower.contains('draw') || lower.contains('color')) {
      return 'I love colorful art! 🎨 You can draw a flying robot, a sparkling rainbow, or a happy dinosaur on our canvas screen!';
    } else {
      return 'That is a wonderful question, $childName! 🌈 Learning new things every day makes our brain super strong! Let us keep exploring together!';
    }
  }

  StoryModel _generateFallbackStory(String childName, String topic) {
    final Map<String, Map<String, String>> topics = {
      'Magic Forest': {
        'title': '$childName and the Whispering Trees 🌲',
        'content': 'Once upon a time, $childName stepped into a sunlit forest where flowers sparkled like stars. '
            'A tiny friendly squirrel with golden wings skipped down a branch and handed $childName a shining blue key. '
            '"This opens the door to the Tree of Friendship!" sang the squirrel. Together, they unlocked a hidden treehouse full of books, giggles, and endless joy.',
        'lesson': 'Sharing adventures with friends makes every magical forest brighter!',
        'emoji': '🌳',
        'prompt': 'A bright magical forest with glowing blue keys and flying squirrels',
      },
      'Space Rocket': {
        'title': 'Captain $childName’s Galactic Flight 🚀',
        'content': 'Captain $childName strapped into the glittering silver rocket craft. With a countdown of 3... 2... 1... BLAST OFF! '
            'The rocket zoomed past purple nebulae and dancing moonbeams. A friendly alien named Pippo waved hello from a floating star station and handed $childName a stardust cookie.',
        'lesson': 'Curiosity and courage can take you to the stars!',
        'emoji': '🚀',
        'prompt': 'A cheerful kid astronaut floating in space with colorful planets and a friendly alien',
      },
      'Underwater Kingdom': {
        'title': '$childName and the Coral Castle 🧜‍♂️',
        'content': 'Deep under the turquoise sea, $childName met a smiling dolphin named Bubble. Bubble guided $childName down to a glowing coral castle where sea turtles were singing happy songs. '
            'They found a shiny Pearl of Joy that made the whole ocean light up with beautiful pastel rainbow colors.',
        'lesson': 'Protecting our ocean friends brings harmony to the entire underwater world!',
        'emoji': '🐠',
        'prompt': 'An underwater turquoise kingdom with friendly dolphins and glowing coral castles',
      },
    };

    final selected = topics[topic] ?? topics['Magic Forest']!;
    return StoryModel(
      title: selected['title']!,
      content: selected['content']!,
      childName: childName,
      theme: topic,
      moralLesson: selected['lesson']!,
      imagePrompt: selected['prompt']!,
      coverEmoji: selected['emoji']!,
      createdAt: DateTime.now(),
    );
  }
}
