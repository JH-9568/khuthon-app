import 'package:flutter/material.dart';

import '../models/flex_item.dart';
import '../models/user.dart';
import '../theme/app_theme.dart';
import '../widgets/app_background.dart';
import '../widgets/flex_design_widgets.dart';

class RoomScreen extends StatelessWidget {
  const RoomScreen({
    super.key,
    required this.stats,
    required this.ownedItems,
    required this.shopItems,
  });

  final UserStats stats;
  final List<PurchasedItem> ownedItems;
  final List<FlexItem> shopItems;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              HeaderBar(
                showBack: true,
                onBack: () => Navigator.of(context).maybePop(),
              ),
              const SizedBox(height: 10),
              _RoomStage(level: _level(stats)),
              const SizedBox(height: 16),
              const _Shelf(
                title: '악세서리',
                icon: Icons.diamond_rounded,
                assets: _accessoryAssets,
              ),
              const SizedBox(height: 14),
              const _Shelf(
                title: '가구',
                icon: Icons.chair_rounded,
                assets: _furnitureAssets,
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(
                    child: _RoomAction(
                      assetPath: 'assets/room/room_옷장.png',
                      icon: Icons.checkroom,
                      label: '옷장',
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: _RoomAction(
                      assetPath: 'assets/room/room_가구5.png',
                      icon: Icons.garage_rounded,
                      label: '차고',
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

  static int _level(UserStats stats) {
    final point = stats.totalSavedAmount * 5;
    if (point >= 900000) return 10;
    if (point >= 600000) return 8;
    if (point >= 300000) return 5;
    return 1;
  }
}

class _RoomStage extends StatelessWidget {
  const _RoomStage({required this.level});

  final int level;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = (width * 1.28).clamp(430.0, 500.0);
        final characterHeight = (height * .58).clamp(250.0, 310.0);

        return Container(
          height: height,
          decoration: BoxDecoration(
            color: AppColors.pastelGreen,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFFCFE7BF)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12333333),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              const Positioned.fill(
                child: AssetOrPlaceholder(
                  assetPath: 'assets/room/room_background.png',
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.zero,
                  icon: Icons.weekend_rounded,
                  background: AppColors.pastelGreen,
                ),
              ),
              Positioned(
                left: width * .11,
                right: width * .19,
                bottom: height * .03,
                child: AssetOrPlaceholder(
                  assetPath: 'assets/room/room_charcter.png',
                  height: characterHeight,
                  fit: BoxFit.contain,
                  borderRadius: BorderRadius.zero,
                  icon: Icons.eco_rounded,
                  background: Colors.transparent,
                ),
              ),
              Positioned(
                top: 18,
                left: 48,
                right: 48,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .9),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.white),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x16333333),
                        blurRadius: 16,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '기분 최고!',
                        style: TextStyle(
                          color: AppColors.darkGreen,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        '오늘도 절약 성공!',
                        style: TextStyle(
                          color: AppColors.nearBlack,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 16,
                bottom: 18,
                child: _RoomPill(
                  icon: Icons.favorite,
                  text: '레벨',
                  value: level.toString(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RoomPill extends StatelessWidget {
  const _RoomPill({required this.icon, required this.text, this.value});

  final IconData icon;
  final String text;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12333333),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primaryGreen, size: 22),
          const SizedBox(width: 8),
          Text(
            value == null ? text : 'Lv.$value',
            style: const TextStyle(
              color: AppColors.darkGreen,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _Shelf extends StatelessWidget {
  const _Shelf({required this.title, required this.icon, required this.assets});

  final String title;
  final IconData icon;
  final List<_RoomAsset> assets;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE4E7DE)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A333333),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryGreen),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const Text(
                '전체 보기',
                style: TextStyle(
                  color: AppColors.darkGreen,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.darkGreen),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 92,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: assets.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final asset = assets[index];
                return Container(
                  width: 82,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFEAEDE5)),
                  ),
                  child: AssetOrPlaceholder(
                    assetPath: asset.path,
                    icon: asset.icon,
                    background: AppColors.cream,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RoomAction extends StatelessWidget {
  const _RoomAction({
    required this.assetPath,
    required this.icon,
    required this.label,
  });

  final String assetPath;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFCFE7BF)),
      ),
      clipBehavior: Clip.antiAlias,
      child: AssetOrPlaceholder(
        assetPath: assetPath,
        fit: BoxFit.cover,
        borderRadius: BorderRadius.zero,
        icon: icon,
        background: AppColors.pastelGreen,
      ),
    );
  }
}

class _RoomAsset {
  const _RoomAsset(this.path, this.icon);

  final String path;
  final IconData icon;
}

const _accessoryAssets = [
  _RoomAsset('assets/room/room_악세사리1.png', Icons.eco_rounded),
  _RoomAsset('assets/room/room_악세사리2.png', Icons.celebration_rounded),
  _RoomAsset('assets/room/room_악세사리3.png', Icons.checkroom_rounded),
  _RoomAsset('assets/room/room_악세사리4.png', Icons.sports_baseball_rounded),
  _RoomAsset('assets/room/room_악세사리5.png', Icons.local_florist_rounded),
];

const _furnitureAssets = [
  _RoomAsset('assets/room/room_가구1.png', Icons.weekend_rounded),
  _RoomAsset('assets/room/room_가구2.png', Icons.local_florist_rounded),
  _RoomAsset('assets/room/room_가구3.png', Icons.light_rounded),
  _RoomAsset('assets/room/room_가구4.png', Icons.table_bar_rounded),
];
