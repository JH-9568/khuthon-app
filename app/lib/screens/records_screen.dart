import 'package:flutter/material.dart';

import '../models/consumption_record.dart';
import '../services/api_service.dart';
import '../widgets/record_card.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key, required this.api, required this.userId});

  final ApiService api;
  final String userId;

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  late Future<List<ConsumptionRecord>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.api.getRecords(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('소비 기록')),
      body: FutureBuilder<List<ConsumptionRecord>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final records = snapshot.data!;
          if (records.isEmpty) {
            return const Center(child: Text('아직 기록이 없어요. 홈에서 메뉴를 먼저 비교해 보세요.'));
          }
          return ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Text('지난 선택', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16),
              ...records.map((record) => RecordCard(record: record)),
            ],
          );
        },
      ),
    );
  }
}
