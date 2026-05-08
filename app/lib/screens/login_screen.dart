import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_background.dart';
import '../widgets/flex_design_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.api, required this.onLoggedIn});

  final ApiService api;
  final void Function(String userId, String nickname) onLoggedIn;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _controller = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final user = await widget.api.login(_controller.text);
      widget.onLoggedIn(user.id, user.nickname);
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 48,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      const AssetOrPlaceholder(
                        assetPath: 'assets/login/login_로고.png',
                        width: 132,
                        height: 74,
                        fit: BoxFit.contain,
                        icon: Icons.eco_rounded,
                        background: Colors.transparent,
                        borderRadius: BorderRadius.zero,
                      ),
                      const SizedBox(height: 18),
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          const AssetOrPlaceholder(
                            assetPath: 'assets/login/login_캐릭터.png',
                            width: 304,
                            height: 230,
                            fit: BoxFit.contain,
                            icon: Icons.eco_rounded,
                            background: Colors.transparent,
                            borderRadius: BorderRadius.zero,
                          ),
                          Positioned(
                            right: 6,
                            bottom: 28,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xFFE5DED2),
                                ),
                              ),
                              child: const Text(
                                '잔고 0원',
                                style: TextStyle(
                                  color: AppColors.warmDark,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        '당신의 이름은 무엇인가요?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.darkGreen,
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _controller,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _loading ? null : _login(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                        decoration: const InputDecoration(
                          hintText: '이름을 입력해주세요',
                        ),
                      ),
                      const SizedBox(height: 22),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .9),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: const Color(0xFFE4E7DE)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x10333333),
                              blurRadius: 18,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const AssetOrPlaceholder(
                              assetPath: 'assets/login/login_두쫀쿠.png',
                              width: 128,
                              height: 128,
                              icon: Icons.cookie_rounded,
                              background: AppColors.pastelGreen,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    height: 1.55,
                                  ),
                                  children: [
                                    TextSpan(text: '당신의 가상 캐릭터는\n'),
                                    TextSpan(text: '두쫀쿠를 하루에 10개씩 사먹어서\n'),
                                    TextSpan(text: '파산했습니다.\n잔고 0원...\n'),
                                    TextSpan(
                                      text: 'FLEX',
                                      style: TextStyle(
                                        color: AppColors.primaryGreen,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    TextSpan(text: '를 통해\n다시 시작해볼까요?'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          _error!,
                          style: const TextStyle(
                            color: AppColors.danger,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                      const SizedBox(height: 26),
                      SizedBox(
                        width: double.infinity,
                        height: 64,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _login,
                          child: _loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('시작하기'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
