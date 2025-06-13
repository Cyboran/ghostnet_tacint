import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ghostnet/models/combat/battle_log_entry.dart';
import 'package:ghostnet/models/combat/battle_ship_state.dart';
import 'package:ghostnet/models/combat/projectile.dart';
import 'package:ghostnet/models/ship/enemy_ships.dart';
import 'package:ghostnet/models/ship/ship.dart';
import 'package:ghostnet/widgets/battle_log.dart';
import 'package:ghostnet/widgets/combat_graphics.dart';
import 'package:ghostnet/widgets/ship_hud.dart';

class BattleScreen extends StatelessWidget {
  const BattleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ship = ModalRoute.of(context)!.settings.arguments as Ship;

    return BattleScreenStateful(player: ship);
  }
}

class BattleScreenStateful extends StatefulWidget {
  final Ship player;

  const BattleScreenStateful({super.key, required this.player});

  @override
  State<BattleScreenStateful> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreenStateful> {
  // Battle log to keep track of actions taken during the battle
  final List<BattleLogEntry> _battleLog = [];
  // Holder for the player and enemy ship states
  late BattleShipState player;
  late BattleShipState enemy;
  // Variable to hold player's weapon choice
  int selectedWeaponIndex = 0;
  // Flag to check if the battle is over
  bool isBattleOver = false;
  // Variable to hold projectiles
  List<Projectile> projectiles = [];
  // Variable to hold actions
  String? playerAction;
  String? enemyAction;
  // Variable to track if projectile is animating
  bool isProjectileAnimating = false;

  @override
  void initState() {
    super.initState();
    // Randomly assign enemy ship at start
    enemy = BattleShipState(ship: getRandomEnemyShip());
    // Assign player ship from widget
    player = BattleShipState(ship: widget.player);
  }

  // Add a new entry to the battle log and refresh the UI
  void _addToLog(String entry) {
    setState(() {
      _battleLog.insert(0, BattleLogEntry(entry));
    });
  }


  /// Handles the Fire action
  void _handleFire() {
    final weapon = player.ship.weapons[selectedWeaponIndex];
    final hitChance = weapon.hitChance;

    if (!enemy.attackHits(hitChance)) {
      _addToLog('${player.name} fired at ${enemy.name}, but missed!');
      _endTurn();
      return;
    }

    // Create a projectile and add it to the list
    final projectile = Projectile(
      fromPlayer: true,
      start: Offset(60, 300), // Starting position - adjust as needed
      end: Offset(300, 60), // Ending position - adjust as needed
      imagePath: 'assets/images/battle_graphics/projectile.png',
    );

    // Trigger the projectile animation
    setState(() {
      isProjectileAnimating = true;
      projectiles.clear(); // Clear previous projectiles
      projectiles.add(projectile);
      playerAction = 'fire';
    });

    // May no longer be needed.
    // setState(() {
    //   double overflow = enemy.applyDamage(baseDamage.toDouble(), layer: 'shield', damageType: damageType);
    //   if (overflow > 0) {
    //     enemy.applyOverflowAfterShield(overflow, damageType);
    //   }
    // });

    // _addToLog('${player.name} fired ${weapon.name} at ${enemy.name} for ${baseDamage.toStringAsFixed(0)} ${damageType.name.toUpperCase()} damage.');
    // _endTurn();
  }

  /// Handles the Evade action
  void _handleEvade() {
    player.applyEvade();
    setState(() {
      playerAction = 'evade';
    });
    _addToLog('${player.name} activated evasive maneuvers.');

    // Delay the turn end to allow for animation
    Future.delayed(const Duration(milliseconds: 600), _endTurn);
  }

  /// Handles the Defend action
  void _handleDefend() {
    player.isDefending = true;
    setState(() {
      playerAction = 'defend';
    });
    _addToLog('${player.name} raised defences.');

    // Delay the turn end to allow for animation
    Future.delayed(const Duration(milliseconds: 600), _endTurn);
  }

  /// Advances the game to the next turn
  void _endTurn() {
    if (isBattleOver) return;

    setState(() {
      player.nextTurn(isDefending: player.isDefending);
      enemy.nextTurn(isDefending: enemy.isDefending);
      // Clear actions for the next turn
      playerAction = null;
      enemyAction = null;
    });

    _checkBattleOutcome(); // Check after player turn

    if (!isBattleOver && !isProjectileAnimating) {
      _enemyAction();
      _checkBattleOutcome(); // Check again after enemy turn
    }
  }

  /// Checks if either the player or enemy ship is destroyed then shows the appropriate dialog
  void _checkBattleOutcome() {
    if (player.isHullDestroyed) {
      isBattleOver = true;
      _showBattleEndDialog('Defeat', 'Your ship was destroyed...');
    } else if (enemy.isHullDestroyed) {
      isBattleOver = true;
      _showBattleEndDialog('Victory', 'You defeated the enemy ship!');
    }
  }

  /// If battle is over, then calls the dialog to show the outcome
  void _showBattleEndDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // go back to previous screen
            },
            child: const Text('Exit'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              setState(() {
                // Reset state
                player = BattleShipState(ship: widget.player);
                enemy = BattleShipState(ship: getRandomEnemyShip());
                _battleLog.clear();
                isBattleOver = false;
              });
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }

  /// Enemy actions/AI - Currently randomly selecting an action
  /// DO LATER: Implement a more sophisticated AI for enemy actions
  void _enemyAction() {
    final rand = Random().nextInt(3);

    switch (rand) {
      case 0: // Fire
        final weapon = enemy.ship.weapons.first;
        final hitChance = weapon.hitChance;

        // Create a projectile and add it to the list
        final projectile = Projectile(
          fromPlayer: false,
          start: Offset(300, 60), // Starting position - adjust as needed
          end: Offset(60, 300), // Ending position - adjust as needed
          imagePath: 'assets/images/battle_graphics/projectile.png',
        );

        if (!player.attackHits(hitChance)) {
          _addToLog('${enemy.name} fired at ${player.name}, but missed!');
          return;
        }

        // Trigger the projectile animation
        setState(() {
          isProjectileAnimating = true;
          projectiles.clear(); // Clear previous projectiles
          projectiles.add(projectile);
          enemyAction = 'fire';
        });

        // May no longer be needed.
        // setState(() {
        //   double overflow = player.applyDamage(baseDamage.toDouble(), layer: 'shield', damageType: damageType);
        //   if (overflow > 0) {
        //     player.applyOverflowAfterShield(overflow, damageType);
        //   }
        // });

        // _addToLog('${enemy.name} fired ${weapon.name} at ${player.name} for ${baseDamage.toStringAsFixed(0)} ${damageType.name.toUpperCase()} damage.');
        break;

      case 1: // Evade
        enemy.applyEvade();
        setState(() {
          enemyAction = 'evade';
        });
        _addToLog('${enemy.name} activated evasive maneuvers.');

        Future.delayed(const Duration(milliseconds: 600), _checkBattleOutcome);
        break;

      case 2: // Defend
        enemy.isDefending = true;
        setState(() {
          enemyAction = 'defend';
        });
        _addToLog('${enemy.name} raised defences.');

        Future.delayed(const Duration(milliseconds: 600), _checkBattleOutcome);
        break;
    }
  }

  /// Callback for when the projectile animation completes
  void _onProjectileComplete() {
    if (projectiles.isEmpty) return;

    // Check if the projectile was fired by the player or enemy
    final wasFromPlayer = projectiles.first.fromPlayer;
    // Remove the projectiles from the list
    projectiles.clear();

    setState(() {
      projectiles.clear(); // Clear the projectiles list
      isProjectileAnimating = false;
    });

    if (wasFromPlayer) {
      // Player's turn - apply damage to the enemy and resolve projectile animation
      setState(() {
        playerAction = null;
      });

      // Get the weapon and damage type from the selected weapon index
      final weapon = player.ship.weapons[selectedWeaponIndex];
      final damageType = weapon.damageType;
      final baseDamage = weapon.baseDamage;

      // Apply damage to the enemy ship
      double overflow = enemy.applyDamage(baseDamage.toDouble(), layer: 'shield', damageType: damageType);
      if (overflow > 0) {
        enemy.applyOverflowAfterShield(overflow, damageType);
      }

      // Log the action
      _addToLog('${player.name} fired ${weapon.name} at ${enemy.name} for ${baseDamage.toStringAsFixed(0)} ${damageType.name.toUpperCase()} damage.');

      Future.delayed(const Duration(milliseconds: 100), _endTurn); // enemy's turn starts after animation
    } else {
      // Enemy's turn - apply damage to the player and resolve projectile animation
      setState(() {
        enemyAction = null;
      });

      // Get the weapon and damage type from the enemy ship
      final weapon = enemy.ship.weapons.first;
      final damageType = weapon.damageType;
      final baseDamage = weapon.baseDamage;

      // Apply damage to the player ship
      double overflow = player.applyDamage(baseDamage.toDouble(), layer: 'shield', damageType: damageType);
      if (overflow > 0) {
        player.applyOverflowAfterShield(overflow, damageType);
      }

      // Log the action
      _addToLog('${enemy.name} fired ${weapon.name} at ${player.name} for ${baseDamage.toStringAsFixed(0)} ${damageType.name.toUpperCase()} damage.');

      _checkBattleOutcome(); // after damage dealt
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              // Enemy Ship HUD
              ShipHud(
                key: const Key('enemy_ship_hud'),
                label: 'ENEMY SHIP HUD',
                name: enemy.name,
                currentHP: enemy.currentHP,
                currentSP: enemy.currentSP,
                currentAP: enemy.currentAP,
                backgroundColor: Colors.red[900]!,
              ),
              const SizedBox(height: 16),

              // Battle Graphics
              Expanded(
                child: CombatGraphics(
                  player: player,
                  enemy: enemy,
                  playerAction: playerAction,
                  enemyAction: enemyAction,
                  projectiles: projectiles,
                  onPlayerProjectileComplete: _onProjectileComplete,
                ),
              ),
              const SizedBox(height: 16),

              // Friendly Ship HUD (dynamic from selected ship)
              ShipHud(
                key: const Key('friendly_ship_hud'),
                label: 'FRIENDLY SHIP HUD',
                name: player.name,
                currentHP: player.currentHP,
                currentSP: player.currentSP,
                currentAP: player.currentAP,
                backgroundColor: Colors.blueGrey[800]!,
              ),
              const SizedBox(height: 16),

              // Dropdown for Weapon Selection
              DropdownButton<int>(
                value: selectedWeaponIndex,
                dropdownColor: Colors.grey[850],
                style: const TextStyle(color: Colors.white, fontFamily: 'Silkscreen'),
                iconEnabledColor: Colors.tealAccent,
                items: List.generate(player.ship.weapons.length, (index) {
                  final weapon = player.ship.weapons[index];
                  return DropdownMenuItem(
                    value: index,
                    child: Text(weapon.name),
                  );
                }),
                onChanged: isBattleOver
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() {
                            selectedWeaponIndex = value;
                          });
                        }
                      },
              ),

              // Battle Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    key: const Key('fire_button'),
                    onPressed: isBattleOver || isProjectileAnimating ? null : _handleFire,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Text('Fire', 
                      style: TextStyle(
                        fontFamily: 'PressStart2P',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    key: const Key('evade_button'),
                    onPressed: isBattleOver || isProjectileAnimating ? null : _handleEvade,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Text('Evade', 
                      style: TextStyle(
                        fontFamily: 'PressStart2P',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    key: const Key('defend_button'),
                    onPressed: isBattleOver || isProjectileAnimating ? null : _handleDefend,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Text('Defend', 
                      style: TextStyle(
                        fontFamily: 'PressStart2P',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Battle Log
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2, // ~20% of screen height
                child: BattleLogWidget(
                  key: const Key('battle_log'),
                  logEntries: _battleLog,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}