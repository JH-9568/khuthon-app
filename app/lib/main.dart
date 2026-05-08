import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/api_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const FlexApp());
}

class FlexApp extends StatelessWidget {
  const FlexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flex',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AppGate(),
    );
  }
}

class AppGate extends StatefulWidget {
  const AppGate({super.key});

  @override
  State<AppGate> createState() => _AppGateState();
}

class _AppGateState extends State<AppGate> {
  final ApiService _api = ApiService();
  bool _loading = true;
  String? _userId;
  String? _nickname;

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final session = await _api.loadSession();
    if (!mounted) return;
    setState(() {
      _userId = session.userId;
      _nickname = session.nickname;
      _loading = false;
    });
  }

  void _handleLoggedIn(String userId, String nickname) {
    setState(() {
      _userId = userId;
      _nickname = nickname;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_userId == null || _nickname == null) {
      return LoginScreen(api: _api, onLoggedIn: _handleLoggedIn);
    }

    return HomeScreen(api: _api, userId: _userId!, nickname: _nickname!);
  }
}
