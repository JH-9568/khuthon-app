import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/consumption_record.dart';
import '../models/flex_item.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_background.dart';
import '../widgets/flex_design_widgets.dart';
import 'result_screen.dart';
import 'room_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.api,
    required this.userId,
    required this.nickname,
    required this.onLogout,
  });

  final ApiService api;
  final String userId;
  final String nickname;
  final Future<void> Function() onLogout;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserStats? _stats;
  List<PurchasedItem> _ownedItems = [];
  List<RankingUser> _rankings = [];
  List<ConsumptionRecord> _records = [];
  List<FlexItem> _shopItems = [];
  bool _loading = true;
  bool _comparing = false;
  String? _busyItemId;
  String? _message;
  String? _error;
  int _selectedIndex = 0;

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
      final owned = await widget.api.getOwnedItems(widget.userId);
      final rankings = await widget.api.getRankings(
        widget.userId,
        widget.nickname,
      );
      final records = await widget.api.getRecords(widget.userId);
      final shopItems = await widget.api.getFlexItems();
      if (!mounted) return;
      setState(() {
        _stats = stats;
        _ownedItems = owned;
        _rankings = rankings;
        _records = records;
        _shopItems = shopItems;
      });
    } catch (_) {
      if (mounted) setState(() => _error = '데이터를 불러오지 못했어요.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _compare(String menuName, int eatingOutPrice) async {
    setState(() {
      _comparing = true;
      _error = null;
    });
    try {
      final result = await widget.api.compare(
        menuName: menuName,
        eatingOutPrice: eatingOutPrice,
      );
      if (!mounted) return;
      final decision = await Navigator.of(context).push<DecisionResponse>(
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            api: widget.api,
            userId: widget.userId,
            nickname: widget.nickname,
            result: result,
          ),
        ),
      );
      if (decision != null) {
        setState(() {
          _stats = decision.userStats;
          _records = [
            decision.record,
            ..._records.where((record) => record.id != decision.record.id),
          ];
        });
      }
      await _load();
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) setState(() => _error = '비교 결과를 불러오지 못했어요.');
    } finally {
      if (mounted) setState(() => _comparing = false);
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
        _ownedItems = owned;
        _message = '${response.purchasedItem.name} 아이템을 보유했어요.';
      });
    } on ApiException catch (error) {
      if (mounted) setState(() => _message = error.message);
    } finally {
      if (mounted) setState(() => _busyItemId = null);
    }
  }

  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('현재 닉네임 세션을 종료할까요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );
    if (shouldLogout != true) return;
    await widget.onLogout();
  }

  @override
  Widget build(BuildContext context) {
    final stats =
        _stats ??
        UserStats(
          userId: widget.userId,
          nickname: widget.nickname,
          totalSavedAmount: 0,
          totalRewardPoint: 0,
          virtualBalance: 0,
          ownedItemCount: 0,
          recordCount: 0,
        );
    final page = switch (_selectedIndex) {
      0 => _HomeTab(
        stats: stats,
        rankings: _rankings,
        userId: widget.userId,
        nickname: widget.nickname,
        onOpenRanking: () => setState(() => _selectedIndex = 4),
        onOpenRoom: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RoomScreen(
              stats: stats,
              ownedItems: _ownedItems,
              shopItems: _shopItems,
            ),
          ),
        ),
      ),
      1 => _RecordsTab(records: _records, stats: stats),
      2 => _CompareTab(loading: _comparing, error: _error, onSubmit: _compare),
      3 => _ShopTab(
        stats: stats,
        items: _shopItems,
        ownedItems: _ownedItems,
        busyItemId: _busyItemId,
        message: _message,
        onBuy: _buy,
      ),
      _ => _RankingTab(
        rankings: _rankings,
        currentUserId: widget.userId,
        stats: stats,
      ),
    };

    return Scaffold(
      bottomNavigationBar: AppBottomNavigation(
        selectedIndex: _selectedIndex,
        onTap: (index) => setState(() {
          _selectedIndex = index;
          _error = null;
        }),
      ),
      body: AppBackground(
        child: SafeArea(
          bottom: false,
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : KeyedSubtree(key: ValueKey<int>(_selectedIndex), child: page),
        ),
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.small(
              heroTag: 'logout',
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primaryGreen,
              onPressed: _logout,
              child: const Icon(Icons.logout_rounded),
            )
          : null,
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab({
    required this.stats,
    required this.rankings,
    required this.userId,
    required this.nickname,
    required this.onOpenRanking,
    required this.onOpenRoom,
  });

  final UserStats stats;
  final List<RankingUser> rankings;
  final String userId;
  final String nickname;
  final VoidCallback onOpenRanking;
  final VoidCallback onOpenRoom;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
      children: [
        const HeaderBar(),
        const SizedBox(height: 18),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _BalanceCard(stats: stats)),
            const SizedBox(width: 14),
            Expanded(
              child: InkWell(
                onTap: onOpenRoom,
                borderRadius: BorderRadius.circular(28),
                child: _PoriStatusCard(nickname: nickname),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        _WeeklyRankingPreview(
          rankings: rankings,
          currentUserId: userId,
          onOpenRanking: onOpenRanking,
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.stats});

  final UserStats stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 390,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(radius: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    color: AppColors.primaryGreen,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '계좌 잔고',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.darkGreen,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right, color: AppColors.primaryGreen),
                ],
              ),
              const SizedBox(height: 28),
              const Text(
                '현재 포인트',
                style: TextStyle(
                  color: AppColors.nearBlack,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              FittedBox(
                alignment: Alignment.centerLeft,
                child: Text(
                  formatPoint(stats.totalRewardPoint),
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              const Divider(color: Color(0xFFE9ECE5)),
              const SizedBox(height: 14),
              const Text(
                '절약한 금액',
                style: TextStyle(
                  color: AppColors.nearBlack,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              FittedBox(
                alignment: Alignment.centerLeft,
                child: Text(
                  formatKrw(stats.totalSavedAmount),
                  maxLines: 1,
                  style: const TextStyle(
                    color: AppColors.positive,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PoriStatusCard extends StatelessWidget {
  const _PoriStatusCard({required this.nickname});

  final String nickname;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 390,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEAF6C8), Color(0xFFD9EDC8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFCFE7BF)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  nickname,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const Icon(Icons.edit, color: AppColors.primaryGreen, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .86),
              borderRadius: BorderRadius.circular(26),
            ),
            child: const Column(
              children: [
                Text(
                  '기분 최고!',
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  '오늘도 멋진 하루야 포리!',
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const PoriMascotPlaceholder(size: 178),
        ],
      ),
    );
  }
}

class _WeeklyRankingPreview extends StatelessWidget {
  const _WeeklyRankingPreview({
    required this.rankings,
    required this.currentUserId,
    required this.onOpenRanking,
  });

  final List<RankingUser> rankings;
  final String currentUserId;
  final VoidCallback onOpenRanking;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(radius: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🏆', style: TextStyle(fontSize: 23)),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  '주간 랭킹',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                ),
              ),
              TextButton(
                onPressed: onOpenRanking,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('전체 랭킹 보기'),
                    Icon(Icons.chevron_right, size: 18),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TopThreePodium(rankings: rankings, currentUserId: currentUserId),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE8E1D4)),
            ),
            child: const Row(
              children: [
                Icon(Icons.eco_rounded, color: AppColors.primaryGreen),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '이번 주 목표를 달성하고 랭킹을 올려보세요!',
                    style: TextStyle(
                      color: AppColors.darkGreen,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: AppColors.warmDark),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecordsTab extends StatelessWidget {
  const _RecordsTab({required this.records, required this.stats});

  final List<ConsumptionRecord> records;
  final UserStats stats;

  @override
  Widget build(BuildContext context) {
    final today = records
        .where(
          (record) =>
              record.choice == 'cook' &&
              _sameDay(record.createdAt, DateTime.now()),
        )
        .fold<int>(0, (sum, record) => sum + record.savingAmount);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
      children: [
        const HeaderBar(),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.pastelGreen.withValues(alpha: .62),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFCFE7BF)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '오늘 절약 금액',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatKrw(today),
                      style: const TextStyle(
                        color: AppColors.positive,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Divider(color: Color(0xFFD9E7C8)),
                    const SizedBox(height: 14),
                    const Text(
                      '누적 절약 금액',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formatKrw(stats.totalSavedAmount),
                      style: const TextStyle(
                        color: AppColors.positive,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: AssetOrPlaceholder(
                  assetPath: 'assets/room/room_charcter.png',
                  height: 142,
                  fit: BoxFit.contain,
                  icon: Icons.eco_rounded,
                  background: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        if (records.isEmpty)
          _EmptyState(
            title: '아직 기록이 없어요',
            message: '비교 툴에서 첫 결정을 저장해보세요.',
            icon: Icons.assignment_rounded,
          )
        else
          ...records.map((record) => RecordCard(record: record)),
      ],
    );
  }
}

class _CompareTab extends StatefulWidget {
  const _CompareTab({
    required this.loading,
    required this.error,
    required this.onSubmit,
  });

  final bool loading;
  final String? error;
  final Future<void> Function(String menuName, int eatingOutPrice) onSubmit;

  @override
  State<_CompareTab> createState() => _CompareTabState();
}

class _CompareTabState extends State<_CompareTab> {
  final _menuController = TextEditingController();
  final _priceController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _menuController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final menu = _menuController.text.trim();
    final price = int.tryParse(
      _priceController.text.replaceAll(',', '').trim(),
    );
    if (menu.isEmpty || price == null || price <= 0) {
      setState(() => _error = '메뉴 이름과 외식 가격을 입력해 주세요.');
      return;
    }
    setState(() => _error = null);
    await widget.onSubmit(menu, price);
  }

  @override
  Widget build(BuildContext context) {
    final error = _error ?? widget.error;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
      children: [
        const HeaderBar(),
        const SizedBox(height: 24),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '비교 도구',
              style: TextStyle(fontSize: 38, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 8),
            Text(
              '식비 절약의 시작!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 8),
            Text(
              '메뉴와 가격을 입력하고 포리와 비교해보세요.',
              style: TextStyle(
                color: AppColors.nearBlack,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 22, 16, 16),
          decoration: _cardDecoration(radius: 22),
          child: Column(
            children: [
              CompareInputCard(
                title: '메뉴 이름',
                icon: Icons.sell_rounded,
                child: TextField(
                  controller: _menuController,
                  decoration: const InputDecoration(
                    hintText: '예시) 불고기 덮밥, 아메리카노',
                  ),
                ),
              ),
              const SizedBox(height: 14),
              CompareInputCard(
                title: '외식 가격',
                icon: Icons.paid_rounded,
                child: TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    hintText: '예시) 9,000',
                    suffixText: '원',
                  ),
                ),
              ),
              if (error != null) ...[
                const SizedBox(height: 12),
                Text(
                  error,
                  style: const TextStyle(
                    color: AppColors.danger,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: widget.loading ? null : _submit,
                  child: widget.loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('비교하기  🍃'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ShopTab extends StatefulWidget {
  const _ShopTab({
    required this.stats,
    required this.items,
    required this.ownedItems,
    required this.busyItemId,
    required this.message,
    required this.onBuy,
  });

  final UserStats stats;
  final List<FlexItem> items;
  final List<PurchasedItem> ownedItems;
  final String? busyItemId;
  final String? message;
  final Future<void> Function(FlexItem item) onBuy;

  @override
  State<_ShopTab> createState() => _ShopTabState();
}

class _ShopTabState extends State<_ShopTab> {
  int _categoryIndex = 0;

  static const _categories = [
    ('모자', Icons.checkroom_rounded),
    ('악세서리', Icons.diamond_rounded),
    ('자동차', Icons.directions_car_rounded),
    ('인테리어', Icons.chair_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final sourceItems = widget.items.isEmpty ? _mockShopItems : widget.items;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
      children: [
        HeaderBar(points: widget.stats.totalRewardPoint),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.store_rounded, color: AppColors.primaryGreen),
                      SizedBox(width: 8),
                      Text(
                        '플렉스 샵',
                        style: TextStyle(
                          color: AppColors.darkGreen,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    '포리와 함께 포인트로\n특별한 아이템을 만나보세요!',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const AssetOrPlaceholder(
              assetPath: 'assets/items/shop_final1.png',
              width: 154,
              height: 130,
              fit: BoxFit.cover,
              icon: Icons.store_rounded,
              background: AppColors.cream,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12333333),
                blurRadius: 18,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(
                height: 52,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final selected = index == _categoryIndex;
                    return ChoiceChip(
                      selected: selected,
                      onSelected: (_) => setState(() => _categoryIndex = index),
                      avatar: Icon(
                        _categories[index].$2,
                        size: 20,
                        color: selected ? Colors.white : AppColors.warmDark,
                      ),
                      label: Text(_categories[index].$1),
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : AppColors.warmDark,
                        fontWeight: FontWeight.w900,
                      ),
                      selectedColor: AppColors.primaryGreen,
                      backgroundColor: AppColors.cream,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    );
                  },
                ),
              ),
              if (widget.message != null) ...[
                const SizedBox(height: 10),
                Text(
                  widget.message!,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ],
              const SizedBox(height: 14),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sourceItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: .68,
                ),
                itemBuilder: (context, index) {
                  final item = sourceItems[index];
                  final owned = widget.ownedItems.any(
                    (ownedItem) => ownedItem.id == item.id,
                  );
                  return FlexItemCard(
                    item: item,
                    owned: owned,
                    canBuy: widget.stats.totalRewardPoint >= item.price,
                    loading: widget.busyItemId == item.id,
                    onBuy: () => widget.onBuy(item),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RankingTab extends StatelessWidget {
  const _RankingTab({
    required this.rankings,
    required this.currentUserId,
    required this.stats,
  });

  final List<RankingUser> rankings;
  final String currentUserId;
  final UserStats stats;

  @override
  Widget build(BuildContext context) {
    final myRank = rankings
        .where((user) => user.userId == currentUserId)
        .cast<RankingUser?>()
        .firstOrNull;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
      children: [
        const HeaderBar(),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: _cardDecoration(radius: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('🏆', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      '주간 랭킹',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.cream,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Text(
                      '전체 랭킹 보기',
                      style: TextStyle(
                        color: AppColors.darkGreen,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              TopThreePodium(rankings: rankings, currentUserId: currentUserId),
              const SizedBox(height: 20),
              for (final user in rankings.skip(3))
                RankingTile(
                  user: user,
                  isCurrentUser: user.userId == currentUserId,
                ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.pastelGreen.withValues(alpha: .42),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFCFE7BF)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '나의 랭킹 🌱',
                            style: TextStyle(
                              color: AppColors.darkGreen,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '현재 나의 순위와 절약 금액을 확인해보세요!',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            formatKrw(stats.totalSavedAmount),
                            style: const TextStyle(
                              color: AppColors.positive,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        '${myRank?.rank ?? '-'}위',
                        style: const TextStyle(
                          color: AppColors.darkGreen,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const PoriMascotPlaceholder(size: 72),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: _cardDecoration(radius: 22),
          child: const Row(
            children: [
              AssetOrPlaceholder(
                assetPath: 'assets/room/room_charcter.png',
                width: 70,
                height: 70,
                icon: Icons.local_florist_rounded,
              ),
              SizedBox(width: 14),
              Expanded(
                child: Text(
                  '작은 절약이 모여 큰 변화를 만들어요!\n오늘도 멋진 절약 습관, 최고예요! 🌱',
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.title,
    required this.message,
    required this.icon,
  });

  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(radius: 22),
      child: Column(
        children: [
          Icon(icon, size: 42, color: AppColors.primaryGreen),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.warmDark,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _cardDecoration({required double radius}) {
  return BoxDecoration(
    color: Colors.white.withValues(alpha: .94),
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: const Color(0xFFE7E9E2)),
    boxShadow: const [
      BoxShadow(color: Color(0x10333333), blurRadius: 18, offset: Offset(0, 8)),
    ],
  );
}

bool _sameDay(DateTime a, DateTime b) {
  final localA = a.toLocal();
  final localB = b.toLocal();
  return localA.year == localB.year &&
      localA.month == localB.month &&
      localA.day == localB.day;
}

const _mockShopItems = [
  FlexItem(
    id: 'leaf_cap',
    name: '포리의 잎사귀 캡',
    price: 150000,
    emoji: '',
    category: 'hat',
    description: '절약 고수를 위한 초록 캡.',
  ),
  FlexItem(
    id: 'ribbon_hat',
    name: '초록 리본 밀짚모자',
    price: 90000,
    emoji: '',
    category: 'hat',
    description: '포리 방에 어울리는 리본 모자.',
  ),
  FlexItem(
    id: 'green_beanie',
    name: '새싹 비니',
    price: 45000,
    emoji: '',
    category: 'hat',
    description: '따뜻한 절약 습관 아이템.',
  ),
  FlexItem(
    id: 'leaf_band',
    name: '나뭇잎 머리띠',
    price: 22500,
    emoji: '',
    category: 'accessory',
    description: '포리의 귀여움을 올려줘요.',
  ),
  FlexItem(
    id: 'basic_cap',
    name: '플렉스 기본 캡',
    price: 10000,
    emoji: '',
    category: 'hat',
    description: '처음 사기 좋은 기본 아이템.',
  ),
  FlexItem(
    id: 'secret_hat',
    name: '비밀 아이템',
    price: 500000,
    emoji: '',
    category: 'secret',
    description: '특별 조건을 달성하면 열려요.',
  ),
];
