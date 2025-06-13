import 'package:flutter/material.dart';
import 'package:ghostnet/models/combat/battle_ship_state.dart';
import 'package:ghostnet/models/combat/projectile.dart';
import 'package:ghostnet/widgets/enemy_graphics.dart';
import 'package:ghostnet/widgets/player_graphics.dart';
import 'package:ghostnet/widgets/projectile_graphics.dart';

class CombatGraphics extends StatefulWidget {
  // The player and enemy ship states
  final BattleShipState player;
  final BattleShipState enemy;
  // Actions for the player and enemy
  final String? playerAction;
  final String? enemyAction;
  // Projectiles for the player and enemy
  final List<Projectile> projectiles;
  final VoidCallback? onPlayerProjectileComplete;

  const CombatGraphics({
    super.key,
    required this.player,
    required this.enemy,
    this.playerAction,
    this.enemyAction,
    this.projectiles = const [],
    this.onPlayerProjectileComplete,
  });

  @override
  State<CombatGraphics> createState() => _CombatGraphicsState();
}

class _CombatGraphicsState extends State<CombatGraphics> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      // Determines scroll speed of background - lower is faster
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat(); // Infinite loop for parallax effect
 }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Seamless horizontally scrolling background
        Positioned.fill(
          child: ClipRect(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final screenWidth = MediaQuery.of(context).size.width;
                return Stack(
                  children: [
                    Positioned(
                      left: _controller.value * -screenWidth,
                      top: 0,
                      bottom: 0,
                      width: screenWidth * 2, // two full widths
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/battle_graphics/background.png',
                            fit: BoxFit.cover,
                            width: screenWidth,
                            height: double.infinity,
                          ),
                          Image.asset(
                            'assets/images/battle_graphics/background.png',
                            fit: BoxFit.cover,
                            width: screenWidth,
                            height: double.infinity,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        
        // Projectiles
        if (widget.projectiles.isNotEmpty)
          ProjectileGraphics(
            projectiles: widget.projectiles,
            onComplete: widget.onPlayerProjectileComplete,
          ),

        // Enemy Ship Top Right
        Positioned(
          top: 40,
          right: 24,
          child: EnemyGraphics(
            ship: widget.enemy,
            action: widget.enemyAction,
          ),
        ),

        // Player Ship Bottom Left
        Positioned(
          bottom: 40,
          left: 24,
          child: PlayerGraphics(
            ship: widget.player,
            action: widget.playerAction,
          ),
        ),
      ],
    );
  }
}