import 'package:flutter/material.dart';

import '../models/flex_item.dart';
import '../theme/app_theme.dart';
import 'flex_design_widgets.dart';

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
    final spec = _ItemSpec.fromItem(item);
    final disabled = owned || !canBuy || loading;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0x1F0E0F0C)),
        boxShadow: [
          BoxShadow(
            color: spec.shadow.withValues(alpha: .14),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: _PremiumPreview(spec: spec, owned: owned),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _CategoryChip(spec: spec),
                    const Spacer(),
                    Text(
                      formatPoint(item.price),
                      style: const TextStyle(
                        color: AppColors.nearBlack,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  item.name,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 6),
                Text(
                  item.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: disabled ? null : onBuy,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: owned
                          ? AppColors.nearBlack
                          : canBuy
                          ? AppColors.wiseGreen
                          : AppColors.lightSurface.withValues(alpha: .72),
                      foregroundColor: owned
                          ? AppColors.wiseGreen
                          : canBuy
                          ? AppColors.darkGreen
                          : AppColors.warmDark,
                      disabledBackgroundColor: owned
                          ? AppColors.nearBlack.withValues(alpha: .8)
                          : AppColors.lightSurface.withValues(alpha: .68),
                      disabledForegroundColor: owned
                          ? AppColors.wiseGreen.withValues(alpha: .9)
                          : AppColors.warmDark.withValues(alpha: .72),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(owned ? '보유중' : (canBuy ? '구매하기' : '포인트 부족')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumPreview extends StatelessWidget {
  const _PremiumPreview({required this.spec, required this.owned});

  final _ItemSpec spec;
  final bool owned;

  @override
  Widget build(BuildContext context) {
    final assetPath = spec.assetPath;
    return AspectRatio(
      aspectRatio: 16 / 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: spec.background,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -28,
                top: -36,
                child: _Glow(
                  size: 142,
                  color: Colors.white.withValues(alpha: .18),
                ),
              ),
              Positioned(
                left: -34,
                bottom: -42,
                child: _Glow(
                  size: 132,
                  color: spec.primary.withValues(alpha: .2),
                ),
              ),
              if (assetPath != null)
                Positioned.fill(
                  child: AssetOrPlaceholder(
                    assetPath: assetPath,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.zero,
                    icon: Icons.shopping_bag_rounded,
                    background: Colors.transparent,
                  ),
                )
              else
                Center(child: _RewardObject(spec: spec)),
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .72),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: .7),
                    ),
                  ),
                  child: Text(
                    spec.badge,
                    style: TextStyle(
                      color: spec.dark,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 34,
                right: 34,
                bottom: 18,
                child: Container(
                  height: 26,
                  decoration: BoxDecoration(
                    color: spec.shadow.withValues(alpha: .22),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: spec.shadow.withValues(alpha: .18),
                        blurRadius: 24,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),
              if (owned)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.nearBlack,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'OWNED',
                      style: TextStyle(
                        color: AppColors.wiseGreen,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
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

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.spec});

  final _ItemSpec spec;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: spec.primary.withValues(alpha: .18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: spec.primary.withValues(alpha: .42)),
      ),
      child: Text(
        spec.label,
        style: TextStyle(
          color: spec.dark,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _RewardObject extends StatelessWidget {
  const _RewardObject({required this.spec});

  final _ItemSpec spec;

  @override
  Widget build(BuildContext context) {
    switch (spec.kind) {
      case _ItemKind.handbag:
        return _HandbagVisual(spec: spec);
      case _ItemKind.watch:
        return _WatchVisual(spec: spec);
      case _ItemKind.car:
      case _ItemKind.superCar:
        return _CarVisual(
          spec: spec,
          superCar: spec.kind == _ItemKind.superCar,
        );
      case _ItemKind.penthouse:
      case _ItemKind.villa:
        return _BuildingVisual(spec: spec);
      case _ItemKind.suit:
        return _SuitVisual(spec: spec);
    }
  }
}

class _HandbagVisual extends StatelessWidget {
  const _HandbagVisual({required this.spec});

  final _ItemSpec spec;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      height: 132,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            top: 8,
            child: Container(
              width: 76,
              height: 58,
              decoration: BoxDecoration(
                border: Border.all(color: spec.dark, width: 10),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(48),
                  topRight: Radius.circular(48),
                ),
              ),
            ),
          ),
          Container(
            width: 132,
            height: 86,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, spec.primary, spec.dark],
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: spec.dark.withValues(alpha: .28),
                  blurRadius: 18,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _QuiltPainter(
                      color: Colors.white.withValues(alpha: .22),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 42,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        colors: [Colors.white, Color(0xFFFFD66B)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFB800).withValues(alpha: .26),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.diamond,
                      color: AppColors.darkGreen,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(top: 58, left: 42, child: _Shine(width: 42)),
        ],
      ),
    );
  }
}

class _WatchVisual extends StatelessWidget {
  const _WatchVisual({required this.spec});

  final _ItemSpec spec;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 158,
      height: 138,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(top: 0, child: _WatchBand(color: spec.dark)),
          Positioned(bottom: 0, child: _WatchBand(color: spec.dark)),
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: const Alignment(-.32, -.42),
                colors: [Colors.white, spec.primary, spec.dark],
              ),
              boxShadow: [
                BoxShadow(
                  color: spec.dark.withValues(alpha: .32),
                  blurRadius: 20,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.nearBlack.withValues(alpha: .82),
                  ),
                ),
                Icon(Icons.watch, color: spec.primary, size: 44),
                const Positioned(top: 23, left: 33, child: _Shine(width: 34)),
              ],
            ),
          ),
          Positioned(left: 8, bottom: 22, child: _Coin(color: spec.primary)),
          Positioned(right: 8, bottom: 28, child: _Coin(color: spec.primary)),
        ],
      ),
    );
  }
}

class _WatchBand extends StatelessWidget {
  const _WatchBand({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.withValues(alpha: .72), color]),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class _CarVisual extends StatelessWidget {
  const _CarVisual({required this.spec, required this.superCar});

  final _ItemSpec spec;
  final bool superCar;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 120,
      child: Stack(
        children: [
          Positioned(
            left: superCar ? 42 : 52,
            top: 20,
            child: Container(
              width: superCar ? 124 : 104,
              height: 46,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.white, spec.primary]),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(52),
                  topRight: Radius.circular(64),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
            ),
          ),
          Positioned(
            left: 18,
            top: 52,
            child: Container(
              width: 184,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, spec.primary, spec.dark],
                ),
                borderRadius: BorderRadius.circular(superCar ? 18 : 24),
                boxShadow: [
                  BoxShadow(
                    color: spec.dark.withValues(alpha: .28),
                    blurRadius: 18,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
            ),
          ),
          Positioned(left: 40, top: 82, child: _Wheel(color: spec.dark)),
          Positioned(right: 40, top: 82, child: _Wheel(color: spec.dark)),
          const Positioned(top: 57, right: 42, child: _Shine(width: 42)),
        ],
      ),
    );
  }
}

class _Wheel extends StatelessWidget {
  const _Wheel({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.nearBlack,
        border: Border.all(color: color, width: 6),
      ),
    );
  }
}

class _BuildingVisual extends StatelessWidget {
  const _BuildingVisual({required this.spec});

  final _ItemSpec spec;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 198,
      height: 130,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              width: 184,
              height: 28,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [spec.dark, spec.primary]),
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          _Tower(width: 56, height: 92, color: spec.dark, left: 24),
          _Tower(width: 72, height: 116, color: spec.primary, left: 70),
          _Tower(width: 50, height: 78, color: spec.dark, left: 132),
          Positioned(
            top: 14,
            left: 80,
            child: Container(
              width: 50,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .7),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tower extends StatelessWidget {
  const _Tower({
    required this.width,
    required this.height,
    required this.color,
    required this.left,
  });

  final double width;
  final double height;
  final Color color;
  final double left;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      bottom: 18,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.white, color]),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: .22),
              blurRadius: 16,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(9),
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(
            8,
            (_) => Container(
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .58),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SuitVisual extends StatelessWidget {
  const _SuitVisual({required this.spec});

  final _ItemSpec spec;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 138,
      height: 132,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 112,
            height: 118,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [spec.primary, spec.dark]),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(36),
                topRight: Radius.circular(36),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              boxShadow: [
                BoxShadow(
                  color: spec.dark.withValues(alpha: .28),
                  blurRadius: 18,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
          ),
          Positioned(
            top: 12,
            child: Container(
              width: 44,
              height: 66,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(22),
                  bottomRight: Radius.circular(22),
                ),
              ),
            ),
          ),
          Positioned(
            top: 42,
            child: Icon(Icons.diamond, color: spec.primary, size: 28),
          ),
          const Positioned(top: 20, left: 26, child: _Shine(width: 36)),
        ],
      ),
    );
  }
}

class _Coin extends StatelessWidget {
  const _Coin({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [Colors.white, color]),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: .2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _Shine extends StatelessWidget {
  const _Shine({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .68),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _QuiltPainter extends CustomPainter {
  const _QuiltPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;
    for (var x = -size.height; x < size.width; x += 24) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        paint,
      );
      canvas.drawLine(
        Offset(x + size.height, 0),
        Offset(x, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _QuiltPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

enum _ItemKind { handbag, watch, car, penthouse, suit, superCar, villa }

class _ItemSpec {
  const _ItemSpec({
    required this.kind,
    required this.label,
    required this.badge,
    required this.background,
    required this.primary,
    required this.dark,
    required this.shadow,
    this.assetPath,
  });

  final _ItemKind kind;
  final String label;
  final String badge;
  final List<Color> background;
  final Color primary;
  final Color dark;
  final Color shadow;
  final String? assetPath;

  factory _ItemSpec.fromItem(FlexItem item) {
    final key = '${item.name} ${item.category}'.toLowerCase();
    if (item.id == 'leaf_cap' || item.id == 'basic_cap') {
      return const _ItemSpec(
        kind: _ItemKind.handbag,
        label: 'FASHION',
        badge: 'NEW ITEM',
        background: [Color(0xFFFFF4EA), Color(0xFFE9BF8E)],
        primary: Color(0xFFC7864E),
        dark: Color(0xFF6A3F1E),
        shadow: Color(0xFFC7864E),
        assetPath: 'assets/items/shop_final1.png',
      );
    }
    if (item.id == 'ribbon_hat' || item.id == 'leaf_band') {
      return const _ItemSpec(
        kind: _ItemKind.watch,
        label: 'ACCESSORY',
        badge: 'POPULAR',
        background: [Color(0xFFFFF8DD), Color(0xFFFFDF83)],
        primary: Color(0xFFFFC94A),
        dark: Color(0xFF7A5600),
        shadow: Color(0xFFFFB800),
        assetPath: 'assets/items/shop_final2.png',
      );
    }
    if (item.id == 'green_beanie') {
      return const _ItemSpec(
        kind: _ItemKind.villa,
        label: 'ROOM',
        badge: 'FLEX',
        background: [Color(0xFFEAF7FF), Color(0xFFB7DDF3)],
        primary: Color(0xFF8AC8E8),
        dark: Color(0xFF25576E),
        shadow: Color(0xFF25576E),
        assetPath: 'assets/items/shop_final3.png',
      );
    }
    if (key.contains('handbag') || key.contains('핸드백')) {
      return const _ItemSpec(
        kind: _ItemKind.handbag,
        label: 'FASHION',
        badge: 'LUXURY BAG',
        background: [Color(0xFFFFF4EA), Color(0xFFE9BF8E)],
        primary: Color(0xFFC7864E),
        dark: Color(0xFF6A3F1E),
        shadow: Color(0xFFC7864E),
        assetPath: 'assets/items/shop_final1.png',
      );
    }
    if (key.contains('watch') || key.contains('시계')) {
      return const _ItemSpec(
        kind: _ItemKind.watch,
        label: 'TIMEPIECE',
        badge: 'PRESTIGE',
        background: [Color(0xFFFFF8DD), Color(0xFFFFDF83)],
        primary: Color(0xFFFFC94A),
        dark: Color(0xFF7A5600),
        shadow: Color(0xFFFFB800),
        assetPath: 'assets/items/shop_final2.png',
      );
    }
    if (key.contains('villa') || key.contains('빌라')) {
      return const _ItemSpec(
        kind: _ItemKind.villa,
        label: 'LIFESTYLE',
        badge: 'VILLA',
        background: [Color(0xFFEAF7FF), Color(0xFFB7DDF3)],
        primary: Color(0xFF8AC8E8),
        dark: Color(0xFF25576E),
        shadow: Color(0xFF25576E),
        assetPath: 'assets/items/shop_final3.png',
      );
    }
    if (key.contains('penthouse') || key.contains('펜트')) {
      return const _ItemSpec(
        kind: _ItemKind.penthouse,
        label: 'REAL ESTATE',
        badge: 'PENTHOUSE',
        background: [Color(0xFFEAF7FF), Color(0xFFB7DDF3)],
        primary: Color(0xFF8AC8E8),
        dark: Color(0xFF25576E),
        shadow: Color(0xFF25576E),
        assetPath: 'assets/items/shop_final3.png',
      );
    }
    if (key.contains('suit') || key.contains('수트')) {
      return const _ItemSpec(
        kind: _ItemKind.suit,
        label: 'DESIGNER',
        badge: 'TAILORED',
        background: [Color(0xFFF1F1F1), Color(0xFFC9CDD0)],
        primary: Color(0xFF3D4348),
        dark: Color(0xFF0E0F0C),
        shadow: Color(0xFF0E0F0C),
      );
    }
    if (key.contains('super') || key.contains('슈퍼')) {
      return const _ItemSpec(
        kind: _ItemKind.superCar,
        label: 'VEHICLE',
        badge: 'LIMITED',
        background: [Color(0xFFFFECE7), Color(0xFFFFA680)],
        primary: Color(0xFFFF6F3D),
        dark: Color(0xFF8F1F00),
        shadow: Color(0xFFFF6F3D),
      );
    }
    return const _ItemSpec(
      kind: _ItemKind.car,
      label: 'VEHICLE',
      badge: 'REWARD',
      background: [Color(0xFFF4FFE9), Color(0xFFB5F58A)],
      primary: AppColors.wiseGreen,
      dark: AppColors.darkGreen,
      shadow: AppColors.positive,
    );
  }
}
