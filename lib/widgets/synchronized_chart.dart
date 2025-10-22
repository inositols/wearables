import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/chart_data_point.dart';
import '../models/journal_entry.dart';
import '../models/biometric_data.dart';

class SynchronizedChart extends StatefulWidget {
  final List<ChartDataPoint> data;
  final List<ChartDataPoint>? bands;
  final String title;
  final String unit;
  final Color color;
  final double minY;
  final double maxY;
  final DateTime? selectedDate;
  final List<JournalEntry> journalEntries;
  final List<BiometricData> biometricData;
  final Function(DateTime?) onDateSelected;
  final bool showBands;
  final bool isDarkMode;

  const SynchronizedChart({
    super.key,
    required this.data,
    this.bands,
    required this.title,
    required this.unit,
    required this.color,
    required this.minY,
    required this.maxY,
    this.selectedDate,
    required this.journalEntries,
    required this.biometricData,
    required this.onDateSelected,
    this.showBands = false,
    this.isDarkMode = false,
  });

  @override
  State<SynchronizedChart> createState() => _SynchronizedChartState();
}

class _SynchronizedChartState extends State<SynchronizedChart> {
  DateTime? _hoveredDate;
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: widget.isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: _calculateInterval(
                    widget.minY,
                    widget.maxY,
                  ),
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: widget.isDarkMode
                          ? Colors.grey[800]!
                          : Colors.grey[300]!,
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: widget.isDarkMode
                          ? Colors.grey[800]!
                          : Colors.grey[300]!,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: _calculateTimeInterval(),
                      getTitlesWidget: (value, meta) {
                        final date = DateTime.fromMillisecondsSinceEpoch(
                          value.toInt(),
                        );
                        return Text(
                          _formatDate(date),
                          style: TextStyle(
                            color: widget.isDarkMode
                                ? Colors.white70
                                : Colors.black54,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: _calculateInterval(widget.minY, widget.maxY),
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}${widget.unit}',
                          style: TextStyle(
                            color: widget.isDarkMode
                                ? Colors.white70
                                : Colors.black54,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: widget.isDarkMode
                        ? Colors.grey[700]!
                        : Colors.grey[400]!,
                    width: 1,
                  ),
                ),
                minX: widget.data.isNotEmpty
                    ? widget.data.first.date.millisecondsSinceEpoch.toDouble()
                    : 0,
                maxX: widget.data.isNotEmpty
                    ? widget.data.last.date.millisecondsSinceEpoch.toDouble()
                    : 0,
                minY: widget.minY,
                maxY: widget.maxY,
                lineBarsData: [
                  // Main data line
                  LineChartBarData(
                    spots: widget.data
                        .map((point) => point.toFlSpot())
                        .toList(),
                    isCurved: true,
                    color: widget.color,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: widget.color.withOpacity(0.1),
                    ),
                  ),
                  // Bands if available
                  if (widget.showBands && widget.bands != null)
                    ..._buildBandLines(),
                ],
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    tooltipPadding: const EdgeInsets.all(8),
                    getTooltipItems: (touchedSpots) {
                      if (touchedSpots.isEmpty) return [];

                      final spot = touchedSpots.first;
                      final date = DateTime.fromMillisecondsSinceEpoch(
                        spot.x.toInt(),
                      );
                      final value = spot.y;

                      // Check for journal entry on this date
                      final journalEntry = widget.journalEntries.firstWhere(
                        (entry) =>
                            entry.dateTime.year == date.year &&
                            entry.dateTime.month == date.month &&
                            entry.dateTime.day == date.day,
                        orElse: () => JournalEntry(date: '', mood: 0, note: ''),
                      );

                      String tooltipText =
                          '${widget.title}\n${_formatDate(date)}\n${value.toStringAsFixed(1)}${widget.unit}';
                      if (journalEntry.mood > 0) {
                        tooltipText +=
                            '\n\n${journalEntry.moodEmoji} ${journalEntry.moodDescription}\n${journalEntry.note}';
                      }

                      return [
                        LineTooltipItem(
                          tooltipText,
                          TextStyle(
                            color: widget.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ];
                    },
                  ),
                  touchCallback:
                      (FlTouchEvent event, LineTouchResponse? touchResponse) {
                        if (event is FlPanDownEvent || event is FlTapUpEvent) {
                          if (touchResponse?.lineBarSpots?.isNotEmpty == true) {
                            final spot = touchResponse!.lineBarSpots!.first;
                            final date = DateTime.fromMillisecondsSinceEpoch(
                              spot.x.toInt(),
                            );
                            widget.onDateSelected(date);
                            setState(() {
                              _hoveredDate = date;
                              _isHovering = true;
                            });
                          }
                        } else if (event is FlPanEndEvent) {
                          widget.onDateSelected(null);
                          setState(() {
                            _hoveredDate = null;
                            _isHovering = false;
                          });
                        }
                      },
                  handleBuiltInTouches: true, // Enable pan/zoom
                  getTouchedSpotIndicator:
                      (LineChartBarData barData, List<int> spotIndexes) {
                        return spotIndexes.map((index) {
                          return TouchedSpotIndicatorData(
                            FlLine(color: Colors.blue, strokeWidth: 2),
                            FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 4,
                                  color: Colors.blue,
                                  strokeWidth: 2,
                                  strokeColor: Colors.white,
                                );
                              },
                            ),
                          );
                        }).toList();
                      },
                ),
                // Add annotation markers for journal entries
                extraLinesData: ExtraLinesData(
                  extraLinesOnTop: true,
                  verticalLines: [
                    ..._buildAnnotationLines(),
                    if (widget.selectedDate != null)
                      VerticalLine(
                        x: widget.selectedDate!.millisecondsSinceEpoch
                            .toDouble(),
                        color: Colors.blue.withOpacity(0.8),
                        strokeWidth: 2,
                        dashArray: [3, 3],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<LineChartBarData> _buildBandLines() {
    if (widget.bands == null) return [];

    final bands = widget.bands!;
    return [
      LineChartBarData(
        spots: bands.map((point) => point.toFlSpot()).toList(),
        isCurved: true,
        color: widget.color.withOpacity(0.3),
        barWidth: 1,
        isStrokeCapRound: false,
        dotData: const FlDotData(show: false),
      ),
    ];
  }

  List<VerticalLine> _buildAnnotationLines() {
    final lines = <VerticalLine>[];

    // Add vertical lines for journal entries
    for (final entry in widget.journalEntries) {
      if (widget.data.any(
        (point) =>
            point.date.year == entry.dateTime.year &&
            point.date.month == entry.dateTime.month &&
            point.date.day == entry.dateTime.day,
      )) {
        lines.add(
          VerticalLine(
            x: entry.dateTime.millisecondsSinceEpoch.toDouble(),
            color: _getMoodColor(entry.mood),
            strokeWidth: 2,
          ),
        );
      }
    }

    return lines;
  }

  Color _getMoodColor(int mood) {
    switch (mood) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.lightGreen;
      case 5:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  double _calculateInterval(double min, double max) {
    final range = max - min;
    if (range <= 0) return 1;

    if (range <= 10) return 1;
    if (range <= 50) return 5;
    if (range <= 100) return 10;
    if (range <= 500) return 50;
    if (range <= 1000) return 100;
    if (range <= 5000) return 500;
    return 1000;
  }

  double _calculateTimeInterval() {
    if (widget.data.length <= 7) return 1;
    if (widget.data.length <= 30) return 7;
    return 30;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    if (difference < 7) return '${difference}d ago';
    if (difference < 30) return '${(difference / 7).floor()}w ago';
    return '${date.month}/${date.day}';
  }
}
