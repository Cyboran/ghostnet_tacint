import 'package:ghostnet/models/weapon/weapon_damage_type.dart';
import 'package:ghostnet/models/weapon/weapon_type.dart';

class WeaponStats {
  final String name;
  final String description;
  final String imageAsset;
  final WeaponDamageType damageType;
  final int baseDamage;
  final double hitChance;

  WeaponStats({
    required this.name,
    required this.description,
    required this.imageAsset,
    required this.damageType,
    required this.baseDamage,
    required this.hitChance,
  });
}

// Apply values to each of the different weapon types.
Map<WeaponType, WeaponStats> weaponData = {
  WeaponType.kineticCannon: WeaponStats(
    name: 'Kinetic Cannon',
    description: 'A solid-round cannon with moderate damage and high accuracy.',
    // DO LATER: Replace placeholder image with actual image asset
    imageAsset: 'assets/images/placeholder.png',
    damageType: WeaponDamageType.kinetic,
    baseDamage: 400,
    hitChance: 1.30,
  ),
  WeaponType.energyBeam: WeaponStats(
    name: 'Energy Beam',
    description: 'A high-precision energy weapon that fires concentrated beams of light.',
    // DO LATER: Replace placeholder image with actual image asset
    imageAsset: 'assets/images/placeholder.png',
    damageType: WeaponDamageType.energy,
    baseDamage: 300,
    hitChance: 1.10,
  ),
  WeaponType.explosiveMissile: WeaponStats(
    name: 'Explosive Missile',
    description: 'A launcher that fires guided missiles for high-impact damage.',
    // DO LATER: Replace placeholder image with actual image asset
    imageAsset: 'assets/images/placeholder.png',
    damageType: WeaponDamageType.explosive,
    baseDamage: 500,
    hitChance: 0.90,
  ),
};