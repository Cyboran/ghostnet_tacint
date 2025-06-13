// This file defines the Ship class, which represents a ship in the game.
// It includes properties for the ship's ID, name, class, hull, armor, shield, thruster, weapons, and captain.

import 'package:ghostnet/models/defence/armour.dart';
import 'package:ghostnet/models/module/thruster_special.dart';
import 'package:ghostnet/models/module/thruster_stats.dart';
import 'package:ghostnet/models/profile/captain.dart';
import 'package:ghostnet/models/defence/hull.dart';
import 'package:ghostnet/models/defence/shield.dart';
import 'package:ghostnet/models/ship/ship_class.dart';
import 'package:ghostnet/models/module/thruster.dart';
import 'package:ghostnet/models/weapon/weapon.dart';

class Ship {
  final String id;
  /// The name of the ship.
  final String name;
  /// The ID of the captain of the ship.
  final String captainId;
  /// The path to the ship's image.
  final String shipImagePath;
  /// The class of the ship.
  final ShipClass shipClass;
  /// The hull of the ship.
  final Hull hull;
  /// The armor of the ship.
  final Armour armour;
  /// The shield of the ship.
  final Shield shield;
  /// The thruster of the ship.
  final Thruster thruster;
  /// The weapons of the ship.
  final List<Weapon> weapons;
  /// The captain of the ship.
  final Captain captain;

  /// Static map defining how many weapon slots each ship class supports.
  static const Map<ShipClass, int> weaponSlotsPerClass = {
    ShipClass.interceptor: 1,
    ShipClass.corvette: 1,
    ShipClass.frigate: 1,
    ShipClass.cruiser: 2,
    ShipClass.battleship: 2,
  };

  /// Save to json format for local storage
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'captainId': captainId,
    'shipImagePath': shipImagePath,
    'shipClass': shipClass.name,
    'hull': hull.toJson(),
    'armour': armour.toJson(),
    'shield': shield.toJson(),
    'thruster': thruster.toJson(),
    'weapons': weapons.map((w) => w.toJson()).toList(),
    'captain': captain.toJson(),
  };

  /// Load from local storage in json format
  factory Ship.fromJson(Map<String, dynamic> json) {
    return Ship(
      id: json['id'],
      name: json['name'],
      captainId: json['captainId'],
      shipImagePath: json['shipImagePath'],
      shipClass: ShipClass.values.firstWhere((e) => e.name == json['shipClass']),
      hull: Hull.fromJson(json['hull']),
      armour: Armour.fromJson(json['armour']),
      shield: Shield.fromJson(json['shield']),
      thruster: Thruster.fromJson(json['thruster']),
      weapons: (json['weapons'] as List)
          .map((w) => Weapon.fromJson(w))
          .toList(),
      captain: Captain.fromJson(json['captain']),
    );
  }

  Ship({
    required this.id,
    required this.name,
    required this.captainId,
    required this.shipImagePath,
    required this.shipClass,
    required this.hull,
    required this.armour,
    required this.shield,
    required this.thruster,
    required this.weapons,
    required this.captain,
  });
  
  /// Returns the maximum number of weapon slots available for the ship class.
  int? get maxWeaponSlots {
    final thrusterStats = thrusterData[thruster.type];
    int? baseSlots = weaponSlotsPerClass[shipClass];

    if (thrusterStats?.bonus == ThrusterSpecial.extraWeaponSlot) {
      baseSlots = (baseSlots ?? 0) + (thrusterStats?.bonusValue?.toInt() ?? 0);
    }

    return baseSlots;
  }

}
