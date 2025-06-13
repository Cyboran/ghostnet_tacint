import 'package:flutter_test/flutter_test.dart';
import 'package:ghostnet/models/defence/armour.dart';
import 'package:ghostnet/models/defence/armour_extensions.dart';
import 'package:ghostnet/models/defence/armour_stats.dart';
import 'package:ghostnet/models/defence/armour_type.dart';

void main() {
  group('Armour Model Tests', () {
    late Armour armour;

    setUp(() {
      armour = armourData[ArmourType.ironshroud]!.toArmour(ArmourType.ironshroud);
    });

    // Created armour should initialize with correct static values
    test('Initializes with correct static values', () {
      expect(armour.name, isNotEmpty);
      expect(armour.description, isNotEmpty);
      expect(armour.maxAP, greaterThan(0));
      expect(armour.kineticDR, isNonNegative);
      expect(armour.energyDR, isNonNegative);
      expect(armour.explosiveDR, isNonNegative);
    });

    // Serialization and deserialization should keep the data intact
    test('Serializes to and from JSON correctly', () {
      final json = armour.toJson();
      final fromJson = Armour.fromJson(json);

      expect(fromJson.name, armour.name);
      expect(fromJson.description, armour.description);
      expect(fromJson.type, armour.type);
      expect(fromJson.maxAP, armour.maxAP);
      expect(fromJson.kineticDR, armour.kineticDR);
      expect(fromJson.energyDR, armour.energyDR);
      expect(fromJson.explosiveDR, armour.explosiveDR);
      expect(fromJson.special, armour.special);
      expect(fromJson.specialValue, armour.specialValue);
    });
  });
}