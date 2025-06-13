import 'package:flutter_test/flutter_test.dart';
import 'package:ghostnet/models/module/thruster.dart';
import 'package:ghostnet/models/module/thruster_type.dart';
import 'package:ghostnet/models/module/thruster_stats.dart';
import 'package:ghostnet/models/module/thruster_extensions.dart';

void main() {
  group('Thruster Model Tests', () {
    late Thruster thruster;
    const testType = ThrusterType.standard;

    setUp(() {
      thruster = thrusterData[testType]!.toThruster(testType);
    });

    // Created thruster should have the correct values from weaponData
    test('Thruster constructed from stats has correct values', () {
      final stats = thrusterData[testType]!;

      expect(thruster.name, stats.name);
      expect(thruster.description, stats.description);
      expect(thruster.type, testType);
      expect(thruster.initiative, stats.initiative);
      expect(thruster.bonus, stats.bonus);
      expect(thruster.bonusValue, stats.bonusValue);
      expect(thruster.compatibleClasses, stats.compatibleClasses);
    });

    // Serializing should recreate the object with the same values
    test('Thruster serializes to JSON correctly', () {
      final json = thruster.toJson();

      expect(json['name'], thruster.name);
      expect(json['description'], thruster.description);
      expect(json['type'], thruster.type.name);
      expect(json['initiative'], thruster.initiative);
      expect(json['bonus'], thruster.bonus.name);
      expect(json['bonusValue'], thruster.bonusValue);
      expect(json['compatibleClasses'], thruster.compatibleClasses.map((c) => c.name).toList());
    });

    // Deserializing should recreate the object with the same values
    test('Thruster deserializes from JSON correctly', () {
      final json = thruster.toJson();
      final fromJson = Thruster.fromJson(json);

      expect(fromJson.name, thruster.name);
      expect(fromJson.type, thruster.type);
      expect(fromJson.initiative, thruster.initiative);
      expect(fromJson.bonus, thruster.bonus);
      expect(fromJson.bonusValue, thruster.bonusValue);
      expect(fromJson.compatibleClasses, thruster.compatibleClasses);
    });

    // Serialization and deserialization should keep the data intact
    test('Round-trip (toJson → fromJson) preserves data', () {
      final roundTripped = Thruster.fromJson(thruster.toJson());
      expect(roundTripped.toJson(), thruster.toJson());
    });
  });
}
