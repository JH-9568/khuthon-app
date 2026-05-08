class FlexItem {
  const FlexItem({
    required this.id,
    required this.name,
    required this.price,
    required this.emoji,
    required this.category,
    required this.description,
  });

  final String id;
  final String name;
  final int price;
  final String emoji;
  final String category;
  final String description;

  factory FlexItem.fromJson(Map<String, dynamic> json) {
    return FlexItem(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).round(),
      emoji: json['emoji'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'emoji': emoji,
    'category': category,
    'description': description,
  };
}

class PurchasedItem extends FlexItem {
  const PurchasedItem({
    required super.id,
    required super.name,
    required super.price,
    required super.emoji,
    required super.category,
    required super.description,
    required this.purchasedAt,
  });

  final DateTime purchasedAt;

  factory PurchasedItem.fromJson(Map<String, dynamic> json) {
    return PurchasedItem(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).round(),
      emoji: json['emoji'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      purchasedAt: DateTime.parse(json['purchasedAt'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'purchasedAt': purchasedAt.toIso8601String(),
  };
}
