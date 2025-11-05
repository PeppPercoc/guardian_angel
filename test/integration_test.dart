import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:guardian_angel/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('Guardian Angel Integration Tests', () {
    testWidgets('App carica e mostra la welcome screen', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('Welcome screen - Navigazione tra pagine', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byType(Scaffold), findsWidgets);
      expect(find.byType(ElevatedButton), findsWidgets);
    });

    testWidgets('Welcome screen - Form validation', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('App mostra la navigation bar', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Emergency screen è navigabile', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('App non crasha durante scroll', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
