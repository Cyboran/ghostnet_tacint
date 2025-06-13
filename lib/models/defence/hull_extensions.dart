import 'package:ghostnet/models/defence/hull.dart';
import 'package:ghostnet/models/defence/hull_stats.dart';
import 'package:ghostnet/models/defence/hull_type.dart';

extension HullStatsExtension on HullStats {
  /// Converts this HullStats into a Hull object with the provided type.
  Hull toHull(HullType type) {
    return Hull(
      name: name,
      description: description,
      type: type,
      maxHP: maxHP,
      evasion: evasion,
      kineticDR: kineticDR,
      energyDR: energyDR,
      explosiveDR: explosiveDR,
      compatibleArmours: compatibleArmours,
    );
  }
}
