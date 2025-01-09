import 'package:flutter/material.dart';

class ProfileInfoItem extends StatelessWidget {

  const ProfileInfoItem({required this.label, required this.value, super.key,
    this.valueColor,
  });
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 0.5, color: Colors.grey.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Text(
              '$label: ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: valueColor ?? const Color(0xFF2C3E50),
                fontWeight: valueColor != null ? FontWeight.w600 : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

