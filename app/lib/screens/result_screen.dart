import 'package:flutter/material.dart';

import '../models/compare_result.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_background.dart';
import '../widgets/flex_design_widgets.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({
    super.key,
    required this.api,
    required this.userId,
    required this.nickname,
    required this.result,
  });

  final ApiService api;
  final String userId;
  final String nickname;
  final CompareResult result;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _saving = false;
  String? _error;

  Future<void> _choose(String choice) async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final response = await widget.api.saveDecision(
        userId: widget.userId,
        result: widget.result,
        choice: choice,
        nickname: widget.nickname,
      );
      if (!mounted) return;
      if (choice == 'cook') {
        await _showRewardFeedback(response.userStats);
        if (!mounted) return;
      }
      Navigator.of(context).pop<DecisionResponse>(response);
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _showRewardFeedback(UserStats stats) {
    return showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const PoriMascotPlaceholder(size: 118),
              const SizedBox(height: 8),
              const Text(
                '절약 성공!',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              Text(
                '${formatKrw(widget.result.savingAmount)} 절약하고 ${formatPoint(widget.result.rewardPoint)}를 얻었어요.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                '현재 가상 잔고 ${formatKrw(stats.virtualBalance)}',
                style: const TextStyle(
                  color: AppColors.positive,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('확인'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              HeaderBar(
                showBack: true,
                title: '비교 결과',
                onBack: () => Navigator.of(context).maybePop(),
              ),
              const SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '오늘도 스마트한 선택!',
                          style: TextStyle(
                            color: AppColors.darkGreen,
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '포리와 함께 🌱',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 12),
                        FittedBox(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            formatKrw(result.savingAmount),
                            style: const TextStyle(
                              color: AppColors.positive,
                              fontSize: 54,
                              fontWeight: FontWeight.w900,
                              height: .95,
                            ),
                          ),
                        ),
                        const Text(
                          '절약했어요!',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const PoriMascotPlaceholder(size: 176),
                ],
              ),
              const SizedBox(height: 18),
              CompareResultCard(result: result),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: AppColors.pastelGreen.withValues(alpha: .55),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightGreen,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Text(
                        '포인트 적립!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Text(
                      '집밥 선택 시',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const Spacer(),
                    Text(
                      '${formatPoint(result.rewardPoint)} 적립',
                      style: const TextStyle(
                        color: AppColors.positive,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _IngredientPanel(result: result)),
                  const SizedBox(width: 12),
                  Expanded(child: _RecipePreview(result: result)),
                ],
              ),
              const SizedBox(height: 14),
              _RecipeSteps(result: result),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: const TextStyle(
                    color: AppColors.danger,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 62,
                      child: OutlinedButton(
                        onPressed: _saving ? null : () => _choose('eat_out'),
                        child: const Text('외식할래요'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 62,
                      child: ElevatedButton.icon(
                        onPressed: _saving ? null : () => _choose('cook'),
                        icon: const Icon(Icons.card_giftcard_rounded),
                        label: const Text('집밥 선택하기'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IngredientPanel extends StatelessWidget {
  const _IngredientPanel({required this.result});

  final CompareResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _panelDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '이번 레시피에 필요한 재료',
            style: TextStyle(
              color: AppColors.darkGreen,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          for (final ingredient in result.ingredients)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const Icon(Icons.eco_rounded, color: AppColors.lightGreen),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ingredient.name,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              '(1인분 기준)',
              style: TextStyle(color: AppColors.warmDark, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecipePreview extends StatelessWidget {
  const _RecipePreview({required this.result});

  final CompareResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _panelDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  '추천 레시피 미리보기',
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Icon(Icons.bookmark_border_rounded, color: AppColors.darkGreen),
            ],
          ),
          const SizedBox(height: 12),
          const AssetOrPlaceholder(
            assetPath: 'assets/items/food_chicken.png',
            height: 112,
            width: double.infinity,
            fit: BoxFit.cover,
            icon: Icons.rice_bowl_rounded,
            background: AppColors.cream,
          ),
          const SizedBox(height: 10),
          Text(
            '${result.menuName} 집밥 레시피',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          const Row(
            children: [
              Icon(Icons.favorite, size: 16, color: Color(0xFFFF9C66)),
              SizedBox(width: 4),
              Text('4.8', style: TextStyle(fontWeight: FontWeight.w800)),
              Spacer(),
              Icon(Icons.chevron_right),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecipeSteps extends StatelessWidget {
  const _RecipeSteps({required this.result});

  final CompareResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _panelDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              '👨‍🍳  레시피 요리 방법',
              style: TextStyle(
                color: AppColors.darkGreen,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < result.recipe.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 13,
                    backgroundColor: AppColors.primaryGreen,
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      result.recipe[i],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 6),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE8E1D4)),
            ),
            child: Text(
              '🌱 포리의 팁   ${result.message}',
              style: const TextStyle(
                color: AppColors.darkGreen,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _panelDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(18),
    border: Border.all(color: const Color(0xFFE9ECE5)),
    boxShadow: const [
      BoxShadow(color: Color(0x0A333333), blurRadius: 14, offset: Offset(0, 6)),
    ],
  );
}
