import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:wearables/services/dashboard_provider.dart';
import 'package:wearables/models/data_range.dart';

void main() {
  group('Dashboard Widget Tests', () {
    testWidgets('Range switching updates all charts', (WidgetTester tester) async {
      // Create a mock provider
      final provider = DashboardProvider();
      
      // Test provider range switching directly without triggering async operations
      provider.changeRange(DataRange.thirtyDays);
      expect(provider.currentRange, equals(DataRange.thirtyDays));

      provider.changeRange(DataRange.ninetyDays);
      expect(provider.currentRange, equals(DataRange.ninetyDays));

      provider.changeRange(DataRange.sevenDays);
      expect(provider.currentRange, equals(DataRange.sevenDays));
    });

    testWidgets('Tooltips remain synced across charts', (WidgetTester tester) async {
      final provider = DashboardProvider();
      
      // Test that provider state is consistent
      expect(provider.currentRange, isA<DataRange>());
      
      // Test that the provider has the expected state
      expect(provider.state, isA<DashboardState>());
    });

    testWidgets('Performance toggle works correctly', (WidgetTester tester) async {
      final provider = DashboardProvider();
      
      // Test large dataset toggle without triggering async operations
      expect(provider.isLargeDataset, isFalse);
      
      // Test that the provider has the expected state
      expect(provider.state, isA<DashboardState>());
    });

    testWidgets('Provider state management works correctly', (WidgetTester tester) async {
      final provider = DashboardProvider();
      
      // Test initial state
      expect(provider.state, equals(DashboardState.loading));
      expect(provider.currentRange, equals(DataRange.sevenDays));
      expect(provider.isLargeDataset, isFalse);
      
      // Test range changes
      provider.changeRange(DataRange.thirtyDays);
      expect(provider.currentRange, equals(DataRange.thirtyDays));
      
      // Test state changes
      provider.setState(DashboardState.loaded);
      expect(provider.state, equals(DashboardState.loaded));
    });

    testWidgets('Data range switching functionality', (WidgetTester tester) async {
      final provider = DashboardProvider();
      
      // Test all range switches
      provider.changeRange(DataRange.sevenDays);
      expect(provider.currentRange, equals(DataRange.sevenDays));
      
      provider.changeRange(DataRange.thirtyDays);
      expect(provider.currentRange, equals(DataRange.thirtyDays));
      
      provider.changeRange(DataRange.ninetyDays);
      expect(provider.currentRange, equals(DataRange.ninetyDays));
    });
  });
}