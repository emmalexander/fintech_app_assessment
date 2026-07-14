// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.


import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:fintech_app_assessment/main.dart';
import 'package:fintech_app_assessment/providers/bank_provider.dart';
import 'package:fintech_app_assessment/screens/home_screen.dart';

void main() {
  testWidgets('Fintech App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => BankProvider())],
        child: const MyApp(),
      ),
    );

    // Verify that the HomeScreen is rendered
    expect(find.byType(HomeScreen), findsOneWidget);

    // Verify BottomNavigationBar contains Home, Activity, Cards
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Activity'), findsOneWidget);
    expect(find.text('Cards'), findsOneWidget);
  });
}
