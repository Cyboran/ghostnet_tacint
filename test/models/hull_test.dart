import 'package:flutter_test/flutter_test.dart';
import 'package:ghostnet/models/defence/hull.dart';
import 'package:ghostnet/models/defence/hull_stats.dart';
import 'package:ghostnet/models/defence/hull_extensions.dart';
import 'package:ghostnet/models/defence/hull_type.dart';

void main() {
  group('Hull Model Tests', () {
    late Hull hull;

    setUp(() {
      hull = hullData[HullType.siegeplate]!.toHull(HullType.siegeplate);
    });

    // Created hull should initialize with correct static values
    test('Initializes with correct static values', () {
      expect(hull.name, isNotEmpty);
      expect(hull.description, isNotEmpty);
      expect(hull.maxHP, greaterThan(0));
      expect(hull.evasion, greaterThanOrEqualTo(0));
      expect(hull.kineticDR, greaterThanOrEqualTo(0));
      expect(hull.energyDR, greaterThanOrEqualTo(0));
      expect(hull.explosiveDR, greaterThanOrEqualTo(0));
      expect(hull.compatibleArmours, isNotEmpty);
    });

    // Serialization and deserialization should keep the data intact
    test('Serializes to and from JSON correctly', () {
      final json = hull.toJson();
      final fromJson = Hull.fromJson(json);

      expect(fromJson.name, hull.name);
      expect(fromJson.description, hull.description);
      expect(fromJson.type, hull.type);
      expect(fromJson.maxHP, hull.maxHP);
      expect(fromJson.evasion, hull.evasion);
      expect(fromJson.kineticDR, hull.kineticDR);
      expect(fromJson.energyDR, hull.energyDR);
      expect(fromJson.explosiveDR, hull.explosiveDR);
      expect(fromJson.compatibleArmours, hull.compatibleArmours);
    });
  });
}
