import 'package:flutter/material.dart';
import 'package:ghostnet/models/combat/battle_ship_state.dart';

class PlayerGraphics extends StatefulWidget {
  final BattleShipState ship;
  final String? action; // "fire", "evade", "defend", or null

  const PlayerGraphics({
    super.key,
    required this.ship,
    this.action,
  });

  @override
  State<PlayerGraphics> createState() => _PlayerGraphicsState();
}

class _PlayerGraphicsState extends State<PlayerGraphics> 
    with TickerProviderStateMixin {
  // Animation controllers for idle and action animations
  late AnimationController _idleController;   
  late AnimationController _actionController; 

  // Animation objects for floating and action effects
  late Animation<double> _floatAnimation;
  late Animation<Offset> _actionOffset;

  @override
  void initState() {
    super.initState();

    // Idle floating animation (gentle up/down loop)
    _idleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true); // Infinite loop

    // Tween animates between -4 and +4 vertically to simulate floating
    _floatAnimation = Tween<double>(begin: -4, end: 4).animate(
      CurvedAnimation(parent: _idleController, curve: Curves.easeInOut),
    );

    // Action animation controller (used for things like firing or evading)
    _actionController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Initialize action offset with a default value
    _actionOffset = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(_actionController);
  }

  @override
  void dispose() {
    _idleController.dispose();
    _actionController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PlayerGraphics oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Trigger action animation when user activates any action
    if (widget.action != null) {
      _triggerAction(widget.action!);
    }

    // Manually refresh the widget if the action is 'defend'
    if (widget.action == 'defend') {
      setState(() {});
    }
  }

  /// Triggers the correct animation based on the action received
  void _triggerAction(String action) {
    Offset begin = Offset.zero;
    Offset end;

    /*
     * Tween<Offset> defines the *range* of the animation.
     * For example, Offset(-0.6, 0) means "move left horizontally"
     * Offset.zero is the resting state (no translation).
     * When animated, it interpolates from begin to end.
     * Additionally, the values are as follows:
     * Offset(-Horizontal Value-, -Vertical Value-)
    */
    switch (action) {
      case 'fire':
        end = const Offset(-0.1, 0); // Slight recoil
        break;
      case 'evade':
        end = const Offset(-0.6, 0); // Dodge
        break;
      case 'defend': // No movement
      default:
        end = Offset.zero;
        break;
    }

    // Update animation values without recreating the animation
    final tween = Tween<Offset>(
      begin: begin,
      end: end,
    );

    // Apply tween to the animation controller using a curved motion
    _actionOffset = tween.animate(
      CurvedAnimation(parent: _actionController, curve: Curves.easeInOut),
    );

    // Start animation from beginning, runs animation once then returns to idle
    _actionController
      ..reset()
      ..forward().whenComplete(() {
        // After the movement completes, return to center
        final reverseTween = Tween<Offset>(begin: end, end: Offset.zero);
        _actionOffset = reverseTween.animate(
          CurvedAnimation(parent: _actionController, curve: Curves.easeInOut),
        );
        _actionController
          ..reset()
          ..forward();
      });
  }

  @override
  Widget build(BuildContext context) {
    final shipImage = widget.ship.ship.shipImagePath;

    return AnimatedBuilder(
      animation: Listenable.merge([_floatAnimation, _actionController]),
      builder: (context, child) {
        // Idle floating effect for vertical movement
        final floatY = _floatAnimation.value;
        // Action effect for horizontal movement
        final actionX = _actionOffset.value.dx;
        return Stack(
          alignment: Alignment.center,
          children: [
            // Glowing shield effect
            AnimatedOpacity(
              opacity: widget.action == 'defend' ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyanAccent.withAlpha((0.6 * 255).toInt()),
                      blurRadius: 20,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
            ),

            Transform.translate(
              offset: Offset(
                actionX * 50,
                floatY,
              ), // combine effects: sideways + up/down
              child: Image.asset(
                shipImage,
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
            ),
          ],
        );
      },
    );
  }
}