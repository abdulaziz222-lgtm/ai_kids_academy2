import 'dart:convert';

/// Child Profile Data Model
class ChildProfile {
  final String name;
  final int age;
  final String avatar;
  final String ageGroup;
  final int coins;
  final int stars;

  ChildProfile({
    required this.name,
    required this.age,
    required this.avatar,
    required this.ageGroup,
    required this.coins,
    required this.stars,
  });

  ChildProfile copyWith({
    String? name,
    int? age,
    String? avatar,
    String? ageGroup,
    int? coins,
    int? stars,
  }) {
    return ChildProfile(
      name: name ?? this.name,
      age: age ?? this.age,
      avatar: avatar ?? this.avatar,
      ageGroup: ageGroup ?? this.ageGroup,
      coins: coins ?? this.coins,
      stars: stars ?? this.stars,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'avatar': avatar,
      'ageGroup': ageGroup,
      'coins': coins,
      'stars': stars,
    };
  }

  factory ChildProfile.fromMap(Map<String, dynamic> map) {
    return ChildProfile(
      name: map['name'] ?? 'Super Star',
      age: map['age']?.toInt() ?? 5,
      avatar: map['avatar'] ?? '🐱',
      ageGroup: map['ageGroup'] ?? '3-5',
      coins: map['coins']?.toInt() ?? 100,
      stars: map['stars']?.toInt() ?? 5,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChildProfile.fromJson(String source) => ChildProfile.fromMap(json.decode(source));
}
