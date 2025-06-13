// This file defines the Thruster class, which represents a thruster module in the game.
// It includes properties such as name, initiative, bonus, and compatible ship classes.

import 'package:ghostnet/models/module/thruster_special.dart';
import 'package:ghostnet/models/module/thruster_type.dart';
import 'package:ghostnet/models/ship/ship_class.dart';

class Thruster {
  final String name;
  final String description;
  final ThrusterType type;
  /// The initiative value of the thruster, which affects the ship's speed and maneuverability.
  final int initiative;
  /// The bonus provided by the thruster, which can enhance the ship's performance in various ways.
  final ThrusterSpecial bonus;
  final double? bonusValue;
  /// A list of ship classes that are compatible with this thruster.
  final List<ShipClass> compatibleClasses;

  /// Save to json format for local storage
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'type': type.name,
      'initiative': initiative,
      'bonus': bonus.name,
      'bonusValue': bonusValue,
      'compatibleClasses': compatibleClasses.map((c) => c.name).toList(),
    };
  }

  /// Load from local storage in json format
  factory Thruster.fromJson(Map<String, dynamic> json) {
    return Thruster(
      name: json['name'],
      description: json['description'],
      type: ThrusterType.values.firstWhere((e) => e.name == json['type']),
      initiative: json['initiative'],
      bonus: ThrusterSpecial.values.firstWhere((e) => e.name == json['bonus']),
      bonusValue: (json['bonusValue'] as num?)?.toDouble(),
      compatibleClasses: (json['compatibleClasses'] as List)
          .map((c) => ShipClass.values.firstWhere((e) => e.name == c))
          .toList(),
    );
  }

  /// Constructor for the Thruster class.
  Thruster({
    required this.name,
    required this.description,
    required this.type,
    required this.initiative,
    required this.bonus,
    this.bonusValue,
    required this.compatibleClasses,
  });
}
