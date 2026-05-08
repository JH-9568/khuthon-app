class User {
  const User({
    required this.id,
    required this.nickname,
    required this.totalSavedAmount,
    required this.totalRewardPoint,
    required this.virtualBalance,
    required this.createdAt,
  });

  final String id;
  final String nickname;
  final int totalSavedAmount;
  final int totalRewardPoint;
  final int virtualBalance;
  final DateTime createdAt;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      totalSavedAmount: (json['totalSavedAmount'] as num).round(),
      totalRewardPoint: (json['totalRewardPoint'] as num).round(),
      virtualBalance: (json['virtualBalance'] as num).round(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class UserStats {
  const UserStats({
    required this.userId,
    required this.nickname,
    required this.totalSavedAmount,
    required this.totalRewardPoint,
    required this.virtualBalance,
    required this.ownedItemCount,
    required this.recordCount,
  });

  final String userId;
  final String nickname;
  final int totalSavedAmount;
  final int totalRewardPoint;
  final int virtualBalance;
  final int ownedItemCount;
  final int recordCount;

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      userId: json['userId'] as String? ?? json['id'] as String? ?? 'mock_user',
      nickname: json['nickname'] as String? ?? '절약러',
      totalSavedAmount: (json['totalSavedAmount'] as num).round(),
      totalRewardPoint: (json['totalRewardPoint'] as num).round(),
      virtualBalance: (json['virtualBalance'] as num).round(),
      ownedItemCount: (json['ownedItemCount'] as num?)?.round() ?? 0,
      recordCount: (json['recordCount'] as num?)?.round() ?? 0,
    );
  }

  UserStats copyWith({
    int? totalSavedAmount,
    int? totalRewardPoint,
    int? virtualBalance,
    int? ownedItemCount,
    int? recordCount,
  }) {
    return UserStats(
      userId: userId,
      nickname: nickname,
      totalSavedAmount: totalSavedAmount ?? this.totalSavedAmount,
      totalRewardPoint: totalRewardPoint ?? this.totalRewardPoint,
      virtualBalance: virtualBalance ?? this.virtualBalance,
      ownedItemCount: ownedItemCount ?? this.ownedItemCount,
      recordCount: recordCount ?? this.recordCount,
    );
  }
}

class RankingUser {
  const RankingUser({
    required this.rank,
    required this.userId,
    required this.nickname,
    required this.totalSavedAmount,
    required this.totalRewardPoint,
    required this.virtualBalance,
  });

  final int rank;
  final String userId;
  final String nickname;
  final int totalSavedAmount;
  final int totalRewardPoint;
  final int virtualBalance;

  factory RankingUser.fromJson(Map<String, dynamic> json) {
    return RankingUser(
      rank: (json['rank'] as num).round(),
      userId: json['userId'] as String,
      nickname: json['nickname'] as String,
      totalSavedAmount: (json['totalSavedAmount'] as num).round(),
      totalRewardPoint: (json['totalRewardPoint'] as num).round(),
      virtualBalance: (json['virtualBalance'] as num).round(),
    );
  }
}
