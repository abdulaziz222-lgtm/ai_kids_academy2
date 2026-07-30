/// Story Model for AI Story Generator
class StoryModel {
  final String title;
  final String content;
  final String childName;
  final String theme;
  final String moralLesson;
  final String imagePrompt;
  final String coverEmoji;
  final DateTime createdAt;

  StoryModel({
    required this.title,
    required this.content,
    required this.childName,
    required this.theme,
    required this.moralLesson,
    required this.imagePrompt,
    required this.coverEmoji,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'childName': childName,
      'theme': theme,
      'moralLesson': moralLesson,
      'imagePrompt': imagePrompt,
      'coverEmoji': coverEmoji,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory StoryModel.fromMap(Map<String, dynamic> map) {
    return StoryModel(
      title: map['title'] ?? 'The Magical Adventure',
      content: map['content'] ?? '',
      childName: map['childName'] ?? 'Explorer',
      theme: map['theme'] ?? 'Magic Forest',
      moralLesson: map['moralLesson'] ?? 'Kindness brings true joy.',
      imagePrompt: map['imagePrompt'] ?? 'A colorful magic forest',
      coverEmoji: map['coverEmoji'] ?? '✨',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
