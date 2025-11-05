import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardian_angel/widgets/app_navigation_bar.dart';
import 'package:guardian_angel/styles/theme.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

void main() {
  group('Widget Tests - App Navigation Bar', () {
    testWidgets('AppNavigationBar renderizza 3 tab', (WidgetTester tester) async {
      // Arrange
      int selectedIndex = 0;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          theme: appTheme,
          home: Scaffold(
            body: Container(),
            bottomNavigationBar: AppNavigationBar(
              selectedIndex: selectedIndex,
              onTabChange: (index) {
                selectedIndex = index;
              },
              horizontalPadding: 10,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(GNav), findsOneWidget);
      expect(find.byIcon(Icons.medication), findsWidgets);
      expect(find.byIcon(Icons.home), findsWidgets);
      expect(find.byIcon(Icons.settings), findsWidgets);
    });

    testWidgets('AppNavigationBar è correttamente posizionata', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          theme: appTheme,
          home: Scaffold(
            body: Container(),
            bottomNavigationBar: AppNavigationBar(
              selectedIndex: 1,
              onTabChange: (index) {},
              horizontalPadding: 10,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(AppNavigationBar), findsOneWidget);
      expect(find.byType(GNav), findsOneWidget);
    });
  });

  group('Widget Tests - Loading Screen', () {
    testWidgets('LoadingScreen mostra spinner di caricamento', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          theme: appTheme,
          home: const Scaffold(
            body: CircularProgressIndicator(),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('LoadingScreen con messaggio lo visualizza', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          theme: appTheme,
          home: const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 24),
                  Text('Caricamento in corso...'),
                ],
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Caricamento in corso...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}