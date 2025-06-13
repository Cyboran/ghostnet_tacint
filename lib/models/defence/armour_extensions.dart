import 'package:ghostnet/models/defence/armour.dart';
import 'package:ghostnet/models/defence/armour_stats.dart';
import 'package:ghostnet/models/defence/armour_type.dart';

extension ArmourStatsExtension on ArmourStats {
  /// Converts this ArmourStats into a Armour object with the provided type.
  Armour toArmour(ArmourType type) {
    return Armour(
      name: name,
      description: description,
      type: type,
      maxAP: maxAP,
      kineticDR: kineticDR,
      energyDR: energyDR,
      explosiveDR: explosiveDR,
      special: special,
      specialValue: specialValue,
    );
  }
}
