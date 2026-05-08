import 'package:flutter/material.dart';

import '../models/flex_item.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_background.dart';
import '../widgets/flex_item_card.dart';

class FlexShopScreen extends StatefulWidget {
  const FlexShopScreen({
    super.key,
    required this.api,
    required this.userId,
    required this.nickname,
    required this.initialStats,
  });

  final ApiService api;
  final String userId;
  final String nickname;
  final UserStats initialStats;

  @override
  State<FlexShopScreen> createState() => _FlexShopScreenState();
}

class _FlexShopScreenState extends State<FlexShopScreen> {
  List<FlexItem> _items = [];
  List<PurchasedItem> _owned = [];
  late UserStats _stats;
  bool _loading = true;
  String? _busyItemId;
  String? _message;
  String? _error;

  @override
  void initState() {
    super.initState();
    _stats = widget.initialStats;
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final items = await widget.api.getFlexItems();
      final owned = await widget.api.getOwnedItems(widget.userId);
      if (!mounted) return;
      setState(() {
        _items = items;
        _owned = owned;
      });
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) setState(() => _error = '플렉스샵을 불러오지 못했어요.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _buy(FlexItem item) async {
    setState(() {
      _busyItemId = item.id;
      _message = null;
    });
    try {
      final response = await widget.api.purchaseItem(
        userId: widget.userId,
        nickname: widget.nickname,
        item: item,
      );
      final owned = await widget.api.getOwnedItems(widget.userId);
      if (!mounted) return;
      setState(() {
        _stats = response.userStats;
        _owned = owned;
        _message = '${response.purchasedItem.name} 아이템을 보유했어요.';
      });
    } on ApiException catch (error) {
      setState(() => _message = error.message);
    } finally {
      if (mounted) setState(() => _busyItemId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('플렉스샵')),
      body: AppBackground(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.danger,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  Text(
                    '앱 안에서만 안전하게 플렉스',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.nearBlack,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '보유 포인트',
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          formatPoint(_stats.totalRewardPoint),
                          style: const TextStyle(
                            color: AppColors.wiseGreen,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_owned.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      '보유 아이템',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _owned
                          .map(
                            (item) => Chip(
                              backgroundColor: AppColors.lightMint,
                              label: Text('${item.emoji} ${item.name}'),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  if (_message != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _message!,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ],
                  const SizedBox(height: 16),
                  ..._items.map(
                    (item) => FlexItemCard(
                      item: item,
                      owned: _owned.any((owned) => owned.id == item.id),
                      canBuy: _stats.totalRewardPoint >= item.price,
                      loading: _busyItemId == item.id,
                      onBuy: () => _buy(item),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
