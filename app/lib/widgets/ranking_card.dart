import 'package:flutter/material.dart';

import '../models/user.dart';
import '../theme/app_theme.dart';

class RankingCard extends StatelessWidget {
  const RankingCard({
    super.key,
    required this.user,
    required this.isCurrentUser,
  });

  final RankingUser user;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrentUser ? AppColors.lightMint : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isCurrentUser ? AppColors.wiseGreen : const Color(0x1F0E0F0C),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.nearBlack,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${user.rank}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.nickname,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  formatPoint(user.totalRewardPoint),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Text(
            formatKrw(user.totalSavedAmount),
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: AppColors.positive,
            ),
          ),
        ],
      ),
    );
  }
}
