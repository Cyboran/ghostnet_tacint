import 'package:ghostnet/models/module/thruster.dart';
import 'package:ghostnet/models/module/thruster_stats.dart';
import 'package:ghostnet/models/module/thruster_type.dart';

extension ThrusterStatsExtension on ThrusterStats {
  /// Converts this ThrusterStats into a Thruster object with the provided type.
  Thruster toThruster(ThrusterType type) {
    return Thruster(
      name: name,
      description: description,
      type: type,
      initiative: initiative,
      bonus: bonus,
      bonusValue: bonusValue,
      compatibleClasses: compatibleClasses,
    );
  }
}
