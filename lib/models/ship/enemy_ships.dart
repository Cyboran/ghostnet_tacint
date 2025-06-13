import 'dart:math';
import 'package:ghostnet/models/ship/ship.dart';
import 'package:ghostnet/models/ship/ship_class.dart';
import 'package:ghostnet/models/defence/hull_extensions.dart';
import 'package:ghostnet/models/defence/hull_stats.dart';
import 'package:ghostnet/models/defence/hull_type.dart';
import 'package:ghostnet/models/defence/armour_extensions.dart';
import 'package:ghostnet/models/defence/armour_stats.dart';
import 'package:ghostnet/models/defence/armour_type.dart';
import 'package:ghostnet/models/defence/shield_extensions.dart';
import 'package:ghostnet/models/defence/shield_stats.dart';
import 'package:ghostnet/models/defence/shield_type.dart';
import 'package:ghostnet/models/module/thruster_extensions.dart';
import 'package:ghostnet/models/module/thruster_stats.dart';
import 'package:ghostnet/models/module/thruster_type.dart';
import 'package:ghostnet/models/weapon/weapon_extensions.dart';
import 'package:ghostnet/models/weapon/weapon_stats.dart';
import 'package:ghostnet/models/weapon/weapon_type.dart';
import 'package:ghostnet/models/profile/captain.dart';

final List<Ship> enemyShips = [
  // DO LATER: Update the enemy ships with proper images
  // Enemy ship #1
  Ship(
    id: 'enemy-001',
    name: 'Crimson Reaver',
    captainId: 'unknown',
    shipImagePath: 'assets/images/enemy_ships/crimson_reaver.png',
    shipClass: ShipClass.frigate,
    hull: hullData[HullType.siegeplate]!.toHull(HullType.siegeplate),
    armour: armourData[ArmourType.ironshroud]!.toArmour(ArmourType.ironshroud),
    shield: shieldData[ShieldType.aegis]!.toShield(ShieldType.aegis),
    thruster: thrusterData[ThrusterType.standard]!.toThruster(ThrusterType.standard),
    weapons: [
      weaponData[WeaponType.kineticCannon]!.toWeapon(WeaponType.kineticCannon),
    ],
    captain: Captain(
      id: 'unknown',
      username: 'unknown',
      password: 'unknown',
      name: 'Raider AI',
      title: 'Reaver Command Node',
      faction: 'Void Corsairs',
      profileImagePath: 'assets/images/default_profile.png',
    ),
  ),
  // Enemy ship #2
  Ship(
    id: 'enemy-002',
    name: 'Spectral Vengeance',
    captainId: 'unknown',
    shipImagePath: 'assets/images/enemy_ships/spectral_vengeance.png',
    shipClass: ShipClass.cruiser,
    hull: hullData[HullType.ionWard]!.toHull(HullType.ionWard),
    armour: armourData[ArmourType.aetherglint]!.toArmour(ArmourType.aetherglint),
    shield: shieldData[ShieldType.aegis]!.toShield(ShieldType.aegis),
    thruster: thrusterData[ThrusterType.highVelocity]!.toThruster(ThrusterType.highVelocity),
    weapons: [
      weaponData[WeaponType.energyBeam]!.toWeapon(WeaponType.energyBeam),
      weaponData[WeaponType.kineticCannon]!.toWeapon(WeaponType.kineticCannon),
    ],
    captain: Captain(
      id: 'unknown',
      username: 'unknown',
      password: 'unknown',
      name: 'Wraith AI',
      title: 'Apparition of Retribution',
      faction: 'Phantom Armada',
      profileImagePath: 'assets/images/default_profile.png',
    ),
  ),
  // Enemy ship #3
  Ship(
    id: 'enemy-003',
    name: 'Oblivion Fang',
    captainId: 'unknown',
    shipImagePath: 'assets/images/enemy_ships/oblivion_fang.png',
    shipClass: ShipClass.battleship,
    hull: hullData[HullType.aurasteel]!.toHull(HullType.aurasteel),
    armour: armourData[ArmourType.lera]!.toArmour(ArmourType.lera),
    shield: shieldData[ShieldType.eris]!.toShield(ShieldType.eris),
    thruster: thrusterData[ThrusterType.heavyIVT]!.toThruster(ThrusterType.heavyIVT),
    weapons: [
      weaponData[WeaponType.energyBeam]!.toWeapon(WeaponType.energyBeam),
      weaponData[WeaponType.explosiveMissile]!.toWeapon(WeaponType.explosiveMissile),
    ],
    captain: Captain(
      id: 'unknown',
      username: 'unknown',
      password: 'unknown',
      name: 'Null Commander',
      title: 'Harbinger of the Deep Black',
      faction: 'Echo Remnant',
      profileImagePath: 'assets/images/default_profile.png',
    ),
  ),
];

// Picks a random enemy ship for battle
Ship getRandomEnemyShip() {
  final random = Random();
  return enemyShips[random.nextInt(enemyShips.length)];
}