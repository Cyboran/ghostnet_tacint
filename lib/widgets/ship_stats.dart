import 'package:flutter/material.dart';
import 'package:ghostnet/models/defence/hull.dart';
import 'package:ghostnet/models/defence/armour.dart';
import 'package:ghostnet/models/defence/shield.dart';
import 'package:ghostnet/models/module/thruster.dart';
import 'package:ghostnet/models/weapon/weapon.dart';

// Widget to display ship stats
class ShipStatsWidget extends StatelessWidget {
  final Hull? hull;
  final Armour? armour;
  final Shield? shield;
  final Thruster? thruster;
  final List<Weapon> weapons;

  const ShipStatsWidget({
    super.key,
    required this.hull,
    required this.armour,
    required this.shield,
    required this.thruster,
    required this.weapons,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Display core modules and their stats
        // Hull
        _buildSection('Hull', hull?.name, 'HP: ${formatDouble(hull?.maxHP)}, Evasion: ${formatDouble(hull?.evasion)}'),
        // Armour
        _buildSection('Armour', armour?.name, 'AP: ${formatDouble(armour?.maxAP)}'),
        // Shield
        _buildSection('Shield', shield?.name, 'SP: ${formatDouble(shield?.maxSP)}'),
        // Thruster
        _buildSection('Thruster', thruster?.name, 'Initiative: ${thruster?.initiative}'),
        const Divider(color: Colors.white24),
        // Display weapons and their stats
        // Weapons
        const Text('Weapons', style: TextStyle(color: Colors.white70, fontFamily: 'Silkscreen')),...(
        weapons.isNotEmpty
          ? weapons.map((w) => ListTile(
              title: Text(w.name, style: const TextStyle(color: Colors.white, fontFamily: 'SilkScreen')),
              subtitle: Text(
                '${w.damageType.name.toUpperCase()} • ${w.baseDamage} DMG • ${(w.hitChance * 100).toStringAsFixed(0)}% HIT',
                style: const TextStyle(color: Colors.white54, fontFamily: 'SilkScreen'),
              ),
            )).toList()
          : [
            // Display message when no weapons are equipped
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('No weapons equipped', style: TextStyle(color: Colors.white54)),
            )
          ]
        )
      ],
    );
  }

  // Helper method to build a section with a label, name, and stats
  Widget _buildSection(String label, String? name, String? stats) {
    // Check if the name is null and display a different message
    if (name == null) {
      return ListTile(
        title: Text('$label: —', style: const TextStyle(color: Colors.white54, fontFamily: 'SilkScreen')),
        subtitle: const Text('Not equipped', style: TextStyle(color: Colors.white30, fontFamily: 'SilkScreen')),
      );
    }
    // Otherwise, display the name and stats
    return ListTile(
      title: Text('$label: $name', style: const TextStyle(color: Colors.white, fontFamily: 'SilkScreen')),
      subtitle: stats != null ? Text(stats, style: const TextStyle(color: Colors.white54, fontFamily: 'Silkscreen')) : null,
    );
  }

  // Helper method to format double values with a specified precision
  String formatDouble(double? value, [int precision = 2]) {
    return value != null ? value.toStringAsFixed(precision) : '-';
  }
}
