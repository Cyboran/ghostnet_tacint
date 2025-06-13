import 'package:ghostnet/models/weapon/weapon.dart';
import 'package:ghostnet/models/weapon/weapon_stats.dart';
import 'package:ghostnet/models/weapon/weapon_type.dart';

extension WeaponStatsExtension on WeaponStats {
  /// Converts this WeaponStats object into a Weapon instance.
  Weapon toWeapon(WeaponType type) {
    return Weapon(
      name: name,
      description: description,
      type: type,
      damageType: damageType,
      baseDamage: baseDamage,
      hitChance: hitChance,
    );
  }
}
