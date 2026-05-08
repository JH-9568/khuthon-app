import 'package:flutter/material.dart';

import '../models/flex_item.dart';
import '../theme/app_theme.dart';

class FlexItemCard extends StatelessWidget {
  const FlexItemCard({
    super.key,
    required this.item,
    required this.owned,
    required this.canBuy,
    required this.loading,
    required this.onBuy,
  });

  final FlexItem item;
  final bool owned;
  final bool canBuy;
  final bool loading;
  final VoidCallback onBuy;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0x1F0E0F0C)),
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.lightMint,
              shape: BoxShape.circle,
            ),
            child: Text(item.emoji, style: const TextStyle(fontSize: 30)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  formatPoint(item.price),
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 88,
            child: ElevatedButton(
              onPressed: owned || !canBuy || loading ? null : onBuy,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),
              ),
              child: Text(owned ? 'Owned' : 'Buy'),
            ),
          ),
        ],
      ),
    );
  }
}
