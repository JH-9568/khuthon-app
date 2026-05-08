import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app/main.dart';

void main() {
  testWidgets('Flex app starts on login without a saved session', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const FlexApp());
    await tester.pump();

    expect(find.text('Flex'), findsOneWidget);
    expect(find.text('시작하기'), findsOneWidget);
  });
}
