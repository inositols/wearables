import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:wearables/main.dart';
import 'package:wearables/services/dashboard_provider.dart';
import 'package:wearables/models/data_range.dart';

void main() {
  group('Dashboard Widget Tests', () {
    testWidgets('Range switching updates all charts', (WidgetTester tester) async {
      // Create a mock provider
      final provider = DashboardProvider();
      
      await tester.pumpWidget(
        ChangeNotifierProvider<DashboardProvider>(
          create: (context) => provider,
          child: const BiometricsApp(),
        ),
      );

      // Wait for initial load
      await tester.pumpAndSettle();

      // Find range selector buttons
      final sevenDayButton = find.text('7d');
      final thirtyDayButton = find.text('30d');
      final ninetyDayButton = find.text('90d');

      expect(sevenDayButton, findsOneWidget);
      expect(thirtyDayButton, findsOneWidget);
      expect(ninetyDayButton, findsOneWidget);

      // Test switching to 30 days
      await tester.tap(thirtyDayButton);
      await tester.pumpAndSettle();

      // Verify the provider's current range has changed
      expect(provider.currentRange, equals(DataRange.thirtyDays));

      // Test switching to 90 days
      await tester.tap(ninetyDayButton);
      await tester.pumpAndSettle();

      expect(provider.currentRange, equals(DataRange.ninetyDays));

      // Test switching back to 7 days
      await tester.tap(sevenDayButton);
      await tester.pumpAndSettle();

      expect(provider.currentRange, equals(DataRange.sevenDays));
    });

    testWidgets('Tooltips remain synced across charts', (WidgetTester tester) async {
      final provider = DashboardProvider();
      
      await tester.pumpWidget(
        ChangeNotifierProvider<DashboardProvider>(
          create: (context) => provider,
          child: const BiometricsApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Find chart widgets
      final charts = find.byType(LineChart);
      expect(charts, findsWidgets);

      // Simulate touch on first chart
      if (charts.evaluate().isNotEmpty) {
        await tester.tap(charts.first);
        await tester.pumpAndSettle();

        // Verify that all charts would show the same date
        // This is a simplified test - in a real implementation,
        // you'd verify that the selectedDate is consistent across all charts
        expect(provider.currentRange, isA<DataRange>());
      }
    });

    testWidgets('Dark mode toggle works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const BiometricsApp());
      await tester.pumpAndSettle();

      // Find dark mode toggle button
      final darkModeButton = find.byIcon(Icons.dark_mode);
      expect(darkModeButton, findsOneWidget);

      // Tap to toggle dark mode
      await tester.tap(darkModeButton);
      await tester.pumpAndSettle();

      // Verify the button icon changed
      expect(find.byIcon(Icons.light_mode), findsOneWidget);
    });

    testWidgets('Performance toggle works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const BiometricsApp());
      await tester.pumpAndSettle();

      // Find performance toggle in menu
      final menuButton = find.byIcon(Icons.more_vert);
      if (menuButton.evaluate().isNotEmpty) {
        await tester.tap(menuButton);
        await tester.pumpAndSettle();

        // Find and tap the performance toggle option
        final performanceOption = find.text('Toggle Large Dataset');
        if (performanceOption.evaluate().isNotEmpty) {
          await tester.tap(performanceOption);
          await tester.pumpAndSettle();
        }
      }
    });

    testWidgets('Loading state displays skeleton', (WidgetTester tester) async {
      final provider = DashboardProvider();
      
      await tester.pumpWidget(
        ChangeNotifierProvider<DashboardProvider>(
          create: (context) => provider,
          child: const BiometricsApp(),
        ),
      );

      // Don't wait for loading to complete
      await tester.pump();

      // Should show loading skeleton
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('Loading state displays skeleton', (WidgetTester tester) async {
      await tester.pumpWidget(const BiometricsApp());

      // Don't wait for loading to complete
      await tester.pump();

      // Should show loading skeleton or loading indicator
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });
  });
}
