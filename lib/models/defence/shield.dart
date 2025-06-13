// This file defines the Shield class, which represents a shield in a game.
// It includes properties for the name, maximum shield points (maxSP), damage resistance (DR) against different damage types

import 'package:ghostnet/models/defence/shield_type.dart';

class Shield {
  final String name;
  final String description;
  final ShieldType type;
  /// Maximum Shield Points (SP)
  final double maxSP;
  /// Damage Resistance (DR) against different damage types
  /// The damage resistance against kinetic damage. Multiplier based.
  final double kineticDR;
  /// The damage resistance against energy damage. Multiplier based.
  final double energyDR;
  /// The damage resistance against explosive damage. Multiplier based.
  final double explosiveDR;

  /// Save to json format for local storage
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'type': type.name,
      'maxSP': maxSP,
      'kineticDR': kineticDR,
      'energyDR': energyDR,
      'explosiveDR': explosiveDR,
    };
  }

  /// Load from local storage in json format
  factory Shield.fromJson(Map<String, dynamic> json) {
    final shield = Shield(
      name: json['name'],
      description: json['description'],
      type: ShieldType.values.firstWhere((e) => e.name == json['type']),
      maxSP: (json['maxSP'] as num).toDouble(),
      kineticDR: (json['kineticDR'] as num).toDouble(),
      energyDR: (json['energyDR'] as num).toDouble(),
      explosiveDR: (json['explosiveDR'] as num).toDouble(),
    );
    return shield;
  }

  /// Constructor for the Shield class
  Shield({
    required this.name,
    required this.description,
    required this.type,
    required this.maxSP,
    required this.kineticDR,
    required this.energyDR,
    required this.explosiveDR,
  });
}
