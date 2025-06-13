import 'package:flutter/material.dart';
import 'package:ghostnet/models/combat/projectile.dart';

class ProjectileGraphics extends StatefulWidget {
  final List<Projectile> projectiles;
  final VoidCallback? onComplete; // Callback when all animations finish

  const ProjectileGraphics({
    super.key,
    required this.projectiles,
    this.onComplete,
  });

  @override
  State<ProjectileGraphics> createState() => _ProjectileGraphicsState();
}

class _ProjectileGraphicsState extends State<ProjectileGraphics>
    with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  final List<Animation<Offset>> _animations = [];
  bool didComplete = false; // Track if the animation is complete

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  // Hard reset the animations if the projectiles change
  @override
  void didUpdateWidget(covariant ProjectileGraphics oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.projectiles != widget.projectiles) {
      for (final c in _controllers) {
        c.dispose();
      }
      _controllers.clear();
      _animations.clear();
      didComplete = false; // Reset completion status

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            // Trigger a rebuild to reinitialize animations
            _initializeAnimations();
          });
        }
      });
    }
  }

  void _initializeAnimations() {
    // Initialize animation controllers and animations for each projectile
    if (widget.projectiles.isEmpty) {
      return; // No projectiles to animate
    }

    for (final projectile in widget.projectiles) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );

      final tween = Tween<Offset>(
        begin: projectile.start,
        end: projectile.end,
      );

      final animation = tween.animate(
        CurvedAnimation(parent: controller, curve: Curves.linear),
      );

      _controllers.add(controller);
      _animations.add(animation);
      controller.forward();

      // When the last projectile finishes, call onComplete (once)
      if (projectile == widget.projectiles.last && widget.onComplete != null) {
        controller.addStatusListener((status) {
          if (AnimationStatus.completed == status) {
            if (!didComplete) {
              didComplete = true; // Mark as complete
              widget.onComplete!();
            }
          }
        });
      }
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Prevent build if animations haven't been initialized yet
    if (_animations.length != widget.projectiles.length) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: List.generate(widget.projectiles.length, (index) {
        final projectile = widget.projectiles[index];
        final animation = _animations[index];

        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Positioned(
              left: animation.value.dx,
              top: animation.value.dy,
              child: Image.asset(
                projectile.imagePath,
                width: 32,
                height: 32,
              ),
            );
          },
        );
      }),
    );
  }
}