import 'package:ghostnet/models/defence/armour_special.dart';
import 'armour_type.dart';

// This file contains the data for the different types of armour in the game.
class ArmourStats {
  final String name;
  final String description;
  final String imageAsset;
  final double maxAP;
  final double kineticDR;
  final double energyDR;
  final double explosiveDR;
  final ArmourSpecial special;
  final double? specialValue;

  const ArmourStats({
    required this.name,
    required this.description,
    required this.imageAsset,
    required this.maxAP,
    required this.kineticDR,
    required this.energyDR,
    required this.explosiveDR,
    this.special = ArmourSpecial.none,
    this.specialValue,
  });
}

// Apply values to each of the different armour types.
const Map<ArmourType, ArmourStats> armourData = {
  ArmourType.ironshroud: ArmourStats(
    name: 'Ironshroud',
    description: 'A hull plating that provides standard protection against kinetic weaponry.',
    // DO LATER: Replace placeholder image with actual image asset
    imageAsset: 'assets/images/placeholder.png',
    maxAP: 100,
    kineticDR: 0.7,
    energyDR: 1.0,
    explosiveDR: 1.0,
  ),
  ArmourType.lera: ArmourStats(
    name: 'LERA (Krill)',
    description: 'A hull plating that provides standard protection against explosive weaponry.',
    // DO LATER: Replace placeholder image with actual image asset
    imageAsset: 'assets/images/placeholder.png',
    maxAP: 100,
    kineticDR: 1.0,
    energyDR: 1.0,
    explosiveDR: 0.7,
  ),
  ArmourType.aetherglint: ArmourStats(
    name: 'Aetherglint',
    description: 'A hull plating that provides standard protection against energy weaponry.',
    // DO LATER: Replace placeholder image with actual image asset
    imageAsset: 'assets/images/placeholder.png',
    maxAP: 100,
    kineticDR: 1.0,
    energyDR: 0.7,
    explosiveDR: 1.0,
  ),
  ArmourType.hybridforge: ArmourStats(
    name: 'Hybridforge',
    description: 'A hull plating that provides standard protection against all weaponry, though not as effective as specialized armour.',
    // DO LATER: Replace placeholder image with actual image asset
    imageAsset: 'assets/images/placeholder.png',
    maxAP: 120,
    kineticDR: 0.85,
    energyDR: 0.85,
    explosiveDR: 0.85,
  ),
  ArmourType.wraithskin: ArmourStats(
    name: 'Wraithskin',
    description: 'A hull plating that provides minimal protection against all weaponry, however improves the ship\'s evasion by 10%.',
    // DO LATER: Replace placeholder image with actual image asset
    imageAsset: 'assets/images/placeholder.png',
    maxAP: 80,
    kineticDR: 1.0,
    energyDR: 1.0,
    explosiveDR: 1.0,
    special: ArmourSpecial.evasionBoost,
    specialValue: 0.10, // 10% evasion bonus
  ),
};
