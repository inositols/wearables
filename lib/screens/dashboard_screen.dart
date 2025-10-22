import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:provider/provider.dart';
import '../services/dashboard_provider.dart';
import '../models/data_range.dart';
import '../widgets/synchronized_chart.dart';
import '../widgets/loading_skeleton.dart';
import '../widgets/error_widget.dart';
import '../widgets/empty_widget.dart';
import '../widgets/range_selector.dart';
import '../widgets/performance_toggle.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime? _selectedDate;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.grey[50],
          appBar: AppBar(
            title: const Text('Biometrics Dashboard'),
            backgroundColor: _isDarkMode ? Colors.grey[800] : Colors.white,
            foregroundColor: _isDarkMode ? Colors.white : Colors.black,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
                onPressed: () {
                  setState(() {
                    _isDarkMode = !_isDarkMode;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  provider.retry();
                },
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'performance') {
                    provider.toggleLargeDataset();
                  } else if (value == 'error') {
                    // Simulate error for demo
                    provider.setState(DashboardState.error);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'performance',
                    child: Text('Toggle Large Dataset'),
                  ),
                  const PopupMenuItem(
                    value: 'error',
                    child: Text('Simulate Error'),
                  ),
                ],
              ),
            ],
          ),
          body: _buildBody(provider),
        );
      },
    );
  }

  Widget _buildBody(DashboardProvider provider) {
    switch (provider.state) {
      case DashboardState.loading:
        return const LoadingSkeleton();
      case DashboardState.error:
        return ErrorWidget(
          message: provider.errorMessage ?? 'Unknown error',
          onRetry: provider.retry,
        );
      case DashboardState.empty:
        return const EmptyWidget();
      case DashboardState.loaded:
        return _buildDashboard(provider);
    }
  }

  Widget _buildDashboard(DashboardProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Range selector
          RangeSelector(
            currentRange: provider.currentRange,
            onRangeChanged: provider.changeRange,
            isDarkMode: _isDarkMode,
          ),
          const SizedBox(height: 16),

          // Performance toggle
          PerformanceToggle(
            isLargeDataset: provider.isLargeDataset,
            onToggle: provider.toggleLargeDataset,
            isDarkMode: _isDarkMode,
          ),
          const SizedBox(height: 24),

          // HRV Chart
          _buildChartCard(
            title: 'Heart Rate Variability (HRV)',
            child: SynchronizedChart(
              data: provider.hrvData,
              bands: provider.hrvBands['mean'],
              title: 'HRV',
              unit: 'ms',
              color: Colors.blue,
              minY: _calculateMinY(provider.hrvData, 10),
              maxY: _calculateMaxY(provider.hrvData, 10),
              selectedDate: _selectedDate,
              journalEntries: provider.journalEntries,
              biometricData: provider.biometricData,
              onDateSelected: _onDateSelected,
              showBands: true,
              isDarkMode: _isDarkMode,
            ),
          ),

          const SizedBox(height: 16),

          // RHR Chart
          _buildChartCard(
            title: 'Resting Heart Rate (RHR)',
            child: SynchronizedChart(
              data: provider.rhrData,
              title: 'RHR',
              unit: 'bpm',
              color: Colors.red,
              minY: _calculateMinY(provider.rhrData, 5),
              maxY: _calculateMaxY(provider.rhrData, 5),
              selectedDate: _selectedDate,
              journalEntries: provider.journalEntries,
              biometricData: provider.biometricData,
              onDateSelected: _onDateSelected,
              isDarkMode: _isDarkMode,
            ),
          ),

          const SizedBox(height: 16),

          // Steps Chart
          _buildChartCard(
            title: 'Daily Steps',
            child: SynchronizedChart(
              data: provider.stepsData,
              title: 'Steps',
              unit: '',
              color: Colors.green,
              minY: 0,
              maxY: _calculateMaxY(provider.stepsData, 1000),
              selectedDate: _selectedDate,
              journalEntries: provider.journalEntries,
              biometricData: provider.biometricData,
              onDateSelected: _onDateSelected,
              isDarkMode: _isDarkMode,
            ),
          ),

          const SizedBox(height: 24),

          // Selected date info
          if (_selectedDate != null) _buildSelectedDateInfo(provider),
        ],
      ),
    );
  }

  Widget _buildChartCard({required String title, required Widget child}) {
    return Card(
      elevation: _isDarkMode ? 8 : 2,
      color: _isDarkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedDateInfo(DashboardProvider provider) {
    final biometricData = provider.getBiometricDataForDate(_selectedDate!);
    final journalEntry = provider.getJournalEntryForDate(_selectedDate!);

    return Card(
      elevation: _isDarkMode ? 8 : 2,
      color: _isDarkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected Date: ${_formatDate(_selectedDate!)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            if (biometricData != null) ...[
              _buildInfoRow('HRV', '${biometricData.hrv} ms'),
              _buildInfoRow('RHR', '${biometricData.rhr} bpm'),
              _buildInfoRow('Steps', '${biometricData.steps}'),
              _buildInfoRow('Sleep Score', '${biometricData.sleepScore}'),
            ],
            if (journalEntry != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                'Mood',
                '${journalEntry.moodEmoji} ${journalEntry.moodDescription}',
              ),
              _buildInfoRow('Note', journalEntry.note),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                color: _isDarkMode ? Colors.white70 : Colors.black54,
                fontSize: 12,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: _isDarkMode ? Colors.white : Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _onDateSelected(DateTime? date) {
    setState(() {
      _selectedDate = date;
    });
  }

  double _calculateMinY(List<dynamic> data, double padding) {
    if (data.isEmpty) return 0;
    final values = data.map((d) => d.value as double).toList();
    return values.reduce((a, b) => a < b ? a : b) - padding;
  }

  double _calculateMaxY(List<dynamic> data, double padding) {
    if (data.isEmpty) return 100;
    final values = data.map((d) => d.value as double).toList();
    return values.reduce((a, b) => a > b ? a : b) + padding;
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}

