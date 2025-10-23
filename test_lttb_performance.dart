import 'dart:math';
import 'package:flutter/material.dart';
import 'lib/utils/decimation.dart';
import 'lib/models/chart_data_point.dart';

void main() {
  runApp(const LTTBTestApp());
}

class LTTBTestApp extends StatelessWidget {
  const LTTBTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LTTB Performance Test',
      home: const LTTBTestScreen(),
    );
  }
}

class LTTBTestScreen extends StatefulWidget {
  const LTTBTestScreen({super.key});

  @override
  State<LTTBTestScreen> createState() => _LTTBTestScreenState();
}

class _LTTBTestScreenState extends State<LTTBTestScreen> {
  List<ChartDataPoint> _originalData = [];
  List<ChartDataPoint> _decimatedData = [];
  int _originalCount = 0;
  int _decimatedCount = 0;
  double _compressionRatio = 0.0;
  String _status = 'Click "Generate Test Data" to start';

  void _generateTestData() {
    setState(() {
      _status = 'Generating test data...';
    });

    // Generate 10,000 data points with realistic patterns
    final random = Random(42); // Fixed seed for reproducible results
    final now = DateTime.now();
    _originalData = [];

    for (int i = 0; i < 10000; i++) {
      final date = now.subtract(Duration(days: 10000 - i));
      
      // Create realistic time-series data with trends and noise
      final trend = 50 + (i / 10000) * 20; // Gradual upward trend
      final seasonal = 10 * sin(i * 2 * pi / 365); // Seasonal variation
      final noise = random.nextDouble() * 10 - 5; // Random noise
      final value = trend + seasonal + noise;
      
      _originalData.add(ChartDataPoint(
        date: date,
        value: value,
        label: 'Test Data',
      ));
    }

    setState(() {
      _status = 'Applying LTTB decimation...';
    });

    // Apply LTTB decimation
    final stopwatch = Stopwatch()..start();
    _decimatedData = DecimationUtils.lttbDecimation(_originalData, 1000);
    stopwatch.stop();

    setState(() {
      _originalCount = _originalData.length;
      _decimatedCount = _decimatedData.length;
      _compressionRatio = (1 - _decimatedCount / _originalCount) * 100;
      _status = 'LTTB completed in ${stopwatch.elapsedMilliseconds}ms';
    });
  }

  void _testPerformance() {
    if (_originalData.isEmpty) return;

    setState(() {
      _status = 'Testing performance...';
    });

    final stopwatch = Stopwatch();
    
    // Test original data processing
    stopwatch.start();
    for (int i = 0; i < 100; i++) {
      // Simulate chart rendering
      _originalData.map((p) => p.value).toList();
    }
    final originalTime = stopwatch.elapsedMilliseconds;
    
    // Test decimated data processing
    stopwatch.reset();
    stopwatch.start();
    for (int i = 0; i < 100; i++) {
      // Simulate chart rendering
      _decimatedData.map((p) => p.value).toList();
    }
    final decimatedTime = stopwatch.elapsedMilliseconds;
    
    final performanceGain = originalTime / decimatedTime;
    
    setState(() {
      _status = 'Performance Test Results:\n'
          'Original (${_originalCount} points): ${originalTime}ms\n'
          'Decimated (${_decimatedCount} points): ${decimatedTime}ms\n'
          'Performance Gain: ${performanceGain.toStringAsFixed(1)}x faster';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LTTB Algorithm Performance Test'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'LTTB Algorithm Test',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Status: $_status'),
                    const SizedBox(height: 8),
                    if (_originalCount > 0) ...[
                      Text('Original Data Points: $_originalCount'),
                      Text('Decimated Data Points: $_decimatedCount'),
                      Text('Compression Ratio: ${_compressionRatio.toStringAsFixed(1)}%'),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _generateTestData,
                  child: const Text('Generate Test Data'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _testPerformance,
                  child: const Text('Test Performance'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_decimatedData.isNotEmpty) ...[
              const Text(
                'Data Visualization:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text('Original Data (first 20 points):'),
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListView.builder(
                            itemCount: min(20, _originalData.length),
                            itemBuilder: (context, index) {
                              final point = _originalData[index];
                              return Text(
                                '${point.date.day}/${point.date.month}: ${point.value.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 12),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text('Decimated Data (first 20 points):'),
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListView.builder(
                            itemCount: min(20, _decimatedData.length),
                            itemBuilder: (context, index) {
                              final point = _decimatedData[index];
                              return Text(
                                '${point.date.day}/${point.date.month}: ${point.value.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 12),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
