import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
    final IconData icon;
    final String label;
    final String value;
    final TextStyle valueStyle;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueStyle = const TextStyle(),
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[800]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value,
                  style: valueStyle.merge(
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}