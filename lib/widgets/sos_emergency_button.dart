import 'package:flutter/material.dart';

class SOSEmergencyButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SOSEmergencyButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          color: Colors.red,
        ),
        child: SafeArea(
          bottom: false,
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 14,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.red.shade700,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.warning_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'SOS EMERGENCY',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
