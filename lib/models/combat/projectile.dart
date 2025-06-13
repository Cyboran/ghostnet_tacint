import 'package:flutter/widgets.dart';

class Projectile {
  final bool fromPlayer; // true if shot from player to enemy
  final Offset start;
  final Offset end;
  final String imagePath;

  Projectile({
    required this.fromPlayer,
    required this.start,
    required this.end,
    required this.imagePath,
  });
}