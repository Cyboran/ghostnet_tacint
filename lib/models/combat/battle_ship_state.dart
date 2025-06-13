import 'dart:math';
import 'package:ghostnet/models/module/thruster_special.dart';
import 'package:ghostnet/models/module/thruster_stats.dart';
import 'package:ghostnet/models/ship/ship.dart';
import 'package:ghostnet/models/weapon/weapon_damage_type.dart';

class BattleShipState {
  final Ship ship;

  // Current state of the ship's hull, shield, and armor points
  double currentHP;
  double currentSP;
  double currentAP;

  // Cooldown turns for shield and turns since last shield damage
  int shieldCooldownTurns = 0;
  int turnsSinceLastShieldDamage = 0;
  
  // Temporary evasion bonus from evade command
  double evasionBonus = 0.0;

  // Update value based on whether the ship is defending or not
  bool isDefending = false;
  
  // Enable split overflow damage when shields are down
  // BALANCING: Determine if this is needed, change bool if necessary
  bool splitOverflowToArmourAndHull = true;

  // Getters for maximum values
  double get maxHP => ship.hull.maxHP;
  double get maxSP => ship.shield.maxSP;
  double get maxAP {
    // Calculate the maximum armor points (AP) based on the ship's thruster type
    final base = ship.armour.maxAP;
    final bonus = thrusterData[ship.thruster.type]?.bonus == ThrusterSpecial.bonusArmourPoints
        ? (thrusterData[ship.thruster.type]?.bonusValue ?? 0.0)
        : 0.0;
    return base + bonus;
  }

  // Getters for the ship's evasion
  double get totalEvasion {
    double baseEvasion = ship.hull.evasion + evasionBonus;

    final thruster = ship.thruster;
    final thrusterStats = thrusterData[thruster.type];

    if (thrusterStats?.bonus == ThrusterSpecial.evasionBoost) {
      baseEvasion += thrusterStats?.bonusValue ?? 0.0;
    }

    return baseEvasion.clamp(0.0, 1.0);
  }

  // Display name of the ship
  String get name => ship.name;

  BattleShipState({required this.ship})
      : currentHP = ship.hull.maxHP,
        currentSP = ship.shield.maxSP,
        currentAP = _calculateInitialAP(ship);

  /// Returns the current hull points (HP) of the hull. If the hull is destroyed, it returns true.
  bool get isHullDestroyed => currentHP <= 0;

  /// Returns the current armor points (AP) of the armor. If the armor is broken, it returns true.
  bool get isArmourBroken => currentAP <= 0;
  
  /// Returns the current shield points (SP) of the shield. If the shield is broken, it returns true.
  bool get isShieldBroken => currentSP <= 0 || shieldCooldownTurns > 0;

  /// Update the initial armor points (AP) based on the ship's thruster type.
  static double _calculateInitialAP(Ship ship) {
    final baseAP = ship.armour.maxAP;
    final thrusterStats = thrusterData[ship.thruster.type];

    if (thrusterStats?.bonus == ThrusterSpecial.bonusArmourPoints) {
      return baseAP + (thrusterStats?.bonusValue ?? 0.0);
    }

    return baseAP;
  }

  /// Applies damage, reducing the appropriate values (Hull, Armour, Shield).
  /// If the damage exceeds the current value, it sets the current HP to 0.
  /// If defending, applies a 20% damage reduction.
  double applyDamage(double damage, {required String layer, required WeaponDamageType damageType}) {
    // Check if the ship is defending and apply damage reduction
    if (isDefending) {
      damage *= 0.8;
    }

    // Afterwards, apply damage reduction (DR) based on the layer (shield, armor, hull)
    double reducedDamage = applyDR(damage, damageType, layer: layer);

    switch (layer.toLowerCase()) {
      case 'shield':
        // Check if the shield is broken and if so, damage passes through
        if (isShieldBroken) return reducedDamage;

        // Otherwise, apply damage to the shield
        if (currentSP >= reducedDamage) {
          currentSP -= reducedDamage;
          turnsSinceLastShieldDamage = 0;
          return 0;
        } else {
          double overflow = reducedDamage - currentSP;
          currentSP = 0;
          shieldCooldownTurns = 3;
          turnsSinceLastShieldDamage = 0;
          return overflow;
        }

      case 'armour':
        // Apply damage to the armor and return the overflow if any
        if (currentAP >= reducedDamage) {
          currentAP -= reducedDamage;
          return 0;
        } else {
          final overflow = reducedDamage - currentAP;
          currentAP = 0;
          return overflow;
        }

      case 'hull':
      default:
        // Apply damage directly to the hull
        final absorbed = reducedDamage.clamp(0, currentHP);
        currentHP -= absorbed;
        return reducedDamage - absorbed;
    }
  }

  /// Applies overflow damage when shields are down, either to one layer or split between armor and hull if enabled.
  void applyOverflowAfterShield(double overflow, WeaponDamageType type) {
    // If the boolean is true, split the overflow damage between armor and hull
    // Otherwise, apply the overflow damage to armor first, then hull
    if (splitOverflowToArmourAndHull) {
      double toArmour = overflow * 0.7;
      double toHull = overflow * 0.3;

      double armourLeft = applyDamage(toArmour, layer: 'armour', damageType: type);
      applyDamage(toHull + armourLeft, layer: 'hull', damageType: type);
    } else {
      // Default behaviour: spill to armor first, then hull
      double left = applyDamage(overflow, layer: 'armour', damageType: type);
      if (left > 0) {
        applyDamage(left, layer: 'hull', damageType: type);
      }
    }
  }

  // Applies damage reduction (DR) based on the ship's shield, armor, or hull.
  double applyDR(double baseDamage, WeaponDamageType type, {required String layer}) {
    // Variable to hold the damage reduction multiplier
    double multiplier;

    // Determine the damage reduction based on the layer (shield, armor, hull)
    switch (layer.toLowerCase()) {
      case 'shield':
        multiplier = getDR(ship.shield, type);
        break;
      case 'armour':
        multiplier = getDR(ship.armour, type);
        break;
      case 'hull':
      default:
        multiplier = getDR(ship.hull, type);
        break;
    }

    return baseDamage * multiplier;
  }

  // Retrieves the damage reduction (DR) value based on the component and damage type.
  double getDR(dynamic component, WeaponDamageType type) {
    // Checks for the damage type, then returns the appropriate DR value for the component.
    switch (type) {
      case WeaponDamageType.kinetic:
        return component.kineticDR;
      case WeaponDamageType.energy:
        return component.energyDR;
      case WeaponDamageType.explosive:
        return component.explosiveDR;
    }
  }

  // Roll a hit chance against the ship’s evasion
  bool attackHits(double weaponHitChance) {
    double hitRoll = Random().nextDouble(); // 0.0 to 1.0
    double chanceToHit = weaponHitChance - totalEvasion;
    return hitRoll <= chanceToHit.clamp(0.0, 1.0);
  }

  // Tick the shield cooldown, decrementing it by 1 turn and incrementing the turns since last shield damage.
  void tickShieldCooldown() {
    if (shieldCooldownTurns > 0) shieldCooldownTurns--;
    turnsSinceLastShieldDamage = turnsSinceLastShieldDamage.clamp(0, 99) + 1;
  }

  // Regenerate shield points based on the current state (defending or not)
  void regenerateShield({bool isDefending = false}) {
    if (shieldCooldownTurns > 0) return;

    double regenAmount = maxSP * (isDefending ? 0.2 : 0.1);
    currentSP = (currentSP + regenAmount).clamp(0, maxSP);
  }

  // Fully recharge the shield if it has been 3 turns since the last damage and the shield is not already full.
  void checkShieldFullRecharge() {
    if (turnsSinceLastShieldDamage >= 3 && currentSP < maxSP) {
      currentSP = maxSP;
    }
  }

  // Advance the ship's state by one turn, applying per-turn logic.
  void nextTurn({bool isDefending = false}) {
    this.isDefending = isDefending;
    evasionBonus = 0.0; // reset bonus evasion each turn
    tickShieldCooldown();
    regenerateShield(isDefending: isDefending);
    checkShieldFullRecharge();
  }

  /// Activate evade mode (adds temporary 20% evasion) when either the player hits the evade command
  /// or the enemy ship uses the evade command.
  void applyEvade() {
    evasionBonus = 0.2;
  }
}