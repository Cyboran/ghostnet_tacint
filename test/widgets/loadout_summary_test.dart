import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghostnet/models/profile/captain.dart';
import 'package:ghostnet/models/ship/ship.dart';
import 'package:ghostnet/models/ship/ship_class.dart';
import 'package:ghostnet/models/defence/armour_stats.dart';
import 'package:ghostnet/models/defence/armour_extensions.dart';
import 'package:ghostnet/models/defence/armour_type.dart';
import 'package:ghostnet/models/defence/hull_stats.dart';
import 'package:ghostnet/models/defence/hull_extensions.dart';
import 'package:ghostnet/models/defence/hull_type.dart';
import 'package:ghostnet/models/defence/shield_stats.dart';
import 'package:ghostnet/models/defence/shield_extensions.dart';
import 'package:ghostnet/models/defence/shield_type.dart';
import 'package:ghostnet/models/module/thruster_stats.dart';
import 'package:ghostnet/models/module/thruster_extensions.dart';
import 'package:ghostnet/models/module/thruster_type.dart';
import 'package:ghostnet/models/weapon/weapon_stats.dart';
import 'package:ghostnet/models/weapon/weapon_extensions.dart';
import 'package:ghostnet/models/weapon/weapon_type.dart';
import 'package:ghostnet/widgets/loadout_summary.dart';

void main() {
  // Build a mock ship using real data maps
  final testShip = Ship(
    id: 'test-001',
    name: 'Test Crusier',
    captainId: 'cap-01',
    shipImagePath: '',
    shipClass: ShipClass.cruiser,
    hull: hullData[HullType.siegeplate]!.toHull(HullType.siegeplate),
    armour: armourData[ArmourType.ironshroud]!.toArmour(ArmourType.ironshroud),
    shield: shieldData[ShieldType.aegis]!.toShield(ShieldType.aegis),
    thruster: thrusterData[ThrusterType.standard]!.toThruster(ThrusterType.standard),
    weapons: [
      weaponData[WeaponType.energyBeam]!.toWeapon(WeaponType.energyBeam),
    ],
    captain: Captain(
      id: 'cap-01',
      username: 'testuser',
      password: 'secure',
      name: 'Captain Rion',
      title: 'Warden of the Void',
      faction: 'CyberFleet',
      profileImagePath: '',
    ),
  );

  // Display the LoadoutSummary widget and check if it shows the ship name and stats correctly
  testWidgets('Displays ship name and stats', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LoadoutSummary(loadout: testShip),
        ),
      ),
    );

    expect(find.text('Summary of Selected Loadout'), findsOneWidget);
    expect(find.textContaining('Currently showing: ${testShip.name}'), findsOneWidget);
    expect(find.textContaining('Hull: ${testShip.hull.name}'), findsOneWidget);
    expect(find.textContaining('Armour: ${testShip.armour.name}'), findsOneWidget);
    expect(find.textContaining('Shield: ${testShip.shield.name}'), findsOneWidget);
    expect(find.textContaining('Thruster: ${testShip.thruster.name}'), findsOneWidget);
    expect(find.text(testShip.weapons.first.name), findsOneWidget);
  });

  // Tapping the "Edit Loadout" button should navigate to the ship builder screen with the ship loadout as an argument
  testWidgets('Tapping Edit Loadout navigates to /builder with loadout as argument', (WidgetTester tester) async {
    Object? passedArgument;

    await tester.pumpWidget(
      MaterialApp(
        onGenerateRoute: (settings) {
          if (settings.name == '/builder') {
            passedArgument = settings.arguments;
            return MaterialPageRoute(builder: (_) => const Scaffold(body: Text('Builder')));
          }
          return null;
        },
        home: Scaffold(
          body: LoadoutSummary(loadout: testShip),
        ),
      ),
    );

    // Find and tap the "Edit Loadout" button
    await tester.tap(find.text('Edit Loadout'));
    await tester.pumpAndSettle();

    // Check if the passed argument is a Ship object and matches the test ship
    expect(passedArgument, isA<Ship>());
    expect((passedArgument as Ship).name, equals(testShip.name));
    expect(find.text('Builder'), findsOneWidget);
  });
}