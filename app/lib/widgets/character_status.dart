import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/flex_item.dart';
import '../models/user.dart';
import '../theme/app_theme.dart';

class CharacterStatus extends StatelessWidget {
  const CharacterStatus({super.key, required this.stats, required this.items});

  final UserStats stats;
  final List<PurchasedItem> items;

  @override
  Widget build(BuildContext context) {
    final state = _state(stats.virtualBalance);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: state.surfaceColors,
        ),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: const Color(0x1F0E0F0C)),
        boxShadow: [
          BoxShadow(
            color: state.shadowColor.withValues(alpha: .18),
            blurRadius: 28,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _MascotStage(state: state, items: items),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .72),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        state.badge,
                        style: TextStyle(
                          color: state.textColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      state.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        height: .98,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.warmDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (items.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final item in items.take(4))
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .72),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  _CharacterCopy _state(int balance) {
    if (balance <= -50000) {
      return const _CharacterCopy(
        state: 'bankrupt_warning',
        badge: '위험',
        title: '주의 모드',
        message: '빨간 영수증이 붙었어요. 오늘은 플렉스보다 회복이 먼저예요.',
        surfaceColors: [Color(0xFFFFF1EF), Color(0xFFFFD4D4)],
        bodyColors: [Color(0xFFFF9A8B), Color(0xFFD03238)],
        textColor: AppColors.danger,
        shadowColor: AppColors.danger,
        mouth: Icons.sentiment_very_dissatisfied,
      );
    }
    if (balance < 0) {
      return const _CharacterCopy(
        state: 'poor_getting_worse',
        badge: '누수',
        title: '지출 누수 발견',
        message: '주머니가 가벼워졌어요. 다음 선택에서 다시 잔고를 올려봐요.',
        surfaceColors: [Color(0xFFF3F4F0), Color(0xFFDDE2D8)],
        bodyColors: [Color(0xFFC6CBC1), Color(0xFF868685)],
        textColor: AppColors.warmDark,
        shadowColor: AppColors.gray,
        mouth: Icons.sentiment_dissatisfied,
      );
    }
    if (balance > 0) {
      return const _CharacterCopy(
        state: 'rich_getting_better',
        badge: '성장',
        title: '점점 부자 되는 중',
        message: '집밥 선택으로 잔고와 포인트가 같이 반짝이고 있어요.',
        surfaceColors: [Color(0xFFF4FFE9), Color(0xFFD9F8C3)],
        bodyColors: [Color(0xFFCDFFAD), AppColors.wiseGreen],
        textColor: AppColors.positive,
        shadowColor: AppColors.positive,
        mouth: Icons.sentiment_very_satisfied,
      );
    }
    return const _CharacterCopy(
      state: 'neutral',
      badge: '대기',
      title: '선택 준비 완료',
      message: '메뉴를 비교하고 다음 선택으로 캐릭터를 성장시켜 보세요.',
      surfaceColors: [Colors.white, AppColors.lightMint],
      bodyColors: [Color(0xFFE8EBE6), Color(0xFFE2F6D5)],
      textColor: AppColors.nearBlack,
      shadowColor: AppColors.nearBlack,
      mouth: Icons.sentiment_satisfied,
    );
  }
}

class _MascotStage extends StatefulWidget {
  const _MascotStage({required this.state, required this.items});

  final _CharacterCopy state;
  final List<PurchasedItem> items;

  @override
  State<_MascotStage> createState() => _MascotStageState();
}

class _MascotStageState extends State<_MascotStage>
    with SingleTickerProviderStateMixin {
  Offset _drag = Offset.zero;
  bool _pressed = false;
  late final AnimationController _idleController;

  static const _assetPath = 'assets/characters/character_states.png';
  static const _sourceWidth = 2816.0;
  static const _sourceHeight = 1536.0;

  @override
  void initState() {
    super.initState();
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    )..repeat();
  }

  @override
  void dispose() {
    _idleController.dispose();
    super.dispose();
  }

  _SpriteFocus get _focus {
    switch (widget.state.state) {
      case 'rich_getting_better':
        return const _SpriteFocus(x: 1700, y: 330, sourceHeight: 520);
      case 'poor_getting_worse':
        return const _SpriteFocus(x: 430, y: 1118, sourceHeight: 530);
      case 'bankrupt_warning':
        return const _SpriteFocus(x: 1745, y: 1112, sourceHeight: 540);
      default:
        return const _SpriteFocus(x: 420, y: 322, sourceHeight: 520);
    }
  }

  @override
  Widget build(BuildContext context) {
    final focus = _focus;
    return SizedBox(
      height: 190,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onPanStart: (_) => setState(() => _pressed = true),
        onPanUpdate: (details) {
          setState(() {
            _drag += details.delta;
            _drag = Offset(
              _drag.dx.clamp(-34, 34).toDouble(),
              _drag.dy.clamp(-28, 28).toDouble(),
            );
          });
        },
        onPanEnd: (_) => setState(() {
          _drag = Offset.zero;
          _pressed = false;
        }),
        onPanCancel: () => setState(() {
          _drag = Offset.zero;
          _pressed = false;
        }),
        child: AnimatedBuilder(
          animation: _idleController,
          builder: (context, child) {
            final idleWave = math.sin(_idleController.value * math.pi * 2);
            final idleTiltY = _pressed ? 0.0 : idleWave * .075;
            final idleLift = _pressed
                ? 0.0
                : math.cos(_idleController.value * math.pi * 2) * 3;
            final tiltX = (_drag.dy / 140).clamp(-.12, .12);
            final tiltY = (-_drag.dx / 140).clamp(-.16, .16) + idleTiltY;
            final scaleBoost = _pressed ? 1.035 : 1.0;

            return LayoutBuilder(
              builder: (context, constraints) {
                final stageWidth = constraints.maxWidth;
                const stageHeight = 190.0;
                final sourceScale = 168 / focus.sourceHeight;
                final imageWidth = _sourceWidth * sourceScale;
                final imageHeight = _sourceHeight * sourceScale;

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      bottom: 10,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: _pressed ? 150 : 138,
                        height: _pressed ? 28 : 24,
                        decoration: BoxDecoration(
                          color: widget.state.shadowColor.withValues(
                            alpha: .18,
                          ),
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: [
                            BoxShadow(
                              color: widget.state.shadowColor.withValues(
                                alpha: .16,
                              ),
                              blurRadius: _pressed ? 30 : 24,
                              spreadRadius: _pressed ? 10 : 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        curve: Curves.easeOutCubic,
                        transformAlignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, .001)
                          ..rotateX(tiltX)
                          ..rotateY(tiltY)
                          ..scale(scaleBoost),
                        child: Transform.translate(
                          offset: Offset(0, idleLift),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: Stack(
                              children: [
                                Positioned(
                                  left:
                                      stageWidth / 2 -
                                      focus.x * sourceScale +
                                      _drag.dx * .22 +
                                      idleWave * 4,
                                  top:
                                      stageHeight / 2 -
                                      focus.y * sourceScale +
                                      _drag.dy * .14,
                                  width: imageWidth,
                                  height: imageHeight,
                                  child: Image.asset(
                                    _assetPath,
                                    fit: BoxFit.fill,
                                    filterQuality: FilterQuality.high,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _DrawnMascotStage(
                                        state: widget.state,
                                        items: widget.items,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 10,
                      child: AnimatedOpacity(
                        opacity: _pressed ? .95 : .62,
                        duration: const Duration(milliseconds: 160),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .76),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Icon(
                            Icons.threed_rotation,
                            size: 16,
                            color: AppColors.warmDark,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 18,
                      left: 12,
                      child: _Gloss(width: 42, height: 20, opacity: .38),
                    ),
                    if (widget.items.isNotEmpty)
                      Positioned(
                        bottom: 6,
                        right: 26,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.nearBlack,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '+${widget.items.length}',
                            style: const TextStyle(
                              color: AppColors.wiseGreen,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _DrawnMascotStage extends StatelessWidget {
  const _DrawnMascotStage({required this.state, required this.items});

  final _CharacterCopy state;
  final List<PurchasedItem> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 8,
            child: Container(
              width: 138,
              height: 24,
              decoration: BoxDecoration(
                color: state.shadowColor.withValues(alpha: .18),
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: state.shadowColor.withValues(alpha: .16),
                    blurRadius: 24,
                    spreadRadius: 8,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 18,
            child: Container(
              width: 138,
              height: 138,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: const Alignment(-.35, -.45),
                  radius: .9,
                  colors: state.bodyColors,
                ),
                boxShadow: [
                  BoxShadow(
                    color: state.shadowColor.withValues(alpha: .23),
                    blurRadius: 28,
                    offset: const Offset(0, 18),
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    blurRadius: 8,
                    offset: Offset(-5, -5),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 38,
            left: 48,
            child: _Gloss(width: 40, height: 22, opacity: .54),
          ),
          Positioned(top: 80, left: 54, child: _Eye(color: state.textColor)),
          Positioned(top: 80, right: 54, child: _Eye(color: state.textColor)),
          Positioned(
            top: 103,
            child: Icon(state.mouth, size: 30, color: state.textColor),
          ),
          Positioned(
            top: state.state == 'rich_getting_better' ? 8 : 18,
            right: 28,
            child: _Accessory(state: state),
          ),
          Positioned(
            bottom: 30,
            left: 26,
            child: _Arm(color: state.bodyColors.last, rotate: -.45),
          ),
          Positioned(
            bottom: 30,
            right: 26,
            child: _Arm(color: state.bodyColors.last, rotate: .45),
          ),
          if (items.isNotEmpty)
            Positioned(
              bottom: 6,
              right: 26,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.nearBlack,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '+${items.length}',
                  style: const TextStyle(
                    color: AppColors.wiseGreen,
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

class _SpriteFocus {
  const _SpriteFocus({
    required this.x,
    required this.y,
    required this.sourceHeight,
  });

  final double x;
  final double y;
  final double sourceHeight;
}

class _Eye extends StatelessWidget {
  const _Eye({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _Gloss extends StatelessWidget {
  const _Gloss({
    required this.width,
    required this.height,
    required this.opacity,
  });

  final double width;
  final double height;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _Arm extends StatelessWidget {
  const _Arm({required this.color, required this.rotate});

  final Color color;
  final double rotate;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotate,
      child: Container(
        width: 22,
        height: 58,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .08),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
      ),
    );
  }
}

class _Accessory extends StatelessWidget {
  const _Accessory({required this.state});

  final _CharacterCopy state;

  @override
  Widget build(BuildContext context) {
    if (state.state == 'bankrupt_warning') {
      return Transform.rotate(
        angle: .14,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.danger,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.danger.withValues(alpha: .22),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Text(
            '!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      );
    }
    if (state.state == 'poor_getting_worse') {
      return Container(
        width: 46,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .84),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0x330E0F0C)),
        ),
        child: const Icon(Icons.receipt_long, size: 18, color: AppColors.gray),
      );
    }
    if (state.state == 'rich_getting_better') {
      return Container(
        width: 74,
        height: 34,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFE78A), Color(0xFFFFB800)],
          ),
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFB800).withValues(alpha: .28),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(Icons.workspace_premium, color: AppColors.darkGreen),
      );
    }
    return Container(
      width: 50,
      height: 22,
      decoration: BoxDecoration(
        color: AppColors.nearBlack,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _CharacterCopy {
  const _CharacterCopy({
    required this.state,
    required this.badge,
    required this.title,
    required this.message,
    required this.surfaceColors,
    required this.bodyColors,
    required this.textColor,
    required this.shadowColor,
    required this.mouth,
  });

  final String state;
  final String badge;
  final String title;
  final String message;
  final List<Color> surfaceColors;
  final List<Color> bodyColors;
  final Color textColor;
  final Color shadowColor;
  final IconData mouth;
}
