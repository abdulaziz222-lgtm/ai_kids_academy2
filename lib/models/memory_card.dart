/// Memory Card model for 3D card flip game
class MemoryCard {
  final int id;
  final String symbol;
  final String name;
  bool isFaceUp;
  bool isMatched;

  MemoryCard({
    required this.id,
    required this.symbol,
    required this.name,
    this.isFaceUp = false,
    this.isMatched = false,
  });

  MemoryCard copyWith({
    int? id,
    String? symbol,
    String? name,
    bool? isFaceUp,
    bool? isMatched,
  }) {
    return MemoryCard(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      isFaceUp: isFaceUp ?? this.isFaceUp,
      isMatched: isMatched ?? this.isMatched,
    );
  }

  static List<MemoryCard> generateDeck(int pairsCount) {
    final availableSymbols = [
      {'symbol': '🦁', 'name': 'Lion'},
      {'symbol': '🐘', 'name': 'Elephant'},
      {'symbol': '🚀', 'name': 'Rocket'},
      {'symbol': '🦄', 'name': 'Unicorn'},
      {'symbol': '🍎', 'name': 'Apple'},
      {'symbol': '🎨', 'name': 'Palette'},
      {'symbol': '🎸', 'name': 'Guitar'},
      {'symbol': '🍦', 'name': 'Ice Cream'},
      {'symbol': '⭐', 'name': 'Star'},
      {'symbol': '⛵', 'name': 'Boat'},
      {'symbol': '🧩', 'name': 'Puzzle'},
      {'symbol': '👑', 'name': 'Crown'},
    ];

    availableSymbols.shuffle();
    final selected = availableSymbols.take(pairsCount).toList();

    List<MemoryCard> cards = [];
    int cardId = 0;
    for (var item in selected) {
      cards.add(MemoryCard(id: cardId++, symbol: item['symbol']!, name: item['name']!));
      cards.add(MemoryCard(id: cardId++, symbol: item['symbol']!, name: item['name']!));
    }
    cards.shuffle();
    return cards;
  }
}
