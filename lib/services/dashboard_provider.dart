import 'package:flutter/foundation.dart';
import '../models/biometric_data.dart';
import '../models/journal_entry.dart';
import '../models/data_range.dart';
import '../models/chart_data_point.dart';
import '../utils/decimation.dart';
import 'data_service.dart';

enum DashboardState {
  loading,
  loaded,
  error,
  empty,
}

class DashboardProvider extends ChangeNotifier {
  final DataService _dataService = DataService();
  
  DashboardState _state = DashboardState.loading;
  List<BiometricData> _biometricData = [];
  List<JournalEntry> _journalEntries = [];
  DataRange _currentRange = DataRange.sevenDays;
  bool _isLargeDataset = false;
  String? _errorMessage;
  
  // Chart data
  List<ChartDataPoint> _hrvData = [];
  List<ChartDataPoint> _rhrData = [];
  List<ChartDataPoint> _stepsData = [];
  Map<String, List<ChartDataPoint>> _hrvBands = {};
  
  // Performance tracking
  int _decimationThreshold = 1000;
  bool _useLTTB = true;

  // Getters
  DashboardState get state => _state;
  List<BiometricData> get biometricData => _biometricData;
  List<JournalEntry> get journalEntries => _journalEntries;
  DataRange get currentRange => _currentRange;
  bool get isLargeDataset => _isLargeDataset;
  String? get errorMessage => _errorMessage;
  
  List<ChartDataPoint> get hrvData => _hrvData;
  List<ChartDataPoint> get rhrData => _rhrData;
  List<ChartDataPoint> get stepsData => _stepsData;
  Map<String, List<ChartDataPoint>> get hrvBands => _hrvBands;

  /// Load all data for the dashboard
  Future<void> loadData() async {
    _setState(DashboardState.loading);
    _errorMessage = null;
    
    try {
      if (_isLargeDataset) {
        await _loadLargeDataset();
      } else {
        await _loadNormalDataset();
      }
      
      _processData();
      _setState(DashboardState.loaded);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(DashboardState.error);
    }
  }

  /// Load normal dataset from assets
  Future<void> _loadNormalDataset() async {
    final futures = await Future.wait([
      _dataService.loadBiometricData(),
      _dataService.loadJournalEntries(),
    ]);
    
    _biometricData = futures[0] as List<BiometricData>;
    _journalEntries = futures[1] as List<JournalEntry>;
  }

  /// Load large dataset for performance testing
  Future<void> _loadLargeDataset() async {
    print('Loading large dataset...'); // Debug
    _biometricData = await _dataService.generateLargeDataset(10000);
    print('Large dataset loaded: ${_biometricData.length} points'); // Debug
    _journalEntries = await _dataService.loadJournalEntries();
    print('Journal entries loaded: ${_journalEntries.length} entries'); // Debug
  }

  /// Process and filter data based on current range
  void _processData() {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: _currentRange.days));
    
    print('Processing data: ${_biometricData.length} total points, range: ${_currentRange.days} days'); // Debug
    
    // Filter biometric data by date range
    final filteredBiometrics = _biometricData
        .where((data) => data.dateTime.isAfter(startDate))
        .toList();
    
    print('Filtered biometrics: ${filteredBiometrics.length} points'); // Debug
    
    // Filter journal entries by date range
    final filteredJournals = _journalEntries
        .where((entry) => entry.dateTime.isAfter(startDate))
        .toList();
    
    // Convert to chart data points
    _hrvData = DecimationUtils.biometricsToChartPoints(filteredBiometrics, 'hrv');
    _rhrData = DecimationUtils.biometricsToChartPoints(filteredBiometrics, 'rhr');
    _stepsData = DecimationUtils.biometricsToChartPoints(filteredBiometrics, 'steps');
    
    print('Chart data points - HRV: ${_hrvData.length}, RHR: ${_rhrData.length}, Steps: ${_stepsData.length}'); // Debug
    
    // Apply decimation if needed
    if (_hrvData.length > _decimationThreshold) {
      print('Applying decimation to HRV data: ${_hrvData.length} -> $_decimationThreshold'); // Debug
      _hrvData = _useLTTB 
          ? DecimationUtils.lttbDecimation(_hrvData, _decimationThreshold)
          : DecimationUtils.bucketMeanDecimation(_hrvData, _decimationThreshold);
      print('HRV data after decimation: ${_hrvData.length}'); // Debug
    }
    
    if (_rhrData.length > _decimationThreshold) {
      _rhrData = _useLTTB 
          ? DecimationUtils.lttbDecimation(_rhrData, _decimationThreshold)
          : DecimationUtils.bucketMeanDecimation(_rhrData, _decimationThreshold);
    }
    
    if (_stepsData.length > _decimationThreshold) {
      _stepsData = _useLTTB 
          ? DecimationUtils.lttbDecimation(_stepsData, _decimationThreshold)
          : DecimationUtils.bucketMeanDecimation(_stepsData, _decimationThreshold);
    }
    
    // Calculate HRV bands (7-day rolling mean ±1σ)
    _hrvBands = DecimationUtils.calculateRollingStats(_hrvData, 7);
  }

  /// Change data range (7d/30d/90d)
  void changeRange(DataRange newRange) {
    if (_currentRange != newRange) {
      _currentRange = newRange;
      _processData();
      notifyListeners();
    }
  }

  /// Toggle large dataset mode
  Future<void> toggleLargeDataset() async {
    _isLargeDataset = !_isLargeDataset;
    print('Large dataset toggled: $_isLargeDataset'); // Debug
    notifyListeners(); // Update UI immediately
    
    try {
      await loadData();
      print('Large dataset loaded successfully'); // Debug
    } catch (error) {
      print('Error loading large dataset: $error'); // Debug
      _errorMessage = error.toString();
      _setState(DashboardState.error);
      notifyListeners();
    }
  }

  /// Retry loading data
  void retry() {
    loadData();
  }

  /// Set decimation parameters
  void setDecimationParams({
    int? threshold,
    bool? useLTTB,
  }) {
    if (threshold != null) _decimationThreshold = threshold;
    if (useLTTB != null) _useLTTB = useLTTB;
    
    if (_state == DashboardState.loaded) {
      _processData();
      notifyListeners();
    }
  }

  void _setState(DashboardState newState) {
    _state = newState;
    notifyListeners();
  }

  // Public method for demo purposes
  void setState(DashboardState newState) {
    _setState(newState);
  }

  /// Get journal entry for a specific date
  JournalEntry? getJournalEntryForDate(DateTime date) {
    final dateString = date.toIso8601String().split('T')[0];
    try {
      return _journalEntries.firstWhere(
        (entry) => entry.date == dateString,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get biometric data for a specific date
  BiometricData? getBiometricDataForDate(DateTime date) {
    final dateString = date.toIso8601String().split('T')[0];
    try {
      return _biometricData.firstWhere(
        (data) => data.date == dateString,
      );
    } catch (e) {
      return null;
    }
  }
}


