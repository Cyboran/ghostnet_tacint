// This file defines the Hull class, which represents a ship's hull in the game.
// It includes properties for the name, maximum hit points (maxHP), evasion, damage resistance (DR) against different damage types, and a list of compatible armours.

import 'package:ghostnet/models/defence/armour_type.dart';
import 'package:ghostnet/models/defence/hull_type.dart';

class Hull {
  final String name;
  final String description;
  final HullType type;
  /// Maximum Hit Points (HP)
  final double maxHP;
  /// Evasion rating of the hull. Higher values indicate better evasion.
  final double evasion;
  /// Damage Resistance (DR) against different damage types
  /// The damage resistance against kinetic damage. Multiplier based.
  final double kineticDR;
  /// The damage resistance against energy damage. Multiplier based.
  final double energyDR;
  /// The damage resistance against explosive damage. Multiplier based.
  final double explosiveDR;
  /// List of compatible armours for this hull.
  final List<ArmourType> compatibleArmours;

  /// Save to json format for local storage
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'type': type.name,
      'maxHP': maxHP,
      'evasion': evasion,
      'kineticDR': kineticDR,
      'energyDR': energyDR,
      'explosiveDR': explosiveDR,
      'compatibleArmours': compatibleArmours.map((e) => e.name).toList(),
    };
  }

  /// Load from local storage in json format
  factory Hull.fromJson(Map<String, dynamic> json) {
    return Hull(
      name: json['name'],
      description: json['description'],
      type: HullType.values.firstWhere((e) => e.name == json['type']),
      maxHP: (json['maxHP'] as num).toDouble(),
      evasion: (json['evasion'] as num).toDouble(),
      kineticDR: (json['kineticDR'] as num).toDouble(),
      energyDR: (json['energyDR'] as num).toDouble(),
      explosiveDR: (json['explosiveDR'] as num).toDouble(),
      compatibleArmours: (json['compatibleArmours'] as List)
          .map((e) => ArmourType.values.firstWhere((a) => a.name == e))
          .toList(),
    );
  }

  /// Constructor for the Hull class
  Hull({
    required this.name,
    required this.description,
    required this.type,
    required this.maxHP,
    required this.evasion,
    required this.kineticDR,
    required this.energyDR,
    required this.explosiveDR,
    required this.compatibleArmours,
  });
}