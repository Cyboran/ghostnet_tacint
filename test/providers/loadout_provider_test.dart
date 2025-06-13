import 'package:flutter_test/flutter_test.dart';
import 'package:ghostnet/models/ship/ship.dart';
import 'package:ghostnet/models/ship/ship_class.dart';
import 'package:ghostnet/models/weapon/weapon.dart';
import 'package:ghostnet/models/weapon/weapon_type.dart';
import 'package:ghostnet/models/weapon/weapon_stats.dart';
import 'package:ghostnet/models/profile/captain.dart';
import 'package:ghostnet/models/defence/hull_type.dart';
import 'package:ghostnet/models/defence/hull.dart';
import 'package:ghostnet/models/defence/hull_stats.dart';
import 'package:ghostnet/models/defence/armour_type.dart';
import 'package:ghostnet/models/defence/armour.dart';
import 'package:ghostnet/models/defence/armour_stats.dart';
import 'package:ghostnet/models/defence/shield_type.dart';
import 'package:ghostnet/models/defence/shield.dart';
import 'package:ghostnet/models/defence/shield_stats.dart';
import 'package:ghostnet/models/module/thruster_type.dart';
import 'package:ghostnet/models/module/thruster.dart';
import 'package:ghostnet/models/module/thruster_stats.dart';
import 'package:ghostnet/providers/loadout_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('LoadoutProvider Tests', () {
    late LoadoutProvider provider;
    late Ship mockShip;
    const captainId = 'test-captain-id';

    // Set up a fresh provider and mock ship for each test
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      provider = LoadoutProvider();

      // Use real stats data for the mock ship
      final uuid = const Uuid().v4();
      final hullStats = hullData[HullType.siegeplate]!;
      final armourStats = armourData[ArmourType.ironshroud]!;
      final shieldStats = shieldData[ShieldType.aegis]!;
      final thrusterStats = thrusterData[ThrusterType.standard]!;

      // Create the mock ship
      mockShip = Ship(
        id: uuid,
        name: 'Test Ship',
        captainId: captainId,
        shipImagePath: 'assets/images/ship_sample.gif',
        shipClass: ShipClass.frigate,
        hull: Hull(
          name: hullStats.name,
          description: hullStats.description,
          type: HullType.siegeplate,
          maxHP: hullStats.maxHP,
          evasion: hullStats.evasion,
          kineticDR: hullStats.kineticDR,
          energyDR: hullStats.energyDR,
          explosiveDR: hullStats.explosiveDR,
          compatibleArmours: hullStats.compatibleArmours,
        ),
        armour: Armour(
          name: armourStats.name,
          description: armourStats.description,
          type: ArmourType.ironshroud,
          maxAP: armourStats.maxAP,
          kineticDR: armourStats.kineticDR,
          energyDR: armourStats.energyDR,
          explosiveDR: armourStats.explosiveDR,
          special: armourStats.special,
        ),
        shield: Shield(
          name: shieldStats.name,
          description: shieldStats.description,
          type: ShieldType.aegis,
          maxSP: shieldStats.maxSP,
          kineticDR: shieldStats.kineticDR,
          energyDR: shieldStats.energyDR,
          explosiveDR: shieldStats.explosiveDR,
        ),
        thruster: Thruster(
          name: thrusterStats.name,
          description: thrusterStats.description,
          type: ThrusterType.standard,
          initiative: thrusterStats.initiative,
          bonus: thrusterStats.bonus,
          bonusValue: thrusterStats.bonusValue,
          compatibleClasses: thrusterStats.compatibleClasses,
        ),
        weapons: [
          Weapon(
            name: weaponData[WeaponType.kineticCannon]!.name,
            description: weaponData[WeaponType.kineticCannon]!.description,
            type: WeaponType.kineticCannon,
            damageType: weaponData[WeaponType.kineticCannon]!.damageType,
            baseDamage: weaponData[WeaponType.kineticCannon]!.baseDamage,
            hitChance: weaponData[WeaponType.kineticCannon]!.hitChance,
          )
        ],
        captain: Captain(
          id: captainId,
          username: 'tester',
          password: 'secure',
          name: 'Test Captain',
          title: 'Warden',
          faction: 'Neutral',
          profileImagePath: 'assets/images/default_profile.png',
        ),
      );
    });

    // Adding a loadout should store it in memory
    test('Add loadout', () async {
      await provider.addLoadout(mockShip);
      expect(provider.loadouts.length, 1);
      expect(provider.loadouts.first.name, 'Test Ship');
    });

    // Loadouts for a specific captain should return the correct list of loadouts
    test('Loadouts for captain', () async {
      await provider.addLoadout(mockShip);
      final result = provider.loadoutsForCaptain(captainId);
      expect(result.length, 1);
      expect(result.first.captainId, captainId);
    });

    // Updating a loadout should modify the existing loadout in memory
    test('Update loadout', () async {
      await provider.addLoadout(mockShip);

      // Create a new ship with the same ID but different name
      final updatedShip = Ship(
        id: mockShip.id,
        name: 'Updated Ship',
        captainId: mockShip.captainId,
        shipImagePath: mockShip.shipImagePath,
        shipClass: mockShip.shipClass,
        hull: mockShip.hull,
        armour: mockShip.armour,
        shield: mockShip.shield,
        thruster: mockShip.thruster,
        weapons: mockShip.weapons,
        captain: mockShip.captain,
      );

      await provider.updateLoadout(updatedShip);

      expect(provider.loadouts.first.name, 'Updated Ship');
    });

    // Removing a loadout should delete it from memory
    test('Remove loadout', () async {
      await provider.addLoadout(mockShip);
      await provider.removeLoadout(mockShip);
      expect(provider.loadouts.isEmpty, true);
    });

    // Clearing all loadouts should empty the list of loadouts
    test('Clear all loadouts', () async {
      await provider.addLoadout(mockShip);
      await provider.clearAll();
      expect(provider.loadouts.isEmpty, true);
    });

    // Saved loadouts should be retrievable from storage
    test('Load from storage', () async {
      await provider.addLoadout(mockShip);
      final newProvider = LoadoutProvider();
      await newProvider.loadFromStorage();

      expect(newProvider.loadouts.length, 1);
      expect(newProvider.loadouts.first.name, 'Test Ship');
    });

    // Deleting a loadout by ID should remove it from memory
    test('Delete loadout by ID', () async {
      await provider.addLoadout(mockShip);
      await provider.deleteLoadout(mockShip.id);
      expect(provider.loadouts, isEmpty);
    });
  });
}
