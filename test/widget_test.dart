import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wearables/services/dashboard_provider.dart';
import 'package:wearables/models/data_range.dart';

void main() {
  testWidgets('Provider state management works correctly', (WidgetTester tester) async {
    // Test the provider directly without triggering async operations
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
}