import 'package:flutter/material.dart';

import '../models/compare_result.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/result_card.dart';

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
      Navigator.of(context).pop<UserStats>(response.userStats);
    } on ApiException catch (error) {
      setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    return Scaffold(
      appBar: AppBar(title: const Text('Compare')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    result.menuName,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightMint,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    result.source.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.positive,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.25,
              children: [
                ResultCard(
                  label: 'Eating out',
                  value: formatKrw(result.eatingOutPrice),
                ),
                ResultCard(
                  label: 'Home cost',
                  value: formatKrw(result.homeCookingCost),
                ),
                ResultCard(
                  label: 'Saving',
                  value: formatKrw(result.savingAmount),
                  highlight: true,
                ),
                ResultCard(
                  label: 'Reward',
                  value: formatPoint(result.rewardPoint),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _Panel(
              title: 'Ingredients',
              child: Column(
                children: result.ingredients
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Expanded(child: Text(item.name)),
                            Text(
                              formatKrw(item.estimatedPrice),
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 12),
            _Panel(
              title: 'Recipe',
              child: Column(
                children: [
                  for (var i = 0; i < result.recipe.length; i++)
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.nearBlack,
                        child: Text(
                          '${i + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      title: Text(result.recipe[i]),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7D0),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                result.message,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  height: 1.35,
                ),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(
                _error!,
                style: const TextStyle(
                  color: AppColors.danger,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: _saving ? null : () => _choose('cook'),
              child: const Text('Cook at home'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: _saving ? null : () => _choose('eat_out'),
              child: const Text('Eat out this time'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0x1F0E0F0C)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
