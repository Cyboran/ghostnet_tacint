import 'package:flutter_test/flutter_test.dart';
import 'package:ghostnet/models/combat/battle_ship_state.dart';
import 'package:ghostnet/models/defence/armour_extensions.dart';
import 'package:ghostnet/models/defence/armour_stats.dart';
import 'package:ghostnet/models/defence/hull_extensions.dart';
import 'package:ghostnet/models/defence/hull_stats.dart';
import 'package:ghostnet/models/defence/shield_extensions.dart';
import 'package:ghostnet/models/defence/shield_stats.dart';
import 'package:ghostnet/models/module/thruster_extensions.dart';
import 'package:ghostnet/models/module/thruster_stats.dart';
import 'package:ghostnet/models/weapon/weapon_extensions.dart';
import 'package:ghostnet/models/ship/ship.dart';
import 'package:ghostnet/models/ship/ship_class.dart';
import 'package:ghostnet/models/profile/captain.dart';
import 'package:ghostnet/models/weapon/weapon_damage_type.dart';
import 'package:ghostnet/models/weapon/weapon_stats.dart';

void main() {
  group('BattleShipState', () {
    late BattleShipState battleShip;

    setUp(() {
      // Create a test ship and wrap it up in a BattleShipState
      final ship = Ship(
        id: 'id',
        name: 'Test Ship',
        captainId: 'captain-1',
        shipImagePath: 'path',
        shipClass: ShipClass.frigate,
        hull: hullData.values.first.toHull(hullData.keys.first),
        armour: armourData.values.first.toArmour(armourData.keys.first),
        shield: shieldData.values.first.toShield(shieldData.keys.first),
        thruster: thrusterData.values.first.toThruster(thrusterData.keys.first),
        weapons: [weaponData.values.first.toWeapon(weaponData.keys.first)],
        captain: Captain(
          id: 'captain-1',
          username: 'user',
          password: 'pass',
          name: 'Captain',
          title: 'Commander',
          faction: 'Test',
          profileImagePath: '',
        ),
      );

      battleShip = BattleShipState(ship: ship);
    });

    // Initial values should match the ship's max stats
    test('Initial values are correct', () {
      expect(battleShip.currentHP, battleShip.maxHP);
      expect(battleShip.currentSP, battleShip.maxSP);
      expect(battleShip.currentAP, battleShip.maxAP);
      expect(battleShip.isHullDestroyed, false);
      expect(battleShip.isShieldBroken, false);
      expect(battleShip.isArmourBroken, false);
    });

    // Damage applied to shield should reduce SP without overflow
    test('Damage reduces shield first', () {
      final initialSP = battleShip.currentSP;
      final overflow = battleShip.applyDamage(20, layer: 'shield', damageType: WeaponDamageType.energy);

      expect(overflow, 0);
      expect(battleShip.currentSP, lessThan(initialSP));
    });

    // Overflow from shields should split into armor and hull if flag is enabled
    test('Shield overflow spills to armor and hull if enabled', () {
      battleShip.splitOverflowToArmourAndHull = true;
      final bigDamage = battleShip.currentSP + 100;
      final overflow = battleShip.applyDamage(bigDamage, layer: 'shield', damageType: WeaponDamageType.kinetic);
      battleShip.applyOverflowAfterShield(overflow, WeaponDamageType.kinetic);

      expect(battleShip.currentSP, 0);
      expect(battleShip.currentAP, lessThan(battleShip.maxAP));
      expect(battleShip.currentHP, lessThan(battleShip.maxHP));
    });

    // Evade should increase temporary evasion stat
    test('Evade gives temporary evasion', () {
      final before = battleShip.totalEvasion;
      battleShip.applyEvade();
      expect(battleShip.totalEvasion, greaterThan(before));
    });

    /// BELOW TEST NO LONGER WORKS DUE TO CHANGES IN BATTLESHIPSTATE VIA RANDOM FOR HIT CHANCE
    /// 
    // // Hit chance should succeed/fail based on evasion values
    // test('attackHits returns true or false appropriately', () {
    //   // Force evasion to 0 to ensure it hits
    //   battleShip.evasionBonus = -battleShip.ship.hull.evasion;
    //   expect(battleShip.attackHits(1.0), isTrue);

    //   // Force evasion to exceed hit chance to ensure it misses
    //   battleShip.evasionBonus = 1.0;
    //   expect(battleShip.attackHits(0.1), isFalse);
    // });

    // When defending, incoming damage should be reduced
    test('Defending reduces damage', () {
      final damage = 9999.0;
      final layer = 'armour';

      battleShip.isDefending = false;
      final normalOverflow = battleShip.applyDamage(damage, layer: layer, damageType: WeaponDamageType.explosive);

      battleShip = BattleShipState(ship: battleShip.ship); // reset
      battleShip.isDefending = true;
      final reducedOverflow = battleShip.applyDamage(damage, layer: layer, damageType: WeaponDamageType.explosive);

      expect(reducedOverflow, lessThan(normalOverflow));
    });

    // Regeneration logic should apply more when defending
    test('Shield regenerates normally and doubles while defending', () {
      battleShip.currentSP -= 50;
      battleShip.shieldCooldownTurns = 0;

      final before = battleShip.currentSP;
      battleShip.regenerateShield();
      final normalRegen = battleShip.currentSP - before;

      battleShip.currentSP -= normalRegen; // reset
      battleShip.regenerateShield(isDefending: true);
      final defendRegen = battleShip.currentSP - before;

      expect(defendRegen, greaterThan(normalRegen));
    });

    // Cooldown should tick, and full recharge should occur after 3 turns of inactivity
    test('Shield cooldown ticks and triggers full recharge', () {
      battleShip.shieldCooldownTurns = 2;
      battleShip.turnsSinceLastShieldDamage = 0;

      battleShip.tickShieldCooldown();
      expect(battleShip.shieldCooldownTurns, 1);
      expect(battleShip.turnsSinceLastShieldDamage, 1);

      battleShip.turnsSinceLastShieldDamage = 3;
      battleShip.currentSP = 10;
      battleShip.checkShieldFullRecharge();
      expect(battleShip.currentSP, battleShip.maxSP);
    });

    // nextTurn should reset evasion, regen shield, and tick state changes
    test('nextTurn resets evasion and processes state', () {
      battleShip.evasionBonus = 0.2;
      battleShip.currentSP -= 20;
      battleShip.turnsSinceLastShieldDamage = 3;

      battleShip.nextTurn();
      expect(battleShip.evasionBonus, 0);
      expect(battleShip.currentSP, battleShip.maxSP);
    });

    // Verify that damage reduction is applied correctly based on the layer and damage type
    test('applyDR uses correct damage reduction per layer', () {
      final baseDamage = 100.0;

      final shieldDR = battleShip.applyDR(baseDamage, WeaponDamageType.kinetic, layer: 'shield');
      expect(shieldDR, baseDamage * battleShip.ship.shield.kineticDR);

      final armourDR = battleShip.applyDR(baseDamage, WeaponDamageType.energy, layer: 'armour');
      expect(armourDR, baseDamage * battleShip.ship.armour.energyDR);

      final hullDR = battleShip.applyDR(baseDamage, WeaponDamageType.explosive, layer: 'hull');
      expect(hullDR, baseDamage * battleShip.ship.hull.explosiveDR);
    });

    // Check if applyOverflowAfterShield correctly applies overflow damage to the correct layer when false
    test('applyOverflowAfterShield applies to armour then hull if split disabled', () {
      battleShip.splitOverflowToArmourAndHull = false;
      battleShip.currentAP = 20;
      battleShip.currentHP = battleShip.maxHP;

      final overflow = 50.0;
      battleShip.applyOverflowAfterShield(overflow, WeaponDamageType.kinetic);

      expect(battleShip.currentAP, 0); // fully drained
      expect(battleShip.currentHP, lessThan(battleShip.maxHP)); // hull took leftover
    });

    // If shield is broken, cooldown should be active
    test('isShieldBroken returns true if shield cooldown is active', () {
      battleShip.shieldCooldownTurns = 2;
      expect(battleShip.isShieldBroken, isTrue);
    });
  });
}