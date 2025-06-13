import 'package:flutter/material.dart';
import '../models/combat/battle_log_entry.dart';

class BattleLogWidget extends StatelessWidget {
  final List<BattleLogEntry> logEntries;

  const BattleLogWidget({super.key, required this.logEntries});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.zero,
      ),
      child: ListView.builder(
        reverse: true,
        itemCount: logEntries.length,
        itemBuilder: (context, index) {
          final entry = logEntries[index];
          final turnNumber = logEntries.length - index;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              // Record the turn number
              children: [
                Text(
                  '[Turn $turnNumber]',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.amber[300],
                    fontFamily: 'SilkScreen',
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // Record the action taken this turn
                    children: [
                      Text(
                        entry.description,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'SilkScreen',
                        ),
                      ),
                      // Record the timestamp of the action
                      Text(
                        _formatTimestamp(entry.timestamp),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[500],
                          fontFamily: 'SilkScreen',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatTimestamp(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }
}