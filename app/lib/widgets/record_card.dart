import 'package:flutter/material.dart';

import '../models/consumption_record.dart';
import '../theme/app_theme.dart';

class RecordCard extends StatelessWidget {
  const RecordCard({super.key, required this.record});

  final ConsumptionRecord record;

  @override
  Widget build(BuildContext context) {
    final cooked = record.choice == 'cook';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x1F0E0F0C)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  record.menuName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: cooked ? AppColors.lightMint : const Color(0xFFFFE8E8),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  cooked ? '집밥 선택' : '외식 선택',
                  style: TextStyle(
                    color: cooked ? AppColors.positive : AppColors.danger,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '외식 ${formatKrw(record.eatingOutPrice)} vs 집밥 ${formatKrw(record.homeCookingCost)}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            cooked
                ? '${formatKrw(record.savingAmount)} 절약 · ${formatPoint(record.rewardPoint)}'
                : '가상 잔고 -${formatKrw(record.eatingOutPrice)}',
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: AppColors.nearBlack,
            ),
          ),
        ],
      ),
    );
  }
}
