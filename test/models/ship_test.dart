import 'package:flutter_test/flutter_test.dart';
import 'package:ghostnet/models/defence/armour_extensions.dart';
import 'package:ghostnet/models/defence/hull_extensions.dart';
import 'package:ghostnet/models/defence/shield_extensions.dart';
import 'package:ghostnet/models/module/thruster_extensions.dart';
import 'package:ghostnet/models/weapon/weapon_extensions.dart';
import 'package:uuid/uuid.dart';
import 'package:ghostnet/models/ship/ship.dart';
import 'package:ghostnet/models/ship/ship_class.dart';
import 'package:ghostnet/models/profile/captain.dart';
import 'package:ghostnet/models/defence/hull_type.dart';
import 'package:ghostnet/models/defence/hull_stats.dart';
import 'package:ghostnet/models/defence/armour_type.dart';
import 'package:ghostnet/models/defence/armour_stats.dart';
import 'package:ghostnet/models/defence/shield_type.dart';
import 'package:ghostnet/models/defence/shield_stats.dart';
import 'package:ghostnet/models/module/thruster_type.dart';
import 'package:ghostnet/models/module/thruster_stats.dart';
import 'package:ghostnet/models/weapon/weapon_type.dart';
import 'package:ghostnet/models/weapon/weapon_stats.dart';

void main() {
  group('Ship Model', () {
    late Ship ship;

    setUp(() {
      final uuid = const Uuid().v4();

      final hull = hullData[HullType.siegeplate]!.toHull(HullType.siegeplate);
      final armour = armourData[ArmourType.ironshroud]!.toArmour(ArmourType.ironshroud);
      final shield = shieldData[ShieldType.aegis]!.toShield(ShieldType.aegis);
      final thruster = thrusterData[ThrusterType.standard]!.toThruster(ThrusterType.standard);
      final weapon = weaponData[WeaponType.kineticCannon]!.toWeapon(WeaponType.kineticCannon);

      final captain = Captain(
        id: 'captain-id',
        username: 'testuser',
        password: 'secret',
        name: 'Nyx',
        title: 'Warden',
        faction: 'Syndicate',
        profileImagePath: 'assets/images/default_profile.png',
      );

      ship = Ship(
        id: uuid,
        name: 'USS Example',
        captainId: captain.id,
        shipImagePath: 'assets/images/ship_sample.png',
        shipClass: ShipClass.frigate,
        hull: hull,
        armour: armour,
        shield: shield,
        thruster: thruster,
        weapons: [weapon],
        captain: captain,
      );
    });

    // Serialization and deserialization tests to ensure the data remains intact
    test('Serializes to and from JSON correctly', () {
      final json = ship.toJson();
      final newShip = Ship.fromJson(json);

      expect(newShip.id, ship.id);
      expect(newShip.name, ship.name);
      expect(newShip.shipClass, ship.shipClass);
      expect(newShip.hull.type, ship.hull.type);
      expect(newShip.armour.type, ship.armour.type);
      expect(newShip.shield.type, ship.shield.type);
      expect(newShip.thruster.type, ship.thruster.type);
      expect(newShip.weapons.first.type, ship.weapons.first.type);
      expect(newShip.captain.username, ship.captain.username);
    });

    // The ship should be getting the correct weapon slots based on its class
    test('Calculates max weapon slots correctly', () {
      expect(ship.maxWeaponSlots, 2); // Frigate should have 2 weapon slots due to its class and thruster type
    });

    // The captain should be correctly assigned to the ship
    test('Captain is correctly assigned', () {
      expect(ship.captain.name, 'Nyx');
      expect(ship.captain.faction, 'Syndicate');
    });

    // Components of the ship should be initialized correctly
    test('Ship components contain expected static stats', () {
      expect(ship.hull.maxHP, greaterThan(0));
      expect(ship.armour.maxAP, greaterThan(0));
      expect(ship.shield.maxSP, greaterThan(0));
    });
  });
}
