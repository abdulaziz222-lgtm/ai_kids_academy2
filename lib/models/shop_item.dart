enum ShopCategory { avatar, sticker, theme, mascot }

/// Model for Shop Unlockables (Avatars, Stickers, Themes, Mascot Outfits)
class ShopItem {
  final String id;
  final String title;
  final String avatarEmoji;
  final int price;
  final ShopCategory category;
  final bool isPurchased;

  ShopItem({
    required this.id,
    required this.title,
    required this.avatarEmoji,
    required this.price,
    required this.category,
    this.isPurchased = false,
  });

  ShopItem copyWith({
    String? id,
    String? title,
    String? avatarEmoji,
    int? price,
    ShopCategory? category,
    bool? isPurchased,
  }) {
    return ShopItem(
      id: id ?? this.id,
      title: title ?? this.title,
      avatarEmoji: avatarEmoji ?? this.avatarEmoji,
      price: price ?? this.price,
      category: category ?? this.category,
      isPurchased: isPurchased ?? this.isPurchased,
    );
  }

  static List<ShopItem> get catalog => [
        ShopItem(id: 'cat_avatar', title: 'Cool Kitten', avatarEmoji: '🐱', price: 0, category: ShopCategory.avatar, isPurchased: true),
        ShopItem(id: 'puppy_avatar', title: 'Playful Puppy', avatarEmoji: '🐶', price: 50, category: ShopCategory.avatar),
        ShopItem(id: 'fox_avatar', title: 'Clever Fox', avatarEmoji: '🦊', price: 80, category: ShopCategory.avatar),
        ShopItem(id: 'lion_avatar', title: 'Brave Lion', avatarEmoji: '🦁', price: 100, category: ShopCategory.avatar),
        ShopItem(id: 'panda_avatar', title: 'Panda Bear', avatarEmoji: '🐼', price: 120, category: ShopCategory.avatar),
        ShopItem(id: 'unicorn_avatar', title: 'Magic Unicorn', avatarEmoji: '🦄', price: 150, category: ShopCategory.avatar),
        ShopItem(id: 'dragon_avatar', title: 'Tiny Dragon', avatarEmoji: '🐲', price: 200, category: ShopCategory.avatar),
        ShopItem(id: 'robot_avatar', title: 'AI Bot 3000', avatarEmoji: '🤖', price: 250, category: ShopCategory.avatar),
        
        ShopItem(id: 'star_sticker', title: 'Golden Star', avatarEmoji: '⭐', price: 30, category: ShopCategory.sticker),
        ShopItem(id: 'fire_sticker', title: 'On Fire', avatarEmoji: '🔥', price: 40, category: ShopCategory.sticker),
        ShopItem(id: 'crown_sticker', title: 'Royalty Crown', avatarEmoji: '👑', price: 60, category: ShopCategory.sticker),
        
        ShopItem(id: 'superhero_mascot', title: 'Superhero Outfit', avatarEmoji: '🦸‍♂️', price: 180, category: ShopCategory.mascot),
        ShopItem(id: 'astronaut_mascot', title: 'Astronaut Suit', avatarEmoji: '👨‍🚀', price: 220, category: ShopCategory.mascot),
      ];
}
