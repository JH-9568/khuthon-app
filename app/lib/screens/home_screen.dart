import 'package:flutter/material.dart';

import '../models/flex_item.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_background.dart';
import '../widgets/character_status.dart';
import '../widgets/compare_form.dart';
import '../widgets/ranking_card.dart';
import '../widgets/virtual_account_card.dart';
import 'flex_shop_screen.dart';
import 'records_screen.dart';
import 'result_screen.dart';

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
  List<PurchasedItem> _items = [];
  List<RankingUser> _rankings = [];
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
      final rankings = await widget.api.getRankings(
        widget.userId,
        widget.nickname,
      );
      if (!mounted) return;
      setState(() {
        _stats = stats;
        _items = items;
        _rankings = rankings;
      });
    } catch (_) {
      setState(() => _error = '상태를 불러오지 못했어요.');
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
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) setState(() => _error = '비교 결과를 불러오지 못했어요.');
    } finally {
      if (mounted) setState(() => _comparing = false);
    }
  }

  Future<void> _open(Widget screen) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
    await _load();
  }

  Future<void> _openCompareDialog() async {
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: '비교 닫기',
      barrierColor: AppColors.nearBlack.withValues(alpha: .42),
      transitionDuration: const Duration(milliseconds: 230),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (dialogContext, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeInCubic,
        );
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 18,
              right: 18,
              bottom: MediaQuery.of(dialogContext).viewInsets.bottom,
            ),
            child: Center(
              child: FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: .86, end: 1).animate(curved),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 430),
                    child: Material(
                      color: Colors.transparent,
                      child: CompareForm(
                        loading: _comparing,
                        compact: true,
                        onSubmit: (menuName, eatingOutPrice) async {
                          Navigator.of(dialogContext).pop();
                          await _compare(menuName, eatingOutPrice);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flex'),
        actions: [
          IconButton(
            tooltip: '로그아웃',
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      bottomNavigationBar: _HomeActionBar(
        onRecords: () =>
            _open(RecordsScreen(api: widget.api, userId: widget.userId)),
        onCompare: _openCompareDialog,
        onShop: _stats == null
            ? null
            : () => _open(
                FlexShopScreen(
                  api: widget.api,
                  userId: widget.userId,
                  nickname: widget.nickname,
                  initialStats: _stats!,
                ),
              ),
      ),
      body: AppBackground(
        child: SafeArea(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 112),
                    children: [
                      Text(
                        '${widget.nickname}님, 안녕하세요',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '진짜 플렉스하기 전에, 집밥으로 얼마나 아낄 수 있는지 먼저 확인해요.',
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
                      _RankingPreview(
                        rankings: _rankings,
                        currentUserId: widget.userId,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class _RankingPreview extends StatelessWidget {
  const _RankingPreview({required this.rankings, required this.currentUserId});

  final List<RankingUser> rankings;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    if (rankings.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0x1F0E0F0C)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '절약 랭킹',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightMint,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'TOP 3',
                  style: TextStyle(
                    color: AppColors.positive,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...rankings
              .take(3)
              .map(
                (user) => RankingCard(
                  user: user,
                  isCurrentUser: user.userId == currentUserId,
                ),
              ),
        ],
      ),
    );
  }
}

class _HomeActionBar extends StatelessWidget {
  const _HomeActionBar({
    required this.onRecords,
    required this.onCompare,
    required this.onShop,
  });

  final VoidCallback onRecords;
  final VoidCallback onCompare;
  final VoidCallback? onShop;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(18, 0, 18, 14),
      child: Container(
        height: 78,
        decoration: BoxDecoration(
          color: AppColors.nearBlack,
          borderRadius: BorderRadius.circular(34),
          boxShadow: [
            BoxShadow(
              color: AppColors.nearBlack.withValues(alpha: .24),
              blurRadius: 28,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: _BarButton(
                    label: '기록',
                    icon: Icons.receipt_long,
                    onTap: onRecords,
                  ),
                ),
                const SizedBox(width: 92),
                Expanded(
                  child: _BarButton(
                    label: '플렉스샵',
                    icon: Icons.shopping_bag,
                    onTap: onShop,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: onCompare,
              child: Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    center: Alignment(-.35, -.45),
                    colors: [Colors.white, AppColors.wiseGreen],
                  ),
                  border: Border.all(color: AppColors.nearBlack, width: 5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.wiseGreen.withValues(alpha: .35),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.restaurant_menu,
                  color: AppColors.darkGreen,
                  size: 32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarButton extends StatelessWidget {
  const _BarButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
