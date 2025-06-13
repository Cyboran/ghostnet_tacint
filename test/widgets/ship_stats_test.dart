import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghostnet/models/defence/armour.dart';
import 'package:ghostnet/models/defence/armour_stats.dart';
import 'package:ghostnet/models/defence/hull.dart';
import 'package:ghostnet/models/defence/hull_stats.dart';
import 'package:ghostnet/models/defence/shield.dart';
import 'package:ghostnet/models/defence/shield_stats.dart';
import 'package:ghostnet/models/module/thruster.dart';
import 'package:ghostnet/models/module/thruster_stats.dart';
import 'package:ghostnet/widgets/ship_stats.dart';
import 'package:ghostnet/models/defence/hull_extensions.dart';
import 'package:ghostnet/models/defence/armour_extensions.dart';
import 'package:ghostnet/models/defence/shield_extensions.dart';
import 'package:ghostnet/models/module/thruster_extensions.dart';
import 'package:ghostnet/models/weapon/weapon.dart';
import 'package:ghostnet/models/weapon/weapon_type.dart';
import 'package:ghostnet/models/weapon/weapon_stats.dart';
import 'package:ghostnet/models/defence/hull_type.dart';
import 'package:ghostnet/models/defence/armour_type.dart';
import 'package:ghostnet/models/defence/shield_type.dart';
import 'package:ghostnet/models/module/thruster_type.dart';

void main() {
  group('ShipStatsWidget', () {
    late final Hull hull;
    late final Armour armour;
    late final Shield shield;
    late final Thruster thruster;
    late final Weapon weapon1;
    late final Weapon weapon2;

    setUpAll(() {
      hull = hullData[HullType.siegeplate]!.toHull(HullType.siegeplate);
      armour = armourData[ArmourType.ironshroud]!.toArmour(ArmourType.ironshroud);
      shield = shieldData[ShieldType.aegis]!.toShield(ShieldType.aegis);
      thruster = thrusterData[ThrusterType.standard]!.toThruster(ThrusterType.standard);

      final weaponStats1 = weaponData[WeaponType.kineticCannon]!;
      weapon1 = Weapon(
        name: weaponStats1.name,
        description: weaponStats1.description,
        type: WeaponType.kineticCannon,
        damageType: weaponStats1.damageType,
        baseDamage: weaponStats1.baseDamage,
        hitChance: weaponStats1.hitChance,
      );

      final weaponStats2 = weaponData[WeaponType.energyBeam]!;
      weapon2 = Weapon(
        name: weaponStats2.name,
        description: weaponStats2.description,
        type: WeaponType.energyBeam,
        damageType: weaponStats2.damageType,
        baseDamage: weaponStats2.baseDamage,
        hitChance: weaponStats2.hitChance,
      );
    });

    // Render the widget with full module data and check if it displays correctly
    testWidgets('renders correctly with full module data', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShipStatsWidget(
              hull: hull,
              armour: armour,
              shield: shield,
              thruster: thruster,
              weapons: [weapon1, weapon2],
            ),
          ),
        ),
      );

      expect(find.textContaining('Hull: ${hull.name}'), findsOneWidget);
      expect(find.textContaining('HP: ${hull.maxHP.toStringAsFixed(2)}'), findsOneWidget);
      expect(find.textContaining('Armour: ${armour.name}'), findsOneWidget);
      expect(find.textContaining('AP: ${armour.maxAP.toStringAsFixed(2)}'), findsOneWidget);
      expect(find.textContaining('Shield: ${shield.name}'), findsOneWidget);
      expect(find.textContaining('SP: ${shield.maxSP.toStringAsFixed(2)}'), findsOneWidget);
      expect(find.textContaining('Thruster: ${thruster.name}'), findsOneWidget);
      expect(find.textContaining('Initiative: ${thruster.initiative}'), findsOneWidget);
      expect(find.text('Weapons'), findsOneWidget);
      expect(find.text(weapon1.name), findsOneWidget);
      expect(find.text(weapon2.name), findsOneWidget);
    });

    // Render the widget with partial module data and check if it displays correctly
    testWidgets('renders fallback when modules are missing', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShipStatsWidget(
              hull: null,
              armour: null,
              shield: null,
              thruster: null,
              weapons: [],
            ),
          ),
        ),
      );

      expect(find.textContaining('Hull: —'), findsOneWidget);
      expect(find.textContaining('Armour: —'), findsOneWidget);
      expect(find.textContaining('Shield: —'), findsOneWidget);
      expect(find.textContaining('Thruster: —'), findsOneWidget);
      expect(find.text('No weapons equipped'), findsOneWidget);
    });
  });
}
