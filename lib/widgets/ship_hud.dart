import 'package:flutter/material.dart';

class ShipHud extends StatelessWidget {
  final String label;
  final String name;
  final double currentHP;
  final double currentSP;
  final double currentAP;
  final Color backgroundColor;

  const ShipHud({
    super.key,
    required this.label,
    required this.name,
    required this.currentHP,
    required this.currentSP,
    required this.currentAP,
    required this.backgroundColor,
  });

  // DO LATER: Add bars for HP, SP, AP
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.zero,
      ),
      // Ship HUD Label (e.g., "FRIENDLY SHIP HUD")
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontFamily: 'PressStart2P',
            ),
          ),
          const SizedBox(height: 4),
          // Ship Name
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'PressStart2P',
            ),
          ),
          // Display current HP, SP, and AP values
          const SizedBox(height: 4),
          Text(
            'HP: ${currentHP.toStringAsFixed(0)}   '
            'SP: ${currentSP.toStringAsFixed(0)}   '
            'AP: ${currentAP.toStringAsFixed(0)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'SilkScreen',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
