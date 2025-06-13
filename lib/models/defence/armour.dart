// This file defines the Armour class, which represents the armor of a ship in the game.
// It includes properties for the name, maximum armor points (maxAp), damage resistance (DR) against different damage types,

import 'package:ghostnet/models/defence/armour_special.dart';
import 'package:ghostnet/models/defence/armour_type.dart';

class Armour {
  final String name;
  final String description;
  final ArmourType type;
  /// Maximum Armor Points (AP)
  final double maxAP;
  /// Damage Resistance (DR) against different damage types
  /// The damage resistance against kinetic damage. Multiplier based.
  final double kineticDR;
  /// The damage resistance against energy damage. Multiplier based.
  final double energyDR;
  /// The damage resistance against explosive damage. Multiplier based.
  final double explosiveDR;
  /// Special ability or effect of the armor, if any.
  final ArmourSpecial? special;
  final double? specialValue;

  /// Save to json format for local storage
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'type': type.name,
      'maxAP': maxAP,
      'kineticDR': kineticDR,
      'energyDR': energyDR,
      'explosiveDR': explosiveDR,
      'special': special?.name,
      'specialValue': specialValue,
    };
  }

  /// Load from local storage in json format
  factory Armour.fromJson(Map<String, dynamic> json) {
    return Armour(
      name: json['name'],
      description: json['description'],
      type: ArmourType.values.firstWhere((e) => e.name == json['type']),
      maxAP: (json['maxAP'] as num).toDouble(),
      kineticDR: (json['kineticDR'] as num).toDouble(),
      energyDR: (json['energyDR'] as num).toDouble(),
      explosiveDR: (json['explosiveDR'] as num).toDouble(),
      special: json['special'] != null
          ? ArmourSpecial.values.firstWhere((e) => e.name == json['special'])
          : null,
      specialValue: json['evasionBonus'] != null
          ? (json['evasionBonus'] as num).toDouble()
          : null,
    );
  }

  /// Constructor for the Armour class
  Armour({
    required this.name,
    required this.description,
    required this.type,
    required this.maxAP,
    required this.kineticDR,
    required this.energyDR,
    required this.explosiveDR,
    this.special = ArmourSpecial.none,
    this.specialValue,
  });
}