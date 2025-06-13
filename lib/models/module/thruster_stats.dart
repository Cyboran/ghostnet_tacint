import 'package:ghostnet/models/module/thruster_special.dart';
import 'package:ghostnet/models/module/thruster_type.dart';
import 'package:ghostnet/models/ship/ship_class.dart';

class ThrusterStats {
  final String name;
  final String description;
  final String imageAsset;
  final int initiative;
  final ThrusterSpecial bonus;
  final double? bonusValue;
  final List<ShipClass> compatibleClasses;

  const ThrusterStats({
    required this.name,
    required this.description,
    required this.imageAsset,
    required this.initiative,
    required this.bonus,
    this.bonusValue,
    required this.compatibleClasses,
  });
}

// Apply values to each of the different armour types.
const Map<ThrusterType, ThrusterStats> thrusterData = {
  ThrusterType.highVelocity: ThrusterStats(
    name: 'High-Velocity Helion',
    description: 'High-speed IVT system designed for fast ships. Grants a 10% evasion boost.',
    // DO LATER: Replace placeholder image with actual image asset
    imageAsset: 'assets/images/placeholder.png',
    initiative: 100,
    bonus: ThrusterSpecial.evasionBoost,
    bonusValue: 0.10, // 10% evasion boost
    compatibleClasses: [
      ShipClass.interceptor,
      ShipClass.corvette,
    ],
  ),
  ThrusterType.standard: ThrusterStats(
    name: 'Standard Helion',
    description: 'Balanced IVT system with a bonus weapon slot. Used by medium-class ships.',
    // DO LATER: Replace placeholder image with actual image asset
    imageAsset: 'assets/images/placeholder.png',
    initiative: 70,
    bonus: ThrusterSpecial.extraWeaponSlot,
    bonusValue: 1.0, // 1 extra weapon slot
    compatibleClasses: [
      ShipClass.cruiser,
      ShipClass.frigate,
      ShipClass.corvette,
    ],
  ),
  ThrusterType.heavyIVT: ThrusterStats(
    name: 'Heavy-Class IVT Drives',
    description: 'Stabilized drive system for larger ships. Grants +50 armour integrity.',
    // DO LATER: Replace placeholder image with actual image asset
    imageAsset: 'assets/images/placeholder.png',
    initiative: 40,
    bonus: ThrusterSpecial.bonusArmourPoints,
    bonusValue: 50.0, // +50 armour points
    compatibleClasses: [
      ShipClass.cruiser,
      ShipClass.battleship,
    ],
  ),
};