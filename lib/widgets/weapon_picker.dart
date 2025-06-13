import 'package:flutter/material.dart';
import 'package:ghostnet/models/weapon/weapon_stats.dart';
import 'package:ghostnet/models/weapon/weapon_type.dart';
import 'package:ghostnet/widgets/module_description.dart';

// Widget to select weapons for the ship loadout
class WeaponPicker extends StatefulWidget {
  final int maxSlots;
  final List<WeaponType> initialWeapon;
  final void Function(List<WeaponType>) onSelected;

  const WeaponPicker({
    super.key,
    required this.maxSlots,
    required this.initialWeapon,
    required this.onSelected,
  });

  @override
  State<WeaponPicker> createState() => _WeaponPickerState();
}

class _WeaponPickerState extends State<WeaponPicker> {
  // store the selected weapons in a list
  late List<WeaponType> _selectedWeapons;

  @override
  void initState() {
    super.initState();
    _selectedWeapons = List.from(widget.initialWeapon);
  }

  /// Toggles the selection of a weapon.
  void _toggleSelection(WeaponType type) {
    setState(() {
      if (_selectedWeapons.contains(type)) {
        // deselect the weapon if already selected
        _selectedWeapons.remove(type);
      } else {
        // enforce max slots
        if (_selectedWeapons.length < widget.maxSlots) {
          _selectedWeapons.add(type);
        } else {
          // Return error if user tries to select more than max slots
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Max ${widget.maxSlots} weapons allowed.', style: const TextStyle(color: Colors.white, fontFamily: 'Silkscreen')),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      // Display the title with the number of selected weapons
      title: Text(
        'Select Weapons (${_selectedWeapons.length}/${widget.maxSlots})',
        style: const TextStyle(color: Colors.white, fontFamily: 'PressStart2P', fontSize: 20),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: WeaponType.values.length,
          itemBuilder: (context, index) {
            final type = WeaponType.values[index];
            final stats = weaponData[type]!;

            final isSelected = _selectedWeapons.contains(type);

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 4),
              // Alpha Value - 20% of 255 = 51
              tileColor: isSelected ? Colors.teal.withAlpha(51) : null, 
              leading: GestureDetector(
                onTap: () {
                  // Show weapon description in a dialog using ModuleDescription widget
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: 'Weapon Description',
                    pageBuilder: (_, __, ___) => Center(
                      child: Material(
                        color: Colors.transparent,
                        child: ModuleDescription(
                          name: stats.name,
                          imageAsset: stats.imageAsset,
                          description: stats.description,
                        ),
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.zero,
                  child: Image.asset(
                    stats.imageAsset,
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Display weapon name
              title: Text(stats.name, style: const TextStyle(color: Colors.white, fontFamily: 'Silkscreen')),
              // Display weapon stats
              subtitle: Text(
                '${stats.damageType.name.toUpperCase()} • ${stats.baseDamage} DMG • ${stats.hitChance * 100}% HIT',
                style: const TextStyle(color: Colors.white60, fontFamily: 'Silkscreen'),
              ),
              // Display selection icon depending on if it's selected or not
              trailing: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  border: Border.all(color: isSelected ? Colors.tealAccent : Colors.grey, width: 2),
                  color: isSelected ? Colors.tealAccent : Colors.transparent,
                  shape: BoxShape.rectangle,
                ),
              ),
              onTap: () => _toggleSelection(type),
            );
          },
        ),
      ),
      actions: [
        // Cancel button to close the dialog without saving
        TextButton(
          key: const Key('cancel_button'),
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          child: const Text('CANCEL', style: TextStyle(color: Colors.grey, fontFamily: 'PressStart2P')),
        ),
        // Save button to pass the selected values back to the parent widget
        ElevatedButton(
          key: const Key('save_button'),
          onPressed: () {
            widget.onSelected(_selectedWeapons);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          child: const Text('SAVE', style: TextStyle(fontFamily: 'PressStart2P')),
        ),
      ],
    );
  }
}
