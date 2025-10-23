import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'lib/services/dashboard_provider.dart';

void main() {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DashboardProvider(),
      child: MaterialApp(
        home: const TestScreen(),
      ),
    );
  }
}

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Large Dataset Test')),
      body: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Text('Large Dataset: ${provider.isLargeDataset}'),
              Text('State: ${provider.state}'),
              Text('HRV Data Points: ${provider.hrvData.length}'),
              Text('RHR Data Points: ${provider.rhrData.length}'),
              Text('Steps Data Points: ${provider.stepsData.length}'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  print('Toggling large dataset...');
                  provider.toggleLargeDataset();
                },
                child: const Text('Toggle Large Dataset'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  provider.loadData();
                },
                child: const Text('Load Data'),
              ),
            ],
          );
        },
      ),
    );
  }
}
