import 'package:flutter_test/flutter_test.dart';
import 'package:ghostnet/models/defence/shield.dart';
import 'package:ghostnet/models/defence/shield_type.dart';
import 'package:ghostnet/models/defence/shield_stats.dart';
import 'package:ghostnet/models/defence/shield_extensions.dart';

void main() {
  group('Shield Model Tests', () {
    late Shield shield;

    setUp(() {
      shield = shieldData[ShieldType.aegis]!.toShield(ShieldType.aegis);
    });

    // Created shield should initialize with correct static values
    test('Initializes with correct values', () {
      expect(shield.maxSP, shieldData[ShieldType.aegis]!.maxSP);
      expect(shield.kineticDR, shieldData[ShieldType.aegis]!.kineticDR);
      expect(shield.energyDR, shieldData[ShieldType.aegis]!.energyDR);
      expect(shield.explosiveDR, shieldData[ShieldType.aegis]!.explosiveDR);
    });

    // Serialization and deserialization should keep the data intact
    test('Serializes to and from JSON correctly', () {
      final json = shield.toJson();
      final fromJson = Shield.fromJson(json);

      expect(fromJson.name, shield.name);
      expect(fromJson.description, shield.description);
      expect(fromJson.type, shield.type);
      expect(fromJson.maxSP, shield.maxSP);
      expect(fromJson.kineticDR, shield.kineticDR);
      expect(fromJson.energyDR, shield.energyDR);
      expect(fromJson.explosiveDR, shield.explosiveDR);
    });
  });
}
