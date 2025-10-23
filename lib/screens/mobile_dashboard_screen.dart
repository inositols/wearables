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

class MobileDashboardScreen extends StatefulWidget {
  const MobileDashboardScreen({super.key});

  @override
  State<MobileDashboardScreen> createState() => _MobileDashboardScreenState();
}

class _MobileDashboardScreenState extends State<MobileDashboardScreen> {
  DateTime? _selectedDate;
  bool _isDarkMode = false;
  int _currentTabIndex = 0;

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
            title: const Text('Biometrics'),
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
            ],
          ),
          body: _buildBody(provider),
          bottomNavigationBar: _buildBottomNavigation(),
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
        return _buildMobileDashboard(provider);
    }
  }

  Widget _buildMobileDashboard(DashboardProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Range selector - mobile optimized
          _buildMobileRangeSelector(provider),
          const SizedBox(height: 12),
          
          // Performance toggle - mobile optimized
          _buildMobilePerformanceToggle(provider),
          const SizedBox(height: 16),
          
          // Tab-based chart navigation
          _buildChartTabs(provider),
        ],
      ),
    );
  }

  Widget _buildMobileRangeSelector(DashboardProvider provider) {
    return Card(
      elevation: _isDarkMode ? 4 : 1,
      color: _isDarkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Time Range',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: DataRange.values.map((range) {
                final isSelected = provider.currentRange == range;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: ElevatedButton(
                      onPressed: () => provider.changeRange(range),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? (isSelected ? Colors.blue : Colors.grey[200])
                            : (isSelected ? Colors.blue : Colors.grey[200]),
                        foregroundColor: isSelected
                            ? Colors.white
                            : (isSelected ? Colors.white : Colors.black54),
                        elevation: isSelected ? 2 : 0,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        range.label,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobilePerformanceToggle(DashboardProvider provider) {
    return Card(
      elevation: _isDarkMode ? 4 : 1,
      color: _isDarkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              Icons.speed,
              color: _isDarkMode ? Colors.white70 : Colors.black54,
              size: 16,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Performance Mode',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    provider.isLargeDataset 
                        ? 'Large dataset (10k+ points)'
                        : 'Normal dataset',
                    style: TextStyle(
                      fontSize: 10,
                      color: _isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: provider.isLargeDataset,
              onChanged: (_) async => await provider.toggleLargeDataset(),
              activeColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartTabs(DashboardProvider provider) {
    return Column(
      children: [
        // Tab indicators
        Row(
          children: [
            _buildTabButton('HRV', 0, Colors.blue),
            _buildTabButton('RHR', 1, Colors.red),
            _buildTabButton('Steps', 2, Colors.green),
          ],
        ),
        const SizedBox(height: 12),
        
        // Chart content
        _buildChartContent(provider),
      ],
    );
  }

  Widget _buildTabButton(String label, int index, Color color) {
    final isSelected = _currentTabIndex == index;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              _currentTabIndex = index;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? color : Colors.grey[200],
            foregroundColor: isSelected ? Colors.white : Colors.black54,
            elevation: isSelected ? 2 : 0,
            padding: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChartContent(DashboardProvider provider) {
    switch (_currentTabIndex) {
      case 0:
        return _buildChartCard(
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
        );
      case 1:
        return _buildChartCard(
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
        );
      case 2:
        return _buildChartCard(
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
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildChartCard({required String title, required Widget child}) {
    return Card(
      elevation: _isDarkMode ? 4 : 1,
      color: _isDarkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      backgroundColor: _isDarkMode ? Colors.grey[800] : Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: _isDarkMode ? Colors.white70 : Colors.black54,
      currentIndex: _currentTabIndex,
      onTap: (index) {
        setState(() {
          _currentTabIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'HRV',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: 'RHR',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_walk),
          label: 'Steps',
        ),
      ],
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
}
