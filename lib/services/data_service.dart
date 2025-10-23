import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import '../models/biometric_data.dart';
import '../models/journal_entry.dart';

class DataService {
  static const String _biometricsAssetPath = 'assets/biometrics_90d.json';
  static const String _journalsAssetPath = 'assets/journals.json';
  
  // Simulate network latency and failures
  static const int _minLatencyMs = 700;
  static const int _maxLatencyMs = 1200;
  static const double _failureRate = 0.1; // 10% failure rate

  final Random _random = Random();

  /// Load biometric data with simulated latency and potential failures
  Future<List<BiometricData>> loadBiometricData() async {
    await _simulateLatency();
    await _simulateFailure();
    
    try {
      final jsonString = await rootBundle.loadString(_biometricsAssetPath);
      final List<dynamic> jsonList = json.decode(jsonString);
      
      return jsonList
          .map((json) => BiometricData.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw DataLoadException('Failed to load biometric data: $e');
    }
  }

  /// Load journal entries with simulated latency and potential failures
  Future<List<JournalEntry>> loadJournalEntries() async {
    await _simulateLatency();
    await _simulateFailure();
    
    try {
      final jsonString = await rootBundle.loadString(_journalsAssetPath);
      final List<dynamic> jsonList = json.decode(jsonString);
      
      return jsonList
          .map((json) => JournalEntry.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw DataLoadException('Failed to load journal entries: $e');
    }
  }

  /// Simulate network latency between 700-1200ms
  Future<void> _simulateLatency() async {
    final latency = _minLatencyMs + _random.nextInt(_maxLatencyMs - _minLatencyMs);
    await Future.delayed(Duration(milliseconds: latency));
  }

  /// Simulate network failures with 10% probability
  Future<void> _simulateFailure() async {
    if (_random.nextDouble() < _failureRate) {
      throw DataLoadException('Simulated network failure');
    }
  }

  /// Generate large dataset for performance testing
  Future<List<BiometricData>> generateLargeDataset(int pointCount) async {
    print('Generating large dataset with $pointCount points...'); // Debug
    await _simulateLatency();
    
    final List<BiometricData> data = [];
    // Generate data for the past 90 days to ensure it shows up in 7d/30d/90d ranges
    final DateTime startDate = DateTime.now().subtract(const Duration(days: 90));
    
    // Limit point count to prevent memory issues
    final safePointCount = pointCount > 10000 ? 10000 : pointCount;
    print('Safe point count: $safePointCount'); // Debug
    
    for (int i = 0; i < safePointCount; i++) {
      // Distribute points across the past 90 days
      final daysBack = (i / safePointCount) * 90;
      final date = DateTime.now().subtract(Duration(days: daysBack.round()));
      final hrv = 50 + _random.nextDouble() * 30; // 50-80 range
      final rhr = 55 + _random.nextInt(20); // 55-75 range
      final steps = 5000 + _random.nextInt(8000); // 5k-13k range
      final sleepScore = 60 + _random.nextInt(40); // 60-100 range
      
      data.add(BiometricData(
        date: date.toIso8601String().split('T')[0],
        hrv: double.parse(hrv.toStringAsFixed(1)),
        rhr: rhr,
        steps: steps,
        sleepScore: sleepScore,
      ));
    }
    
    print('Large dataset generation complete: ${data.length} points'); // Debug
    return data;
  }
}

class DataLoadException implements Exception {
  final String message;
  
  const DataLoadException(this.message);
  
  @override
  String toString() => 'DataLoadException: $message';
}


