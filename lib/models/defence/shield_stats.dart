import 'package:ghostnet/models/defence/shield_type.dart';

/// This file contains the data for the different types of shields in the game.
class ShieldStats {
  final String name;
  final String description;
  final String imageAsset;
  final double maxSP;
  final double kineticDR;
  final double energyDR;
  final double explosiveDR;

  const ShieldStats({
    required this.name,
    required this.description,
    required this.imageAsset,
    required this.maxSP,
    required this.kineticDR,
    required this.energyDR,
    required this.explosiveDR,
  });
}

/// Apply values to each of the different shield types.
const Map<ShieldType, ShieldStats> shieldData = {
  ShieldType.aegis: ShieldStats(
    name: 'Aegis Shield',
    description: 'Balanced shielding capable of handling all incoming damage types equally.',
    // DO LATER: Replace placeholder image with actual image asset
    imageAsset: 'assets/images/placeholder.png',
    maxSP: 400,
    kineticDR: 0.85,
    energyDR: 0.85,
    explosiveDR: 0.85,
  ),
  ShieldType.eris: ShieldStats(
    name: 'Eris Shield',
    description: 'Shielding focused on repelling energy-based attacks at the cost of kinetic resistance.',
    // DO LATER: Replace placeholder image with actual image asset
    imageAsset: 'assets/images/placeholder.png',
    maxSP: 350,
    kineticDR: 1.0,
    energyDR: 0.7,
    explosiveDR: 1.0,
  ),
  ShieldType.kras: ShieldStats(
    name: 'Kras Shield',
    description: 'Shielding best suited for absorbing kinetic-based impacts with reduced energy protection.',
    // DO LATER: Replace placeholder image with actual image asset
    imageAsset: 'assets/images/placeholder.png',
    maxSP: 350,
    kineticDR: 0.7,
    energyDR: 1.0,
    explosiveDR: 1.0,
  ),
};