import 'package:flutter_test/flutter_test.dart';
import 'package:wearables/utils/decimation.dart';
import 'package:wearables/models/chart_data_point.dart';

void main() {
  group('Decimation Tests', () {
    late List<ChartDataPoint> testData;

    setUp(() {
      // Create test data with known min/max values
      testData = List.generate(100, (index) {
        final date = DateTime(2024, 1, 1).add(Duration(days: index));
        return ChartDataPoint(
          date: date,
          value: index.toDouble(), // Simple linear progression
          label: 'Test',
        );
      });
    });

    test('LTTB decimation preserves min and max values', () {
      final decimated = DecimationUtils.lttbDecimation(testData, 20);
      
      // Find min and max in original data
      final originalMin = testData.map((p) => p.value).reduce((a, b) => a < b ? a : b);
      final originalMax = testData.map((p) => p.value).reduce((a, b) => a > b ? a : b);
      
      // Find min and max in decimated data
      final decimatedMin = decimated.map((p) => p.value).reduce((a, b) => a < b ? a : b);
      final decimatedMax = decimated.map((p) => p.value).reduce((a, b) => a > b ? a : b);
      
      expect(decimatedMin, equals(originalMin));
      expect(decimatedMax, equals(originalMax));
    });

    test('LTTB decimation returns correct output size', () {
      final targetSize = 20;
      final decimated = DecimationUtils.lttbDecimation(testData, targetSize);
      
      expect(decimated.length, equals(targetSize));
    });

    test('LTTB decimation handles edge cases', () {
      // Test with data smaller than target size
      final smallData = testData.take(5).toList();
      final result = DecimationUtils.lttbDecimation(smallData, 10);
      expect(result.length, equals(5));
      
      // Test with empty data
      final emptyResult = DecimationUtils.lttbDecimation([], 10);
      expect(emptyResult.length, equals(0));
    });

    test('Bucket mean decimation preserves data range', () {
      final decimated = DecimationUtils.bucketMeanDecimation(testData, 20);
      
      // Find min and max in original data
      final originalMin = testData.map((p) => p.value).reduce((a, b) => a < b ? a : b);
      final originalMax = testData.map((p) => p.value).reduce((a, b) => a > b ? a : b);
      
      // Find min and max in decimated data
      final decimatedMin = decimated.map((p) => p.value).reduce((a, b) => a < b ? a : b);
      final decimatedMax = decimated.map((p) => p.value).reduce((a, b) => a > b ? a : b);
      
      // Bucket mean may not preserve exact min/max, but should preserve range
      expect(decimatedMin, lessThanOrEqualTo(originalMax));
      expect(decimatedMax, greaterThanOrEqualTo(originalMin));
    });

    test('Bucket mean decimation returns correct output size', () {
      final targetSize = 20;
      final decimated = DecimationUtils.bucketMeanDecimation(testData, targetSize);
      
      expect(decimated.length, equals(targetSize));
    });

    test('Rolling stats calculation works correctly', () {
      final windowSize = 7;
      final stats = DecimationUtils.calculateRollingStats(testData, windowSize);
      
      expect(stats['mean'], isNotNull);
      expect(stats['upper'], isNotNull);
      expect(stats['lower'], isNotNull);
      
      expect(stats['mean']!.length, equals(testData.length - windowSize + 1));
      expect(stats['upper']!.length, equals(testData.length - windowSize + 1));
      expect(stats['lower']!.length, equals(testData.length - windowSize + 1));
      
      // Check that upper bound is always >= mean and lower bound is always <= mean
      for (int i = 0; i < stats['mean']!.length; i++) {
        expect(stats['upper']![i].value, greaterThanOrEqualTo(stats['mean']![i].value));
        expect(stats['lower']![i].value, lessThanOrEqualTo(stats['mean']![i].value));
      }
    });
  });
}

