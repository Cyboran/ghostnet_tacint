// This file defines the Weapon class, which represents a weapon in the game.
// It includes properties for the name, type, base damage, and hit chance of the weapon.

import 'package:ghostnet/models/weapon/weapon_damage_type.dart';
import 'package:ghostnet/models/weapon/weapon_type.dart';

class Weapon {
  final String name;
  final String description;
  final WeaponType type;
  final WeaponDamageType damageType;
  /// Base damage of the weapon.
  final int baseDamage;
  /// Hit chance of the weapon, represented as a percentage (0-100).
  final double hitChance;
  // Further expansion could look like the following:
  // final double? critChance;
  // final String? specialEffect;

  /// Save to json format for local storage
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'type': type.name,
      'damageType': damageType.name,
      'baseDamage': baseDamage,
      'hitChance': hitChance,
    };
  }

  /// Load from local storage in json format
  factory Weapon.fromJson(Map<String, dynamic> json) {
    return Weapon(
      name: json['name'],
      description: json['description'],
      type: WeaponType.values.firstWhere((e) => e.name == json['type']),
      damageType: WeaponDamageType.values.firstWhere((e) => e.name == json['damageType']),
      baseDamage: (json['baseDamage'] as num).toInt(),
      hitChance: (json['hitChance'] as num).toDouble(),
    );
  }

  /// Constructor for the Weapon class
  Weapon({
    required this.name,
    required this.description,
    required this.type,
    required this.damageType,
    required this.baseDamage,
    required this.hitChance,
  });
}
