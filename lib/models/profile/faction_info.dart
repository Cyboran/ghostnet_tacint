import 'package:ghostnet/models/profile/faction_type.dart';

class FactionInfo {
  final String name;
  final String description;
  // final String iconAssetPath; 
  // Future expansion: faction bonuses, special abilities, lore, etc.

  const FactionInfo({
    required this.name,
    required this.description,
    // this.iconAssetPath = 'assets/images/factions/default.png',
  });
}

const Map<FactionType, FactionInfo> factionData = {
  FactionType.syndicate: FactionInfo(
    name: 'Syndicate',
    description: 'A decentralized faction of black-market traders, AI smugglers, and rogue captains operating in the shadows of the galactic net.',
    // iconAssetPath: 'assets/images/factions/syndicate.png',
  ),
  FactionType.coalition: FactionInfo(
    name: 'Coalition',
    description: 'A military-industrial alliance that prizes order, precision, and firepower. Known for elite training and standardized fleets.',
    // iconAssetPath: 'assets/images/factions/coalition.png',
  ),
  FactionType.dominion: FactionInfo(
    name: 'Dominion',
    description: 'A technocratic empire that rules through control of information, advanced AI networks, and post-human command structures.',
    // iconAssetPath: 'assets/images/factions/dominion.png',
  ),
};
