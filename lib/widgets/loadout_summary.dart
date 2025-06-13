import 'package:flutter/material.dart';
import 'package:ghostnet/models/ship/ship.dart';
import 'package:ghostnet/providers/loadout_provider.dart';
import 'package:ghostnet/widgets/ship_stats.dart';
import 'package:provider/provider.dart';

class LoadoutSummary extends StatelessWidget {
  final Ship loadout;

  const LoadoutSummary({super.key, required this.loadout});

  void _confirmDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Delete Loadout', style: TextStyle(color: Colors.white, fontFamily: 'PressStart2P', fontSize: 20)),
        content: const Text('Are you sure you want to delete this loadout?', style: TextStyle(color: Colors.white70, fontFamily: 'Silkscreen')),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        actions: [
          TextButton(
            key: const Key('cancel_delete_button'),
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
            child: const Text('Cancel', style: TextStyle(fontFamily: 'Silkscreen'),),
          ),
          TextButton(
            key: const Key('confirm_delete_button'),
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
            child: const Text('Delete', style: TextStyle(color: Colors.redAccent, fontFamily: 'Silkscreen')),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      Provider.of<LoadoutProvider>(context, listen: false).deleteLoadout(loadout.id);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Loadout deleted', style: TextStyle(color: Colors.white, fontFamily: 'Silkscreen'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        children: [
          // Section title
          const Text(
            'Summary of Selected Loadout',
            style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'SilkScreen'),
          ),
          const SizedBox(height: 8),

          // Ship name
          Text(
            'Currently showing: ${loadout.name}',
            style: const TextStyle(color: Colors.white70, fontFamily: 'SilkScreen'),
          ),
          const SizedBox(height: 16),

          // Ship stats module display
          Expanded(
            child: ShipStatsWidget(
              hull: loadout.hull,
              armour: loadout.armour,
              shield: loadout.shield,
              thruster: loadout.thruster,
              weapons: loadout.weapons,
            ),
          ),

          const SizedBox(height: 16),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Edit Loadout button
              ElevatedButton(
                key: const Key('edit_loadout_button'),
                onPressed: () {
                  Navigator.pushNamed(context, '/builder', arguments: loadout);
                },
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                child: const Text('Edit Loadout', style: TextStyle(fontFamily: 'Silkscreen'),),
              ),
              // Delete Loadout button
              ElevatedButton(
                key: const Key('delete_loadout_button'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                onPressed: () => _confirmDelete(context),
                child: const Text('Delete', style: TextStyle(fontFamily: 'Silkscreen'),),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
