import 'package:ghostnet/models/defence/hull_type.dart';
import 'package:ghostnet/models/defence/armour_type.dart';

// This file contains the data for the different hull types in the game.
class HullStats {
  final String name;
  final String description;
  final String imageAsset;
  final double maxHP;
  final double evasion;
  final double kineticDR;
  final double energyDR;
  final double explosiveDR;
  final List<ArmourType> compatibleArmours;

  const HullStats({
    required this.name,
    required this.description,
    required this.imageAsset,
    required this.maxHP,
    required this.evasion,
    required this.kineticDR,
    required this.energyDR,
    required this.explosiveDR,
    required this.compatibleArmours,
  });
}

// Apply values to each of the different hull types.
const Map<HullType, HullStats> hullData = {
  HullType.siegeplate: HullStats(
    name: 'Siegeplate',
    description: 'Heavy hull designed for absorbing sustained fire. Compatible with hardened plating.',
    // DO LATER: Replace placeholder image with actual image asset
    imageAsset: 'assets/images/placeholder.png',
    maxHP: 400,
    evasion: 0.05, // 5%
    kineticDR: 0.7,
    energyDR: 0.7,
    explosiveDR: 0.7,
    compatibleArmours: [
      ArmourType.hybridforge,
      ArmourType.ironshroud,
      ArmourType.lera,
    ],
  ),
  HullType.aurasteel: HullStats(
    name: 'Aurasteel',
    description: 'Balanced hull with moderate evasion and versatile plating options.',
    // DO LATER: Replace placeholder image with actual image asset
    imageAsset: 'assets/images/placeholder.png',
    maxHP: 250,
    evasion: 0.20, // 20%
    kineticDR: 0.85,
    energyDR: 0.85,
    explosiveDR: 1.0,
    compatibleArmours: [
      ArmourType.hybridforge,
      ArmourType.aetherglint,
      ArmourType.ironshroud,
    ],
  ),
  HullType.ionWard: HullStats(
    name: 'Ion-Ward',
    description: 'Hull optimized for energy resistance. Slightly heavier than Aurasteel.',
    // DO LATER: Replace placeholder image with actual image asset
    imageAsset: 'assets/images/placeholder.png',
    maxHP: 300,
    evasion: 0.15, // 15%
    kineticDR: 1.0,
    energyDR: 0.75,
    explosiveDR: 1.0,
    compatibleArmours: [
      ArmourType.hybridforge,
      ArmourType.aetherglint,
      ArmourType.lera,
    ],
  ),
  HullType.voidframe: HullStats(
    name: 'Voidframe',
    description: 'Stealth-optimized hull with extreme evasion and light armor compatibility.',
    // DO LATER: Replace placeholder image with actual image asset
    imageAsset: 'assets/images/placeholder.png',
    maxHP: 180,
    evasion: 0.40, // 40%
    kineticDR: 1.0,
    energyDR: 1.0,
    explosiveDR: 1.0,
    compatibleArmours: [
      ArmourType.wraithskin,
      ArmourType.aetherglint,
      ArmourType.ironshroud,
    ],
  ),
};
