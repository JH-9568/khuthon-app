import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/api_service.dart';
import '../widgets/app_background.dart';
import '../widgets/ranking_card.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({
    super.key,
    required this.api,
    required this.userId,
    required this.nickname,
  });

  final ApiService api;
  final String userId;
  final String nickname;

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  late Future<List<RankingUser>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.api.getRankings(widget.userId, widget.nickname);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('랭킹')),
      body: AppBackground(
        child: FutureBuilder<List<RankingUser>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    '랭킹을 불러오지 못했어요.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final users = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(18),
              children: [
                Text(
                  '절약 랭킹',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '총 절약 금액이 높은 순서로 보여줘요. 동점이면 포인트가 높은 사용자가 앞서요.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 18),
                ...users.map(
                  (user) => RankingCard(
                    user: user,
                    isCurrentUser: user.userId == widget.userId,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
