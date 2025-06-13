// This file defines the BattleLogEntry class, which represents an entry in a battle log.
// Each entry has a description and a timestamp indicating when it was created.

class BattleLogEntry {
  final String description;
  final DateTime timestamp;

  BattleLogEntry(this.description) : timestamp = DateTime.now();
}
