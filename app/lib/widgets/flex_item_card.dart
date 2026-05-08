import 'package:flutter/material.dart';

import '../models/flex_item.dart';
import '../theme/app_theme.dart';

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
            color: spec.shadow.withValues(alpha: .18),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PremiumPreview(spec: spec, owned: owned),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
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
                      child: Text(
                        spec.label,
                        style: const TextStyle(
                          color: AppColors.positive,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        formatPoint(item.price),
                        style: const TextStyle(
                          color: AppColors.nearBlack,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 116,
                      child: ElevatedButton(
                        onPressed: disabled ? null : onBuy,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: canBuy && !owned
                              ? AppColors.wiseGreen
                              : AppColors.lightSurface,
                          foregroundColor: canBuy && !owned
                              ? AppColors.darkGreen
                              : AppColors.gray,
                          disabledBackgroundColor: AppColors.lightSurface,
                          disabledForegroundColor: AppColors.gray,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                        ),
                        child: Text(owned ? '보유중' : (canBuy ? '구매' : '부족')),
                      ),
                    ),
                  ],
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
    return Container(
      height: 172,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: spec.background,
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18,
            top: -28,
            child: _Glow(size: 118, color: Colors.white.withValues(alpha: .2)),
          ),
          Positioned(
            left: 18,
            top: 18,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .72),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'PREMIUM',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Container(
              height: 22,
              margin: const EdgeInsets.symmetric(horizontal: 58),
              decoration: BoxDecoration(
                color: spec.shadow.withValues(alpha: .24),
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: spec.shadow.withValues(alpha: .18),
                    blurRadius: 18,
                    spreadRadius: 6,
                  ),
                ],
              ),
            ),
          ),
          Center(child: _LuxuryObject(spec: spec)),
          if (owned)
            Positioned(
              right: 16,
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
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
    );
  }
}

class _LuxuryObject extends StatelessWidget {
  const _LuxuryObject({required this.spec});

  final _ItemSpec spec;

  @override
  Widget build(BuildContext context) {
    if (spec.kind == _ItemKind.watch) return _WatchVisual(spec: spec);
    if (spec.kind == _ItemKind.penthouse) return _PenthouseVisual(spec: spec);
    if (spec.kind == _ItemKind.suit) return _SuitVisual(spec: spec);
    return _CarVisual(spec: spec, superCar: spec.kind == _ItemKind.superCar);
  }
}

class _WatchVisual extends StatelessWidget {
  const _WatchVisual({required this.spec});

  final _ItemSpec spec;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 138,
      height: 122,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _Band(top: 0, color: spec.primary),
          _Band(top: 82, color: spec.primary),
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: const Alignment(-.35, -.45),
                colors: [Colors.white, spec.primary, spec.dark],
              ),
              boxShadow: [
                BoxShadow(
                  color: spec.dark.withValues(alpha: .32),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(Icons.watch, color: spec.dark, size: 42),
          ),
          const Positioned(top: 28, left: 42, child: _Shine()),
        ],
      ),
    );
  }
}

class _Band extends StatelessWidget {
  const _Band({required this.top, required this.color});

  final double top;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      child: Container(
        width: 34,
        height: 46,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
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
      width: 184,
      height: 104,
      child: Stack(
        children: [
          Positioned(
            left: superCar ? 22 : 34,
            top: 16,
            child: Container(
              width: superCar ? 114 : 92,
              height: 46,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.white, spec.primary]),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(42),
                  topRight: Radius.circular(56),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: 46,
            child: Container(
              width: 152,
              height: 38,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [spec.primary, spec.dark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(superCar ? 18 : 22),
                boxShadow: [
                  BoxShadow(
                    color: spec.dark.withValues(alpha: .28),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
            ),
          ),
          Positioned(left: 30, top: 70, child: _Wheel(color: spec.dark)),
          Positioned(right: 30, top: 70, child: _Wheel(color: spec.dark)),
          const Positioned(top: 52, right: 30, child: _Shine()),
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
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.nearBlack,
        border: Border.all(color: color, width: 5),
      ),
    );
  }
}

class _PenthouseVisual extends StatelessWidget {
  const _PenthouseVisual({required this.spec});

  final _ItemSpec spec;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 118,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          _Tower(width: 54, height: 98, color: spec.dark, left: 18),
          _Tower(width: 64, height: 116, color: spec.primary, left: 56),
          _Tower(width: 48, height: 82, color: spec.dark, left: 108),
          const Positioned(top: 12, right: 44, child: _Shine()),
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
      bottom: 0,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.white, color]),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: .22),
              blurRadius: 14,
              offset: const Offset(0, 10),
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
      width: 126,
      height: 124,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 106,
            height: 112,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [spec.primary, spec.dark]),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(34),
                topRight: Radius.circular(34),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              boxShadow: [
                BoxShadow(
                  color: spec.dark.withValues(alpha: .28),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
          ),
          Positioned(
            top: 12,
            child: Container(
              width: 44,
              height: 62,
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
            top: 38,
            child: Icon(Icons.diamond, color: spec.primary, size: 28),
          ),
          const Positioned(top: 18, left: 26, child: _Shine()),
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
  const _Shine();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .72),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

enum _ItemKind { watch, car, penthouse, suit, superCar }

class _ItemSpec {
  const _ItemSpec({
    required this.kind,
    required this.label,
    required this.background,
    required this.primary,
    required this.dark,
    required this.shadow,
  });

  final _ItemKind kind;
  final String label;
  final List<Color> background;
  final Color primary;
  final Color dark;
  final Color shadow;

  factory _ItemSpec.fromItem(FlexItem item) {
    final key = '${item.name} ${item.category}'.toLowerCase();
    if (key.contains('watch') || key.contains('시계')) {
      return const _ItemSpec(
        kind: _ItemKind.watch,
        label: 'FASHION',
        background: [Color(0xFFFFF8DD), Color(0xFFFFDF83)],
        primary: Color(0xFFFFC94A),
        dark: Color(0xFF7A5600),
        shadow: Color(0xFFFFB800),
      );
    }
    if (key.contains('penthouse') || key.contains('펜트')) {
      return const _ItemSpec(
        kind: _ItemKind.penthouse,
        label: 'REAL ESTATE',
        background: [Color(0xFFEAF7FF), Color(0xFFB7DDF3)],
        primary: Color(0xFF8AC8E8),
        dark: Color(0xFF25576E),
        shadow: Color(0xFF25576E),
      );
    }
    if (key.contains('suit') || key.contains('수트')) {
      return const _ItemSpec(
        kind: _ItemKind.suit,
        label: 'DESIGNER',
        background: [Color(0xFFF1F1F1), Color(0xFFC9CDD0)],
        primary: Color(0xFF3D4348),
        dark: Color(0xFF0E0F0C),
        shadow: Color(0xFF0E0F0C),
      );
    }
    if (key.contains('super') || key.contains('슈퍼')) {
      return const _ItemSpec(
        kind: _ItemKind.superCar,
        label: 'LIMITED',
        background: [Color(0xFFFFECE7), Color(0xFFFFA680)],
        primary: Color(0xFFFF6F3D),
        dark: Color(0xFF8F1F00),
        shadow: Color(0xFFFF6F3D),
      );
    }
    return const _ItemSpec(
      kind: _ItemKind.car,
      label: 'VEHICLE',
      background: [Color(0xFFF4FFE9), Color(0xFFB5F58A)],
      primary: AppColors.wiseGreen,
      dark: AppColors.darkGreen,
      shadow: AppColors.positive,
    );
  }
}
