class ConsumptionRecord {
  const ConsumptionRecord({
    required this.id,
    required this.userId,
    required this.menuName,
    required this.eatingOutPrice,
    required this.homeCookingCost,
    required this.savingAmount,
    required this.rewardPoint,
    required this.choice,
    required this.message,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String menuName;
  final int eatingOutPrice;
  final int homeCookingCost;
  final int savingAmount;
  final int rewardPoint;
  final String choice;
  final String message;
  final DateTime createdAt;

  factory ConsumptionRecord.fromJson(Map<String, dynamic> json) {
    return ConsumptionRecord(
      id: json['id'] as String,
      userId: json['userId'] as String,
      menuName: json['menuName'] as String,
      eatingOutPrice: (json['eatingOutPrice'] as num).round(),
      homeCookingCost: (json['homeCookingCost'] as num).round(),
      savingAmount: (json['savingAmount'] as num).round(),
      rewardPoint: (json['rewardPoint'] as num).round(),
      choice: json['choice'] as String,
      message: json['message'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'menuName': menuName,
    'eatingOutPrice': eatingOutPrice,
    'homeCookingCost': homeCookingCost,
    'savingAmount': savingAmount,
    'rewardPoint': rewardPoint,
    'choice': choice,
    'message': message,
    'createdAt': createdAt.toIso8601String(),
  };
}
