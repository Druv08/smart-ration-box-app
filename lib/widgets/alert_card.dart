import 'package:flutter/material.dart';

class AlertCard extends StatelessWidget {
  final String title;
  final String message;
  final bool isWarning;

  const AlertCard({
    super.key,
    required this.title,
    required this.message,
    this.isWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isWarning ? Colors.amber.shade50 : Colors.green.shade50;
    final iconColor = isWarning ? Colors.amber.shade800 : Colors.green.shade700;
    final icon = isWarning ? Icons.warning_amber_rounded : Icons.check_circle;

    return Card(
      color: bgColor,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(message, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
