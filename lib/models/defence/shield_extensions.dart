import 'package:ghostnet/models/defence/shield.dart';
import 'package:ghostnet/models/defence/shield_stats.dart';
import 'package:ghostnet/models/defence/shield_type.dart';

extension ShieldStatsExtension on ShieldStats {
  /// Converts this ShieldStats into a Shield object with the provided type.
  Shield toShield(ShieldType type) {
    return Shield(
      name: name,
      description: description,
      type: type,
      maxSP: maxSP,
      kineticDR: kineticDR,
      energyDR: energyDR,
      explosiveDR: explosiveDR,
    );
  }
}
