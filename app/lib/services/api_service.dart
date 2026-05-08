import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/compare_result.dart';
import '../models/consumption_record.dart';
import '../models/flex_item.dart';
import '../models/ingredient.dart';
import '../models/user.dart';

class Session {
  const Session({this.userId, this.nickname});

  final String? userId;
  final String? nickname;
}

class DecisionResponse {
  const DecisionResponse({
    required this.record,
    required this.userStats,
    required this.characterState,
  });

  final ConsumptionRecord record;
  final UserStats userStats;
  final String characterState;
}

class PurchaseResponse {
  const PurchaseResponse({
    required this.purchasedItem,
    required this.userStats,
  });

  final FlexItem purchasedItem;
  final UserStats userStats;
}

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  final Duration _timeout = const Duration(seconds: 3);

  String get _baseUrl =>
      dotenv.env['API_BASE_URL']?.trim().replaceAll(RegExp(r'/$'), '') ??
      'http://localhost:8000/api';

  static UserStats? _mockStats;
  static final List<ConsumptionRecord> _mockRecords = [];
  static final List<PurchasedItem> _mockOwnedItems = [];

  static final List<FlexItem> _shopItems = [
    const FlexItem(
      id: 'item_uuid_1',
      name: '럭셔리 핸드백',
      price: 150000,
      emoji: '👜',
      category: 'fashion',
      description: '현실 소비 대신 앱 안에서만 드는 프리미엄 백.',
    ),
    const FlexItem(
      id: 'item_uuid_2',
      name: '명품 시계',
      price: 400000,
      emoji: '⌚',
      category: 'timepiece',
      description: '절약 습관을 더 고급스럽게 보여주는 시계.',
    ),
    const FlexItem(
      id: 'item_uuid_3',
      name: '엘리트 슈퍼카',
      price: 1500000,
      emoji: '🏎️',
      category: 'vehicle',
      description: '과소비 없이 앱 안에서만 달리는 슈퍼카.',
    ),
    const FlexItem(
      id: 'item_uuid_4',
      name: '프레스티지 빌라',
      price: 5000000,
      emoji: '🏙️',
      category: 'real_estate',
      description: '절약으로 쌓은 포인트가 만든 앱 속 라이프스타일.',
    ),
  ];

  Future<Session> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    return Session(
      userId: prefs.getString('userId'),
      nickname: prefs.getString('nickname'),
    );
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('nickname');
    _mockStats = null;
    _mockRecords.clear();
    _mockOwnedItems.clear();
  }

  Future<User> login(String nickname) async {
    final cleanNickname = nickname.trim();
    if (cleanNickname.isEmpty) {
      throw const ApiException('닉네임을 입력해 주세요.');
    }
    if (cleanNickname.length > 30) {
      throw const ApiException('닉네임은 30자 이하로 입력해 주세요.');
    }

    try {
      final json = await _request('POST', '/users/login', {
        'nickname': cleanNickname,
      });
      final user = User.fromJson(json['data'] as Map<String, dynamic>);
      await _saveSession(user.id, user.nickname);
      _mockStats ??= _statsFromUser(user);
      return user;
    } catch (error) {
      if (!_shouldUseMockFallback(error)) rethrow;
      final user = User(
        id: 'mock_user_${cleanNickname.hashCode.abs()}',
        nickname: cleanNickname,
        totalSavedAmount: _mockStats?.totalSavedAmount ?? 0,
        totalRewardPoint: _mockStats?.totalRewardPoint ?? 0,
        virtualBalance: _mockStats?.virtualBalance ?? 0,
        createdAt: DateTime.now(),
      );
      _mockStats ??= _statsFromUser(user);
      await _saveSession(user.id, user.nickname);
      return user;
    }
  }

  Future<UserStats> getStats(String userId, String nickname) async {
    if (_isMockUser(userId)) {
      return _ensureMockStats(userId, nickname);
    }
    try {
      final json = await _request('GET', '/users/$userId/stats');
      final stats = UserStats.fromJson(json['data'] as Map<String, dynamic>);
      _mockStats = stats;
      return stats;
    } catch (error) {
      if (!_shouldUseMockFallback(error)) rethrow;
      return _ensureMockStats(userId, nickname);
    }
  }

  Future<CompareResult> compare({
    required String menuName,
    required int eatingOutPrice,
  }) async {
    try {
      final json = await _request('POST', '/compare', {
        'menuName': menuName.trim(),
        'eatingOutPrice': eatingOutPrice,
      });
      return CompareResult.fromJson(json['data'] as Map<String, dynamic>);
    } catch (error) {
      if (!_shouldUseMockFallback(error)) rethrow;
      return _mockCompare(menuName.trim(), eatingOutPrice);
    }
  }

  Future<DecisionResponse> saveDecision({
    required String userId,
    required CompareResult result,
    required String choice,
    required String nickname,
  }) async {
    if (_isMockUser(userId)) {
      return _mockSaveDecision(
        userId: userId,
        result: result,
        choice: choice,
        nickname: nickname,
      );
    }
    final request = {
      'userId': userId,
      'menuName': result.menuName,
      'eatingOutPrice': result.eatingOutPrice,
      'homeCookingCost': result.homeCookingCost,
      'savingAmount': result.savingAmount,
      'rewardPoint': result.rewardPoint,
      'choice': choice,
      'message': result.message,
    };

    try {
      final json = await _request('POST', '/decisions', request);
      final data = json['data'] as Map<String, dynamic>;
      final record = ConsumptionRecord.fromJson(
        data['record'] as Map<String, dynamic>,
      );
      final stats = _statsFromPartial(
        userId: userId,
        nickname: nickname,
        partial: data['userStats'] as Map<String, dynamic>,
      );
      _mockStats = stats;
      return DecisionResponse(
        record: record,
        userStats: stats,
        characterState: data['characterState'] as String,
      );
    } catch (error) {
      if (!_shouldUseMockFallback(error)) rethrow;
      return _mockSaveDecision(
        userId: userId,
        result: result,
        choice: choice,
        nickname: nickname,
      );
    }
  }

  Future<List<ConsumptionRecord>> getRecords(String userId) async {
    if (_isMockUser(userId)) {
      return List<ConsumptionRecord>.from(_mockRecords);
    }
    try {
      final json = await _request('GET', '/users/$userId/records');
      return (json['data'] as List<dynamic>)
          .map(
            (item) => ConsumptionRecord.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } catch (error) {
      if (!_shouldUseMockFallback(error)) rethrow;
      return List<ConsumptionRecord>.from(_mockRecords);
    }
  }

  Future<List<RankingUser>> getRankings(String userId, String nickname) async {
    if (_isMockUser(userId)) {
      return _mockRankings(userId, nickname);
    }
    try {
      final json = await _request('GET', '/rankings');
      return (json['data'] as List<dynamic>)
          .map((item) => RankingUser.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (error) {
      if (!_shouldUseMockFallback(error)) rethrow;
      return _mockRankings(userId, nickname);
    }
  }

  Future<List<FlexItem>> getFlexItems() async {
    try {
      final json = await _request('GET', '/flex-items');
      return (json['data'] as List<dynamic>)
          .map((item) => FlexItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (error) {
      if (!_shouldUseMockFallback(error)) rethrow;
      return _shopItems;
    }
  }

  Future<List<PurchasedItem>> getOwnedItems(String userId) async {
    if (_isMockUser(userId)) {
      return List<PurchasedItem>.from(_mockOwnedItems);
    }
    try {
      final json = await _request('GET', '/users/$userId/items');
      return (json['data'] as List<dynamic>)
          .map((item) => PurchasedItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (error) {
      if (!_shouldUseMockFallback(error)) rethrow;
      return List<PurchasedItem>.from(_mockOwnedItems);
    }
  }

  Future<PurchaseResponse> purchaseItem({
    required String userId,
    required String nickname,
    required FlexItem item,
  }) async {
    if (_isMockUser(userId)) {
      return _mockPurchase(userId: userId, nickname: nickname, item: item);
    }
    try {
      final json = await _request('POST', '/flex-items/${item.id}/purchase', {
        'userId': userId,
      });
      final data = json['data'] as Map<String, dynamic>;
      final stats = _statsFromPartial(
        userId: userId,
        nickname: nickname,
        partial: data['userStats'] as Map<String, dynamic>,
      );
      _mockStats = stats;
      return PurchaseResponse(
        purchasedItem: FlexItem.fromJson(
          data['purchasedItem'] as Map<String, dynamic>,
        ),
        userStats: stats,
      );
    } on ApiException {
      rethrow;
    } catch (error) {
      if (!_shouldUseMockFallback(error)) rethrow;
      return _mockPurchase(userId: userId, nickname: nickname, item: item);
    }
  }

  Future<Map<String, dynamic>> _request(
    String method,
    String path, [
    Map<String, dynamic>? body,
  ]) async {
    final uri = Uri.parse('$_baseUrl$path');
    late http.Response response;

    if (method == 'POST') {
      response = await _client
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(_timeout);
    } else {
      response = await _client.get(uri).timeout(_timeout);
    }

    final Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw const ApiException('서버 응답을 읽지 못했어요.');
    }
    if (decoded['success'] != true) {
      throw ApiException(
        decoded['message'] as String? ??
            decoded['error'] as String? ??
            '요청에 실패했어요.',
      );
    }
    return decoded;
  }

  Future<void> _saveSession(String userId, String nickname) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    await prefs.setString('nickname', nickname);
  }

  bool _shouldUseMockFallback(Object error) {
    return error is TimeoutException || error is http.ClientException;
  }

  bool _isMockUser(String userId) {
    return userId.startsWith('mock_user_');
  }

  List<RankingUser> _mockRankings(String userId, String nickname) {
    final stats = _ensureMockStats(userId, nickname);
    final users =
        [
          const RankingUser(
            rank: 1,
            userId: 'saving_king',
            nickname: '절약왕',
            totalSavedAmount: 240000,
            totalRewardPoint: 1200000,
            virtualBalance: 240000,
          ),
          RankingUser(
            rank: 2,
            userId: userId,
            nickname: nickname,
            totalSavedAmount: stats.totalSavedAmount,
            totalRewardPoint: stats.totalRewardPoint,
            virtualBalance: stats.virtualBalance,
          ),
          const RankingUser(
            rank: 3,
            userId: 'steady_cook',
            nickname: '집밥고수',
            totalSavedAmount: 86000,
            totalRewardPoint: 430000,
            virtualBalance: 86000,
          ),
        ]..sort((a, b) {
          final saved = b.totalSavedAmount.compareTo(a.totalSavedAmount);
          if (saved != 0) return saved;
          return b.totalRewardPoint.compareTo(a.totalRewardPoint);
        });

    return [
      for (var i = 0; i < users.length; i++)
        RankingUser(
          rank: i + 1,
          userId: users[i].userId,
          nickname: users[i].nickname,
          totalSavedAmount: users[i].totalSavedAmount,
          totalRewardPoint: users[i].totalRewardPoint,
          virtualBalance: users[i].virtualBalance,
        ),
    ];
  }

  UserStats _statsFromUser(User user) {
    return UserStats(
      userId: user.id,
      nickname: user.nickname,
      totalSavedAmount: user.totalSavedAmount,
      totalRewardPoint: user.totalRewardPoint,
      virtualBalance: user.virtualBalance,
      ownedItemCount: _mockOwnedItems.length,
      recordCount: _mockRecords.length,
    );
  }

  UserStats _statsFromPartial({
    required String userId,
    required String nickname,
    required Map<String, dynamic> partial,
  }) {
    return UserStats(
      userId: userId,
      nickname: nickname,
      totalSavedAmount: (partial['totalSavedAmount'] as num).round(),
      totalRewardPoint: (partial['totalRewardPoint'] as num).round(),
      virtualBalance: (partial['virtualBalance'] as num).round(),
      ownedItemCount: _mockOwnedItems.length,
      recordCount: _mockRecords.length,
    );
  }

  UserStats _ensureMockStats(String userId, String nickname) {
    return _mockStats ??= UserStats(
      userId: userId,
      nickname: nickname,
      totalSavedAmount: 0,
      totalRewardPoint: 0,
      virtualBalance: 0,
      ownedItemCount: _mockOwnedItems.length,
      recordCount: _mockRecords.length,
    );
  }

  CompareResult _mockCompare(String menuName, int eatingOutPrice) {
    final homeCost = min(max((eatingOutPrice * .42).round(), 3500), 18000);
    final saving = eatingOutPrice - homeCost;
    final reward = max(saving, 0) * 5;
    return CompareResult(
      menuName: menuName,
      eatingOutPrice: eatingOutPrice,
      homeCookingCost: homeCost,
      savingAmount: saving,
      rewardPoint: reward,
      ingredients: [
        Ingredient(name: '닭발', estimatedPrice: (homeCost * .50).round()),
        Ingredient(name: '고추장과 고춧가루', estimatedPrice: (homeCost * .15).round()),
        Ingredient(
          name: '간장, 다진 마늘, 올리고당',
          estimatedPrice: (homeCost * .17).round(),
        ),
        Ingredient(
          name: '양파, 대파, 청양고추',
          estimatedPrice: homeCost - (homeCost * .82).round(),
        ),
      ],
      recipe: const [
        '닭발을 깨끗이 씻고 끓는 물에 5~10분 정도 데친 뒤, 찬물에 헹궈 잡내와 불순물을 제거한다.',
        '고추장, 고춧가루, 간장, 다진 마늘, 설탕 또는 올리고당, 후추를 섞어 매콤한 양념장을 만든다.',
        '팬에 닭발과 양념장을 넣고 물을 조금 부은 뒤 중불에서 졸이듯이 볶는다. 양념이 잘 배도록 10~15분 정도 익힌다.',
        '양파, 대파, 청양고추 등을 넣고 한 번 더 볶은 뒤, 참기름과 깨를 뿌려 마무리한다.',
      ],
      message: saving > 0
          ? '$menuName 외식 대신 집에서 매콤한 닭발을 만들면 지출을 줄이고 포인트도 챙길 수 있어요.'
          : '가격 차이가 크지 않아요. 그래도 닭발 재료를 준비해두면 다음 지출을 줄일 수 있어요.',
      source: 'fallback',
    );
  }

  DecisionResponse _mockSaveDecision({
    required String userId,
    required CompareResult result,
    required String choice,
    required String nickname,
  }) {
    final current = _ensureMockStats(userId, nickname);
    final isCook = choice == 'cook';
    final earnedPoint = isCook ? result.rewardPoint : 0;
    final nextStats = current.copyWith(
      totalSavedAmount: isCook
          ? current.totalSavedAmount + max(result.savingAmount, 0)
          : current.totalSavedAmount,
      totalRewardPoint: isCook
          ? current.totalRewardPoint + earnedPoint
          : current.totalRewardPoint,
      virtualBalance: isCook
          ? current.virtualBalance + result.savingAmount
          : current.virtualBalance - result.eatingOutPrice,
      recordCount: current.recordCount + 1,
    );
    _mockStats = nextStats;

    final record = ConsumptionRecord(
      id: 'record_${DateTime.now().microsecondsSinceEpoch}',
      userId: userId,
      menuName: result.menuName,
      eatingOutPrice: result.eatingOutPrice,
      homeCookingCost: result.homeCookingCost,
      savingAmount: result.savingAmount,
      rewardPoint: earnedPoint,
      choice: choice,
      message: isCook ? result.message : '이번에는 외식을 선택했어요.',
      createdAt: DateTime.now(),
    );
    _mockRecords.insert(0, record);

    return DecisionResponse(
      record: record,
      userStats: nextStats,
      characterState: _characterState(nextStats.totalSavedAmount * 5),
    );
  }

  PurchaseResponse _mockPurchase({
    required String userId,
    required String nickname,
    required FlexItem item,
  }) {
    final current = _ensureMockStats(userId, nickname);
    if (_mockOwnedItems.any((owned) => owned.id == item.id)) {
      throw const ApiException('이미 보유한 아이템이에요.');
    }
    if (current.totalRewardPoint < item.price) {
      throw const ApiException('포인트가 부족해요.');
    }

    final purchased = PurchasedItem(
      id: item.id,
      name: item.name,
      price: item.price,
      emoji: item.emoji,
      category: item.category,
      description: item.description,
      purchasedAt: DateTime.now(),
    );
    _mockOwnedItems.insert(0, purchased);
    final nextStats = current.copyWith(
      totalRewardPoint: current.totalRewardPoint - item.price,
      ownedItemCount: _mockOwnedItems.length,
    );
    _mockStats = nextStats;
    return PurchaseResponse(purchasedItem: item, userStats: nextStats);
  }

  String _characterState(int cumulativePoint) {
    if (cumulativePoint >= 900000) return 'bankrupt_warning';
    if (cumulativePoint >= 600000) return 'poor_getting_worse';
    if (cumulativePoint >= 300000) return 'rich_getting_better';
    return 'neutral';
  }
}
