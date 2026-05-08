class Ingredient {
  const Ingredient({required this.name, required this.estimatedPrice});

  final String name;
  final int estimatedPrice;

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] as String,
      estimatedPrice: (json['estimatedPrice'] as num).round(),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'estimatedPrice': estimatedPrice,
  };
}
