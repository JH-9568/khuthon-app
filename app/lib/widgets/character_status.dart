import 'package:flutter/material.dart';

import '../models/flex_item.dart';
import '../models/user.dart';
import '../theme/app_theme.dart';

class CharacterStatus extends StatelessWidget {
  const CharacterStatus({super.key, required this.stats, required this.items});

  final UserStats stats;
  final List<PurchasedItem> items;

  @override
  Widget build(BuildContext context) {
    final state = _state(stats.virtualBalance);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0x1F0E0F0C)),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.lightMint,
              shape: BoxShape.circle,
            ),
            child: Text(state.emoji, style: const TextStyle(fontSize: 34)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 5),
                Text(
                  state.message,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (items.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    children: items
                        .take(4)
                        .map(
                          (item) => Text(
                            item.emoji,
                            style: const TextStyle(fontSize: 20),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  _CharacterCopy _state(int balance) {
    if (balance <= -50000) {
      return const _CharacterCopy(
        'bankrupt_warning',
        'Careful mode',
        'Pause the flex. Your virtual wallet is under pressure.',
        '🚨',
      );
    }
    if (balance < 0) {
      return const _CharacterCopy(
        'poor_getting_worse',
        'Leak detected',
        'Eating out is pulling the balance below zero.',
        '😵',
      );
    }
    if (balance > 0) {
      return const _CharacterCopy(
        'rich_getting_better',
        'Getting richer',
        'Home-cooking choices are making the character glow.',
        '😎',
      );
    }
    return const _CharacterCopy(
      'neutral',
      'Ready to choose',
      'Compare a meal and let the next decision move the balance.',
      '🙂',
    );
  }
}

class _CharacterCopy {
  const _CharacterCopy(this.state, this.title, this.message, this.emoji);

  final String state;
  final String title;
  final String message;
  final String emoji;
}
