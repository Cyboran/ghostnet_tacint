import 'package:ghostnet/models/ship/ship.dart';
import 'package:ghostnet/models/combat/battle_ship_state.dart';

// This extension adds a method to the Ship class to convert it into a BattleShipState.
extension ShipCombatExtension on Ship {
  BattleShipState toBattleState() {
    return BattleShipState(ship: this);
  }
}
