import 'package:flutter/material.dart';

class PerformanceToggle extends StatelessWidget {
  final bool isLargeDataset;
  final VoidCallback onToggle;
  final bool isDarkMode;

  const PerformanceToggle({
    super.key,
    required this.isLargeDataset,
    required this.onToggle,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isDarkMode ? 8 : 2,
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.speed,
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Performance Mode',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    isLargeDataset 
                        ? 'Large dataset (10k+ points) - Decimation enabled'
                        : 'Normal dataset - Full resolution',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: isLargeDataset,
              onChanged: (_) => onToggle(),
              activeColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}


