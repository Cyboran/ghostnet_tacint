import 'package:flutter/material.dart';

// Widget to display a module's description and image
class ModuleDescription extends StatelessWidget {
  final String name;
  final String imageAsset;
  final String description;

  const ModuleDescription({
    super.key,
    required this.name,
    required this.imageAsset,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(24),
            color: Colors.black87,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PressStart2P',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontFamily: 'Silkscreen',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.tealAccent,
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'PressStart2P',
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: const Text('BACK', style: TextStyle(fontFamily: 'PressStart2P', color: Colors.blue)),
            ),
          ),
        ],
      ),
    );
  }
}