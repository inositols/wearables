import 'package:flutter/material.dart';
import '../models/data_range.dart';

class RangeSelector extends StatelessWidget {
  final DataRange currentRange;
  final Function(DataRange) onRangeChanged;
  final bool isDarkMode;

  const RangeSelector({
    super.key,
    required this.currentRange,
    required this.onRangeChanged,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isDarkMode ? 8 : 2,
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Time Range',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: DataRange.values.map((range) {
                final isSelected = currentRange == range;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      onPressed: () => onRangeChanged(range),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? (isDarkMode ? Colors.blue[700] : Colors.blue)
                            : (isDarkMode ? Colors.grey[700] : Colors.grey[200]),
                        foregroundColor: isSelected
                            ? Colors.white
                            : (isDarkMode ? Colors.white70 : Colors.black54),
                        elevation: isSelected ? 4 : 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        range.label,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
}


