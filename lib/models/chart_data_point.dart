import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart' show Color;

class ChartDataPoint {
  final DateTime date;
  final double value;
  final String? label;
  final Color? color;

  const ChartDataPoint({
    required this.date,
    required this.value,
    this.label,
    this.color,
  });

  FlSpot toFlSpot() {
    return FlSpot(date.millisecondsSinceEpoch.toDouble(), value);
  }

  @override
  String toString() {
    return 'ChartDataPoint(date: $date, value: $value, label: $label)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChartDataPoint &&
        other.date == date &&
        other.value == value &&
        other.label == label;
  }

  @override
  int get hashCode {
    return date.hashCode ^ value.hashCode ^ label.hashCode;
  }
}


