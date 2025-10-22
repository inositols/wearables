enum DataRange {
  sevenDays(7, '7d'),
  thirtyDays(30, '30d'),
  ninetyDays(90, '90d');

  const DataRange(this.days, this.label);

  final int days;
  final String label;

  String get displayName {
    switch (this) {
      case DataRange.sevenDays:
        return '7 Days';
      case DataRange.thirtyDays:
        return '30 Days';
      case DataRange.ninetyDays:
        return '90 Days';
    }
  }

  DateTime get startDate {
    final now = DateTime.now();
    return now.subtract(Duration(days: days));
  }

  DateTime get endDate => DateTime.now();
}


