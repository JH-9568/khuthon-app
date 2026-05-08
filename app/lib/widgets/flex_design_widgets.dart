import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/compare_result.dart';
import '../models/consumption_record.dart';
import '../models/flex_item.dart';
import '../models/user.dart';
import '../theme/app_theme.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 54});

  final double size;

  @override
  Widget build(BuildContext context) {
    return AssetOrPlaceholder(
      assetPath: 'assets/items/logo_flex.png',
      width: size * 1.75,
      height: size,
      fit: BoxFit.contain,
      icon: Icons.eco_rounded,
      background: Colors.transparent,
      borderRadius: BorderRadius.zero,
    );
  }
}

class AppAssetIcon extends StatelessWidget {
  const AppAssetIcon({
    super.key,
    required this.assetPath,
    required this.icon,
    this.size = 26,
  });

  final String assetPath;
  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return AssetOrPlaceholder(
      assetPath: assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      icon: icon,
      background: Colors.transparent,
      borderRadius: BorderRadius.zero,
    );
  }
}

class HeaderBar extends StatelessWidget {
  const HeaderBar({
    super.key,
    this.showBack = false,
    this.title,
    this.points,
    this.onBack,
    this.onBell,
  });

  final bool showBack;
  final String? title;
  final int? points;
  final VoidCallback? onBack;
  final VoidCallback? onBell;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 360;
        final logoSize = showBack
            ? (compact ? 38.0 : 46.0)
            : (compact ? 46.0 : 54.0);
        final pillText = compact ? '1일' : '1일 연속';
        final buttonSize = compact ? 44.0 : 48.0;
        final gap = compact ? 6.0 : 8.0;

        final leading = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showBack)
              _HeaderButton(
                icon: Icons.chevron_left,
                size: buttonSize,
                onTap: onBack ?? () => Navigator.of(context).maybePop(),
              )
            else
              AppLogo(size: logoSize),
            if (showBack) ...[SizedBox(width: gap), AppLogo(size: logoSize)],
          ],
        );

        final trailing = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _InfoPill(
              icon: Icons.local_fire_department,
              assetPath: 'assets/items/icon_fire.png',
              text: pillText,
              compact: compact,
            ),
            SizedBox(width: gap),
            _HeaderButton(
              icon: Icons.notifications_none_rounded,
              assetPath: 'assets/items/icon_bell.png',
              size: buttonSize,
              onTap: onBell,
              showDot: true,
            ),
          ],
        );

        return Padding(
          padding: EdgeInsets.fromLTRB(
            compact ? 12 : 16,
            10,
            compact ? 12 : 16,
            10,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  leading,
                  if (title != null) ...[
                    SizedBox(width: gap),
                    Expanded(
                      child: Text(
                        title!,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.darkGreen,
                          fontSize: compact ? 18 : 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    SizedBox(width: gap),
                  ] else
                    const Spacer(),
                  trailing,
                ],
              ),
              if (points != null) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: _InfoPill(
                    icon: Icons.monetization_on,
                    text: formatPoint(points!).replaceAll('P', ''),
                    gold: true,
                    compact: compact,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.icon,
    required this.text,
    this.assetPath,
    this.gold = false,
    this.compact = false,
  });

  final IconData icon;
  final String text;
  final String? assetPath;
  final bool gold;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: EdgeInsets.symmetric(horizontal: compact ? 9 : 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFDDE8D5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F333333),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          assetPath == null
              ? Icon(
                  icon,
                  color: gold ? AppColors.warning : Colors.orange,
                  size: compact ? 19 : 22,
                )
              : AppAssetIcon(
                  assetPath: assetPath!,
                  icon: icon,
                  size: compact ? 20 : 23,
                ),
          SizedBox(width: compact ? 4 : 6),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.darkGreen,
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({
    required this.icon,
    this.assetPath,
    this.onTap,
    this.showDot = false,
    this.size = 48,
  });

  final IconData icon;
  final String? assetPath;
  final VoidCallback? onTap;
  final bool showDot;
  final double size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .84),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFDDE8D5)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0F333333),
                  blurRadius: 14,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: assetPath == null
                  ? Icon(icon, color: AppColors.darkGreen, size: size * .58)
                  : AppAssetIcon(
                      assetPath: assetPath!,
                      icon: icon,
                      size: size * .62,
                    ),
            ),
          ),
          if (showDot)
            Positioned(
              right: 6,
              top: 2,
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;

  static const items = [
    (Icons.home_rounded, '홈', 'assets/items/tab_home.png'),
    (Icons.assignment_rounded, '기록', 'assets/items/tab_record.png'),
    (Icons.calculate_rounded, '비교 툴', 'assets/items/tab_compare.png'),
    (Icons.shopping_bag_outlined, '플렉스 샵', 'assets/items/tab_shop.png'),
    (Icons.emoji_events_outlined, '랭킹', 'assets/items/tab_ranking.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        boxShadow: [
          BoxShadow(
            color: Color(0x12333333),
            blurRadius: 20,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 78,
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: InkWell(
                    onTap: () => onTap(i),
                    child: _NavItem(
                      icon: items[i].$1,
                      label: items[i].$2,
                      assetPath: items[i].$3,
                      selected: i == selectedIndex,
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

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.assetPath,
    required this.selected,
  });

  final IconData icon;
  final String label;
  final String assetPath;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primaryGreen : AppColors.mutedGray;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          child: AppAssetIcon(assetPath: assetPath, icon: icon, size: 29),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class AssetOrPlaceholder extends StatelessWidget {
  const AssetOrPlaceholder({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.borderRadius,
    this.icon = Icons.eco_rounded,
    this.background,
  });

  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final IconData icon;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(24);
    return ClipRRect(
      borderRadius: radius,
      child: FutureBuilder<Uint8List?>(
        future: _AssetCache.load(assetPath),
        builder: (context, snapshot) {
          final bytes = snapshot.data;
          if (bytes != null) {
            return Image.memory(
              bytes,
              width: width,
              height: height,
              fit: fit,
              filterQuality: FilterQuality.high,
              gaplessPlayback: true,
            );
          }
          return _AssetPlaceholder(
            width: width,
            height: height,
            radius: radius,
            icon: icon,
            background: background,
          );
        },
      ),
    );
  }
}

class _AssetCache {
  static final Map<String, Future<Uint8List?>> _cache = {};

  static Future<Uint8List?> load(String path) {
    return _cache.putIfAbsent(path, () async {
      try {
        final data = await rootBundle.load(path);
        return data.buffer.asUint8List();
      } catch (_) {
        return null;
      }
    });
  }
}

class _AssetPlaceholder extends StatelessWidget {
  const _AssetPlaceholder({
    required this.width,
    required this.height,
    required this.radius,
    required this.icon,
    required this.background,
  });

  final double? width;
  final double? height;
  final BorderRadius radius;
  final IconData icon;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: background ?? AppColors.pastelGreen.withValues(alpha: .55),
        borderRadius: radius,
        border: Border.all(color: Colors.white.withValues(alpha: .7)),
      ),
      child: Icon(
        icon,
        color: AppColors.primaryGreen.withValues(alpha: .65),
        size: ((width ?? height ?? 96) * .34).clamp(28, 72).toDouble(),
      ),
    );
  }
}

class PoriMascotPlaceholder extends StatelessWidget {
  const PoriMascotPlaceholder({
    super.key,
    this.size = 180,
    this.happy = true,
    this.assetPath = 'assets/room/room_charcter.png',
  });

  final double size;
  final bool happy;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    final hasMascotArt =
        assetPath.startsWith('assets/items/mascot_') ||
        assetPath == 'assets/room/room_charcter.png';
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: size * .08,
            child: Container(
              width: size * .66,
              height: size * .12,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: .16),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          AssetOrPlaceholder(
            assetPath: assetPath,
            width: size,
            height: size,
            icon: Icons.eco_rounded,
            background: Colors.transparent,
          ),
          if (!hasMascotArt) ...[
            Positioned(
              top: size * .18,
              left: size * .16,
              child: _Leaf(size: size * .23, angle: -.55),
            ),
            Positioned(
              top: size * .15,
              right: size * .15,
              child: _Leaf(size: size * .24, angle: .55),
            ),
            Positioned(
              top: size * .45,
              left: size * .35,
              child: _Eye(size: size * .08),
            ),
            Positioned(
              top: size * .45,
              right: size * .35,
              child: _Eye(size: size * .08),
            ),
            Positioned(
              top: size * .56,
              child: happy
                  ? Icon(
                      Icons.sentiment_very_satisfied_rounded,
                      size: size * .16,
                      color: AppColors.darkGreen,
                    )
                  : Icon(
                      Icons.sentiment_dissatisfied_rounded,
                      size: size * .16,
                      color: AppColors.darkGreen,
                    ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Leaf extends StatelessWidget {
  const _Leaf({required this.size, required this.angle});

  final double size;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: size,
        height: size * .72,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.lightGreen, AppColors.primaryGreen],
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(999),
            bottomRight: Radius.circular(999),
            topRight: Radius.circular(420),
            bottomLeft: Radius.circular(420),
          ),
        ),
      ),
    );
  }
}

class _Eye extends StatelessWidget {
  const _Eye({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size * 1.3,
      decoration: BoxDecoration(
        color: AppColors.darkGreen,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.highlight = false,
  });

  final String label;
  final String value;
  final IconData? icon;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.pastelGreen.withValues(alpha: .5)
            : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE4E7DE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: AppColors.primaryGreen, size: 20),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.warmDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                color: highlight ? AppColors.positive : AppColors.nearBlack,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RankingTile extends StatelessWidget {
  const RankingTile({
    super.key,
    required this.user,
    required this.isCurrentUser,
  });

  final RankingUser user;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? AppColors.pastelGreen.withValues(alpha: .45)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE7E9E2)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 34,
            child: Text(
              '${user.rank}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.positive,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.pastelGreen,
            child: Text(
              user.nickname.characters.first,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              user.nickname,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
          ),
          Text(
            formatKrw(user.totalSavedAmount),
            style: const TextStyle(
              color: AppColors.positive,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class TopThreePodium extends StatelessWidget {
  const TopThreePodium({
    super.key,
    required this.rankings,
    required this.currentUserId,
  });

  final List<RankingUser> rankings;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    final top = rankings.take(3).toList();
    if (top.isEmpty) return const SizedBox.shrink();
    RankingUser? byRank(int rank) {
      for (final user in top) {
        if (user.rank == rank) return user;
      }
      return top.length >= rank ? top[rank - 1] : null;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: _PodiumUser(user: byRank(2), height: 116, medal: '2'),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _PodiumUser(user: byRank(1), height: 154, medal: '1'),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _PodiumUser(user: byRank(3), height: 104, medal: '3'),
        ),
      ],
    );
  }
}

class _PodiumUser extends StatelessWidget {
  const _PodiumUser({
    required this.user,
    required this.height,
    required this.medal,
  });

  final RankingUser? user;
  final double height;
  final String medal;

  @override
  Widget build(BuildContext context) {
    final colors = medal == '1'
        ? const [Color(0xFFFFF8D7), Color(0xFFFFE78B)]
        : medal == '2'
        ? const [Color(0xFFEFF8FA), Color(0xFFDDF1F5)]
        : const [Color(0xFFFFF0E8), Color(0xFFFFD9C9)];
    return Column(
      children: [
        Text(
          medal == '1'
              ? '👑'
              : medal == '2'
              ? '🥈'
              : '🥉',
          style: const TextStyle(fontSize: 26),
        ),
        Container(
          width: medal == '1' ? 92 : 78,
          height: medal == '1' ? 92 : 78,
          padding: EdgeInsets.all(medal == '1' ? 6 : 5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: colors.last, width: 3),
            boxShadow: [
              BoxShadow(
                color: colors.last.withValues(alpha: .34),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipOval(
            child: AssetOrPlaceholder(
              assetPath: _podiumAssetPath(medal),
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(999),
              icon: Icons.emoji_events_rounded,
              background: colors.first,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: height,
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                user?.nickname ?? '-',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              FittedBox(
                child: Text(
                  user == null ? '0원' : formatKrw(user!.totalSavedAmount),
                  style: const TextStyle(
                    color: AppColors.positive,
                    fontWeight: FontWeight.w900,
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

String _podiumAssetPath(String medal) {
  return switch (medal) {
    '1' => 'assets/items/홈화면_랭킹1등.png',
    '2' => 'assets/items/홈화면_랭킹2등.png',
    _ => 'assets/items/홈화면_랭킹3등.png',
  };
}

class RecordCard extends StatelessWidget {
  const RecordCard({super.key, required this.record});

  final ConsumptionRecord record;

  @override
  Widget build(BuildContext context) {
    final cooked = record.choice == 'cook';
    final amount = cooked ? record.savingAmount : -record.eatingOutPrice;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE9ECE5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A333333),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          AssetOrPlaceholder(
            assetPath: cooked
                ? 'assets/room/room_charcter.png'
                : foodAssetPath(record.menuName),
            width: 58,
            height: 58,
            icon: cooked ? Icons.eco_rounded : Icons.restaurant_rounded,
            background: cooked
                ? AppColors.pastelGreen
                : const Color(0xFFFFEFE8),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        record.menuName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _ChoiceBadge(cooked: cooked),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  _formatDate(record.createdAt),
                  style: const TextStyle(
                    color: AppColors.warmDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  '외식가 ${formatKrw(record.eatingOutPrice)}  >  집밥가 ${formatKrw(record.homeCookingCost)}',
                  style: const TextStyle(
                    color: AppColors.warmDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '${amount >= 0 ? '+' : ''}${formatKrw(amount)}',
              style: TextStyle(
                color: amount >= 0 ? AppColors.positive : Colors.red,
                fontSize: 21,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChoiceBadge extends StatelessWidget {
  const _ChoiceBadge({required this.cooked});

  final bool cooked;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: cooked ? AppColors.pastelGreen : const Color(0xFFFF7C3A),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        cooked ? '집밥' : '외식',
        style: TextStyle(
          color: cooked ? AppColors.darkGreen : Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  String two(int value) => value.toString().padLeft(2, '0');
  return '${date.year}.${two(date.month)}.${two(date.day)}  ${two(date.hour)}:${two(date.minute)}';
}

String foodAssetPath(String menuName) {
  final key = menuName.toLowerCase();
  if (key.contains('치킨') || key.contains('chicken')) {
    return 'assets/items/food_chicken.png';
  }
  if (key.contains('커피') ||
      key.contains('라떼') ||
      key.contains('카페') ||
      key.contains('coffee') ||
      key.contains('latte')) {
    return 'assets/items/food_cafe_latte.png';
  }
  if (key.contains('샌드') || key.contains('sandwich')) {
    return 'assets/items/food_sandwich.png';
  }
  return 'assets/items/food_chicken.png';
}

class CompareInputCard extends StatelessWidget {
  const CompareInputCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7E1D5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A333333),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryGreen, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class CompareResultCard extends StatelessWidget {
  const CompareResultCard({super.key, required this.result});

  final CompareResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE9ECE5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F333333),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: StatCard(
              label: '외식 가격',
              value: formatKrw(result.eatingOutPrice),
              icon: Icons.restaurant_menu_rounded,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: StatCard(
              label: '집밥 가격',
              value: formatKrw(result.homeCookingCost),
              icon: Icons.rice_bowl_rounded,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: StatCard(
              label: '차액',
              value: formatKrw(result.savingAmount),
              icon: Icons.savings_rounded,
              highlight: true,
            ),
          ),
        ],
      ),
    );
  }
}

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
    final rarity = _rarity(item);
    final locked = rarity == 'SECRET';
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE4E7DE)),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
            child: Column(
              children: [
                Expanded(
                  child: AssetOrPlaceholder(
                    assetPath: flexShopAssetPath(item),
                    width: double.infinity,
                    fit: BoxFit.contain,
                    icon: _itemIcon(item),
                    background: locked
                        ? const Color(0xFFE8DDC9)
                        : AppColors.cream,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  locked ? '비밀 아이템' : item.name,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  locked ? '조건 달성 시 해제' : formatPoint(item.price),
                  style: TextStyle(
                    color: locked ? AppColors.warmDark : AppColors.positive,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: ElevatedButton.icon(
                    onPressed: owned || !canBuy || loading || locked
                        ? null
                        : onBuy,
                    icon: loading
                        ? const SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            owned
                                ? Icons.check_rounded
                                : Icons.lock_open_rounded,
                            size: 17,
                          ),
                    label: Text(
                      locked
                          ? '미리보기'
                          : owned
                          ? '보유중'
                          : canBuy
                          ? '구매하기'
                          : '포인트 부족',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      backgroundColor: owned
                          ? AppColors.primaryGreen
                          : canBuy
                          ? AppColors.primaryGreen
                          : const Color(0xFFE8DDC9),
                      foregroundColor: owned || canBuy
                          ? Colors.white
                          : AppColors.warmDark,
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            top: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _rarityColor(rarity),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Text(
                rarity,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _rarity(FlexItem item) {
  if (item.price >= 150000) return 'LEGENDARY';
  if (item.price >= 90000) return 'EPIC';
  if (item.price >= 45000) return 'RARE';
  if (item.price >= 22500) return 'UNCOMMON';
  if (item.name.contains('비밀')) return 'SECRET';
  return 'COMMON';
}

Color _rarityColor(String rarity) {
  switch (rarity) {
    case 'LEGENDARY':
      return const Color(0xFFE9A414);
    case 'EPIC':
      return const Color(0xFFA363E8);
    case 'RARE':
      return const Color(0xFF55A9DC);
    case 'UNCOMMON':
      return AppColors.primaryGreen;
    case 'SECRET':
      return const Color(0xFFB39A76);
    default:
      return AppColors.gray;
  }
}

IconData _itemIcon(FlexItem item) {
  final key = '${item.name} ${item.category}'.toLowerCase();
  if (key.contains('모자') || key.contains('cap') || key.contains('hat')) {
    return Icons.checkroom_rounded;
  }
  if (key.contains('자동차') || key.contains('car') || key.contains('vehicle')) {
    return Icons.directions_car_rounded;
  }
  if (key.contains('가구') || key.contains('interior') || key.contains('real')) {
    return Icons.chair_rounded;
  }
  if (key.contains('악세') || key.contains('accessory')) {
    return Icons.diamond_rounded;
  }
  return Icons.shopping_bag_rounded;
}

String flexShopAssetPath(FlexItem item) {
  final key = '${item.id} ${item.name} ${item.category}'.toLowerCase();
  if (key.contains('leaf_cap') ||
      key.contains('basic_cap') ||
      key.contains('handbag') ||
      key.contains('핸드백')) {
    return 'assets/items/shop_final1.png';
  }
  if (key.contains('ribbon_hat') ||
      key.contains('leaf_band') ||
      key.contains('watch') ||
      key.contains('시계')) {
    return 'assets/items/shop_final2.png';
  }
  if (key.contains('green_beanie') ||
      key.contains('villa') ||
      key.contains('빌라') ||
      key.contains('penthouse') ||
      key.contains('펜트')) {
    return 'assets/items/shop_final3.png';
  }
  return 'assets/images/items/${item.id}.png';
}
