import 'package:flutter_test/flutter_test.dart';
import 'package:ghostnet/models/weapon/weapon.dart';
import 'package:ghostnet/models/weapon/weapon_type.dart';
import 'package:ghostnet/models/weapon/weapon_stats.dart';
import 'package:ghostnet/models/weapon/weapon_extensions.dart';

void main() {
  group('Weapon Model Tests (from weapon stats)', () {
    late Weapon weapon;
    final WeaponType selectedType = WeaponType.kineticCannon;

    setUp(() {
      weapon = weaponData[selectedType]!.toWeapon(selectedType);
    });

    // Created weapon should have the correct values from weaponData
    test('Weapon created from stats has correct values', () {
      final stats = weaponData[selectedType]!;

      expect(weapon.name, stats.name);
      expect(weapon.description, stats.description);
      expect(weapon.type, selectedType);
      expect(weapon.damageType, stats.damageType);
      expect(weapon.baseDamage, stats.baseDamage);
      expect(weapon.hitChance, stats.hitChance);
    });

    // Serializing should recreate the object with the same values
    test('Weapon serializes to JSON correctly', () {
      final json = weapon.toJson();

      expect(json['name'], weapon.name);
      expect(json['description'], weapon.description);
      expect(json['type'], weapon.type.name);
      expect(json['damageType'], weapon.damageType.name);
      expect(json['baseDamage'], weapon.baseDamage);
      expect(json['hitChance'], weapon.hitChance);
    });

    // Deserializing should recreate the object with the same values
    test('Weapon deserializes from JSON correctly', () {
      final json = weapon.toJson();
      final deserialized = Weapon.fromJson(json);

      expect(deserialized.name, weapon.name);
      expect(deserialized.description, weapon.description);
      expect(deserialized.type, weapon.type);
      expect(deserialized.damageType, weapon.damageType);
      expect(deserialized.baseDamage, weapon.baseDamage);
      expect(deserialized.hitChance, weapon.hitChance);
    });

    // Serialization and deserialization should keep the data intact
    test('Round-trip (toJson/fromJson) preserves data', () {
      final json = weapon.toJson();
      final roundTripped = Weapon.fromJson(json);

      expect(roundTripped.toJson(), json);
    });
  });
}