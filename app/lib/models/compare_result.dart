import 'ingredient.dart';

class CompareResult {
  const CompareResult({
    required this.menuName,
    required this.eatingOutPrice,
    required this.homeCookingCost,
    required this.savingAmount,
    required this.rewardPoint,
    required this.ingredients,
    required this.recipe,
    required this.message,
    required this.source,
  });

  final String menuName;
  final int eatingOutPrice;
  final int homeCookingCost;
  final int savingAmount;
  final int rewardPoint;
  final List<Ingredient> ingredients;
  final List<String> recipe;
  final String message;
  final String source;

  factory CompareResult.fromJson(Map<String, dynamic> json) {
    return CompareResult(
      menuName: json['menuName'] as String,
      eatingOutPrice: (json['eatingOutPrice'] as num).round(),
      homeCookingCost: (json['homeCookingCost'] as num).round(),
      savingAmount: (json['savingAmount'] as num).round(),
      rewardPoint: (json['rewardPoint'] as num).round(),
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((item) => Ingredient.fromJson(item as Map<String, dynamic>))
          .toList(),
      recipe: (json['recipe'] as List<dynamic>).cast<String>(),
      message: json['message'] as String,
      source: json['source'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'menuName': menuName,
    'eatingOutPrice': eatingOutPrice,
    'homeCookingCost': homeCookingCost,
    'savingAmount': savingAmount,
    'rewardPoint': rewardPoint,
    'ingredients': ingredients.map((item) => item.toJson()).toList(),
    'recipe': recipe,
    'message': message,
    'source': source,
  };
}
