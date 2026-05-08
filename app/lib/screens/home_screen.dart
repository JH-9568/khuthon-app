import 'package:flutter/material.dart';

import '../models/flex_item.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/character_status.dart';
import '../widgets/compare_form.dart';
import '../widgets/virtual_account_card.dart';
import 'flex_shop_screen.dart';
import 'ranking_screen.dart';
import 'records_screen.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.api,
    required this.userId,
    required this.nickname,
  });

  final ApiService api;
  final String userId;
  final String nickname;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserStats? _stats;
  List<PurchasedItem> _items = [];
  bool _loading = true;
  bool _comparing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final stats = await widget.api.getStats(widget.userId, widget.nickname);
      final items = await widget.api.getOwnedItems(widget.userId);
      if (!mounted) return;
      setState(() {
        _stats = stats;
        _items = items;
      });
    } catch (_) {
      setState(() => _error = '상태를 불러오지 못했어요.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _compare(String menuName, int eatingOutPrice) async {
    setState(() => _comparing = true);
    try {
      final result = await widget.api.compare(
        menuName: menuName,
        eatingOutPrice: eatingOutPrice,
      );
      if (!mounted) return;
      final updated = await Navigator.of(context).push<UserStats>(
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            api: widget.api,
            userId: widget.userId,
            nickname: widget.nickname,
            result: result,
          ),
        ),
      );
      if (updated != null) {
        setState(() => _stats = updated);
      }
      await _load();
    } finally {
      if (mounted) setState(() => _comparing = false);
    }
  }

  Future<void> _open(Widget screen) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flex')),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _load,
                child: ListView(
                  padding: const EdgeInsets.all(18),
                  children: [
                    Text(
                      'Hi, ${widget.nickname}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Before the real-life flex, check the home-cooking upside.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 20),
                    if (_error != null)
                      Text(
                        _error!,
                        style: const TextStyle(color: AppColors.danger),
                      ),
                    if (_stats != null) ...[
                      VirtualAccountCard(stats: _stats!),
                      const SizedBox(height: 14),
                      CharacterStatus(stats: _stats!, items: _items),
                      const SizedBox(height: 14),
                    ],
                    CompareForm(onSubmit: _compare, loading: _comparing),
                    const SizedBox(height: 18),
                    _NavGrid(
                      onRecords: () => _open(
                        RecordsScreen(api: widget.api, userId: widget.userId),
                      ),
                      onRanking: () => _open(
                        RankingScreen(
                          api: widget.api,
                          userId: widget.userId,
                          nickname: widget.nickname,
                        ),
                      ),
                      onShop: () => _open(
                        FlexShopScreen(
                          api: widget.api,
                          userId: widget.userId,
                          nickname: widget.nickname,
                          initialStats: _stats!,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _NavGrid extends StatelessWidget {
  const _NavGrid({
    required this.onRecords,
    required this.onRanking,
    required this.onShop,
  });

  final VoidCallback onRecords;
  final VoidCallback onRanking;
  final VoidCallback onShop;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _NavPill(label: 'Records', icon: Icons.receipt_long, onTap: onRecords),
        _NavPill(label: 'Ranking', icon: Icons.leaderboard, onTap: onRanking),
        _NavPill(label: 'Flex shop', icon: Icons.shopping_bag, onTap: onShop),
      ],
    );
  }
}

class _NavPill extends StatelessWidget {
  const _NavPill({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
