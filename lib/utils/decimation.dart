import 'dart:math';
import '../models/biometric_data.dart';
import '../models/chart_data_point.dart';

/// Largest-Triangle-Three-Buckets (LTTB) decimation algorithm
/// Reduces data points while preserving important features
class DecimationUtils {
  /// Apply LTTB decimation to reduce data points while preserving shape
  static List<ChartDataPoint> lttbDecimation(
    List<ChartDataPoint> data,
    int targetSize,
  ) {
    if (data.isEmpty) return data;
    if (data.length <= targetSize) return data;
    
    // Ensure target size is reasonable
    final safeTargetSize = min(targetSize, data.length);
    final bucketSize = (data.length - 2) / (safeTargetSize - 2);
    final sampled = <ChartDataPoint>[data.first];
    
    for (int i = 1; i < safeTargetSize - 1; i++) {
      final bucketStart = (i * bucketSize).floor();
      final bucketEnd = min(((i + 1) * bucketSize).floor(), data.length);
      
      // Calculate average point for next bucket
      double avgX = 0;
      double avgY = 0;
      final nextBucketSize = min(bucketSize.floor(), data.length - bucketEnd);
      
      if (nextBucketSize > 0) {
        for (int j = bucketEnd; j < min(bucketEnd + bucketSize.floor(), data.length); j++) {
          avgX += data[j].date.millisecondsSinceEpoch.toDouble();
          avgY += data[j].value;
        }
        avgX /= nextBucketSize;
        avgY /= nextBucketSize;
      }
      
      // Find point in current bucket with maximum triangle area
      double maxArea = -1;
      ChartDataPoint selectedPoint = data[bucketStart];
      
      for (int j = bucketStart; j < bucketEnd; j++) {
        final area = _calculateTriangleArea(
          sampled.last.date.millisecondsSinceEpoch.toDouble(),
          sampled.last.value,
          data[j].date.millisecondsSinceEpoch.toDouble(),
          data[j].value,
          avgX,
          avgY,
        );
        
        if (area > maxArea) {
          maxArea = area;
          selectedPoint = data[j];
        }
      }
      
      sampled.add(selectedPoint);
    }
    
    if (data.length > 1) {
      sampled.add(data.last);
    }
    return sampled;
  }

  /// Calculate triangle area for LTTB algorithm
  static double _calculateTriangleArea(
    double x1, double y1,
    double x2, double y2,
    double x3, double y3,
  ) {
    return ((x2 - x1) * (y3 - y1) - (x3 - x1) * (y2 - y1)).abs() / 2;
  }

  /// Simple bucket mean decimation (faster but less accurate)
  static List<ChartDataPoint> bucketMeanDecimation(
    List<ChartDataPoint> data,
    int targetSize,
  ) {
    if (data.length <= targetSize) return data;
    
    final bucketSize = data.length / targetSize;
    final sampled = <ChartDataPoint>[];
    
    for (int i = 0; i < targetSize; i++) {
      final start = (i * bucketSize).floor();
      final end = ((i + 1) * bucketSize).floor();
      final bucket = data.sublist(start, min(end, data.length));
      
      if (bucket.isNotEmpty) {
        final avgDate = bucket.first.date;
        final avgValue = bucket.map((p) => p.value).reduce((a, b) => a + b) / bucket.length;
        
        sampled.add(ChartDataPoint(
          date: avgDate,
          value: avgValue,
          label: bucket.first.label,
          color: bucket.first.color,
        ));
      }
    }
    
    return sampled;
  }

  /// Convert biometric data to chart data points
  static List<ChartDataPoint> biometricsToChartPoints(
    List<BiometricData> data,
    String metric,
  ) {
    return data.map((item) {
      double value;
      switch (metric.toLowerCase()) {
        case 'hrv':
          value = item.hrv;
          break;
        case 'rhr':
          value = item.rhr.toDouble();
          break;
        case 'steps':
          value = item.steps.toDouble();
          break;
        case 'sleep':
          value = item.sleepScore.toDouble();
          break;
        default:
          value = 0.0;
      }
      
      return ChartDataPoint(
        date: item.dateTime,
        value: value,
        label: metric.toUpperCase(),
      );
    }).toList();
  }

  /// Calculate rolling mean and standard deviation for bands
  static Map<String, List<ChartDataPoint>> calculateRollingStats(
    List<ChartDataPoint> data,
    int windowSize,
  ) {
    final means = <ChartDataPoint>[];
    final upperBounds = <ChartDataPoint>[];
    final lowerBounds = <ChartDataPoint>[];
    
    for (int i = windowSize - 1; i < data.length; i++) {
      final window = data.sublist(i - windowSize + 1, i + 1);
      final mean = window.map((p) => p.value).reduce((a, b) => a + b) / window.length;
      
      final variance = window
          .map((p) => pow(p.value - mean, 2))
          .reduce((a, b) => a + b) / window.length;
      final stdDev = sqrt(variance);
      
      means.add(ChartDataPoint(
        date: data[i].date,
        value: mean,
        label: 'Mean',
      ));
      
      upperBounds.add(ChartDataPoint(
        date: data[i].date,
        value: mean + stdDev,
        label: 'Upper Bound',
      ));
      
      lowerBounds.add(ChartDataPoint(
        date: data[i].date,
        value: mean - stdDev,
        label: 'Lower Bound',
      ));
    }
    
    return {
      'mean': means,
      'upper': upperBounds,
      'lower': lowerBounds,
    };
  }
}


