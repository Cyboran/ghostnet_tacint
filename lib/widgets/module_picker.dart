import 'package:flutter/material.dart';
import 'package:ghostnet/models/defence/armour_stats.dart';
import 'package:ghostnet/models/defence/armour_type.dart';
import 'package:ghostnet/models/defence/hull_stats.dart';
import 'package:ghostnet/models/defence/hull_type.dart';
import 'package:ghostnet/models/defence/shield_stats.dart';
import 'package:ghostnet/models/defence/shield_type.dart';
import 'package:ghostnet/models/module/thruster_stats.dart';
import 'package:ghostnet/models/module/thruster_type.dart';
import 'package:ghostnet/widgets/module_description.dart';

// Widget to display a module picker dialog for selecting hull, armour, shield, and thruster types
class ModulePicker extends StatefulWidget {
  // Pass in initial values for each module type
  final HullType? initialHull;
  final ArmourType? initialArmour;
  final ShieldType? initialShield;
  final ThrusterType? initialThruster;

  // Callback function to pass values back to parent widget
  final void Function({
    required HullType hull,
    required ArmourType armour,
    required ShieldType shield,
    required ThrusterType thruster,
  }) onSelected;

  const ModulePicker({
    super.key,
    this.initialHull,
    this.initialArmour,
    this.initialShield,
    this.initialThruster,
    required this.onSelected,
  });

  @override
  State<ModulePicker> createState() => _ModulePickerState();
}

class _ModulePickerState extends State<ModulePicker> {
  // Variables to hold the selected module types
  late HullType _selectedHull;
  late ArmourType _selectedArmour;
  late ShieldType _selectedShield;
  late ThrusterType _selectedThruster;

  @override
  void initState() {
    super.initState();
    // Set default values for each module type if not provided
    _selectedHull = widget.initialHull ?? HullType.siegeplate;
    _selectedArmour = widget.initialArmour ?? ArmourType.ironshroud;
    _selectedShield = widget.initialShield ?? ShieldType.aegis;
    _selectedThruster = widget.initialThruster ?? ThrusterType.standard;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: const Text('Select Modules', style: TextStyle(color: Colors.white, fontFamily: 'PressStart2P', fontSize: 20)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            // Hull Selection
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Call ModuleDescription widget to display the selected hull's details
                GestureDetector(
                  onTap: () {
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: 'Hull Description',
                      pageBuilder: (_, __, ___) => Center(
                        child: Material(
                          color: Colors.transparent,
                          child: ModuleDescription(
                            name: hullData[_selectedHull]!.name,
                            imageAsset: hullData[_selectedHull]!.imageAsset,
                            description: hullData[_selectedHull]!.description,
                          ),
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      hullData[_selectedHull]!.imageAsset,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Dropdown menu for selecting hull type
                Expanded(
                  child: _buildDropdown<HullType>(
                    'Hull',
                    HullType.values,
                    _selectedHull,
                    (val) => setState(() => _selectedHull = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Armour Selection
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Call ModuleDescription widget to display the selected armour's details
                GestureDetector(
                  onTap: () {
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: 'Hull Description',
                      pageBuilder: (_, __, ___) => Center(
                        child: Material(
                          color: Colors.transparent,
                          child: ModuleDescription(
                            name: armourData[_selectedArmour]!.name,
                            imageAsset: armourData[_selectedArmour]!.imageAsset,
                            description: armourData[_selectedArmour]!.description,
                          ),
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      armourData[_selectedArmour]!.imageAsset,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Dropdown menu for selecting armour type
                Expanded(
                  child: _buildDropdown<ArmourType>(
                    'Armour',
                    ArmourType.values,
                    _selectedArmour,
                    (val) => setState(() => _selectedArmour = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Shield Selection
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Call ModuleDescription widget to display the selected shield's details
                GestureDetector(
                  onTap: () {
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: 'Hull Description',
                      pageBuilder: (_, __, ___) => Center(
                        child: Material(
                          color: Colors.transparent,
                          child: ModuleDescription(
                            name: shieldData[_selectedShield]!.name,
                            imageAsset: shieldData[_selectedShield]!.imageAsset,
                            description: shieldData[_selectedShield]!.description,
                          ),
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      shieldData[_selectedShield]!.imageAsset,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Dropdown menu for selecting shield type
                Expanded(
                  child: _buildDropdown<ShieldType>(
                    'Shield',
                    ShieldType.values,
                    _selectedShield,
                    (val) => setState(() => _selectedShield = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Thruster Selection
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Call ModuleDescription widget to display the selected thruster's details
                GestureDetector(
                  onTap: () {
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: 'Hull Description',
                      pageBuilder: (_, __, ___) => Center(
                        child: Material(
                          color: Colors.transparent,
                          child: ModuleDescription(
                            name: thrusterData[_selectedThruster]!.name,
                            imageAsset: thrusterData[_selectedThruster]!.imageAsset,
                            description: thrusterData[_selectedThruster]!.description,
                          ),
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      thrusterData[_selectedThruster]!.imageAsset,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Dropdown menu for selecting thruster type
                Expanded(
                  child: _buildDropdown<ThrusterType>(
                    'Thruster',
                    ThrusterType.values,
                    _selectedThruster,
                    (val) => setState(() => _selectedThruster = val!),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        // Cancel button to close the dialog without saving
        TextButton(
          key: const Key('cancel_button'),
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
          child: const Text('CANCEL', style: TextStyle(color: Colors.grey, fontFamily: 'PressStart2P')),
        ),
        // Save button to pass the selected values back to the parent widget
        ElevatedButton(
          key: const Key('save_button'),
          onPressed: () {
            widget.onSelected(
              hull: _selectedHull,
              armour: _selectedArmour,
              shield: _selectedShield,
              thruster: _selectedThruster,
            );
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
          child: const Text('SAVE', style: TextStyle(fontFamily: 'PressStart2P'),),
        ),
      ],
    );
  }

  // Helper function to build a dropdown menu for selecting module types
  Widget _buildDropdown<T>(
    String label,
    List<T> values,
    T selected,
    void Function(T?) onChanged,
  ) {
    return DropdownButtonFormField<T>(
      value: selected,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white10,
        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.zero)),
        labelStyle: const TextStyle(color: Colors.white, fontFamily: 'PressStart2P'),
      ),
      dropdownColor: Colors.grey[800],
      style: const TextStyle(color: Colors.white, fontFamily: 'Silkscreen'),
      items: values.map((val) {
        final name = val.toString().split('.').last;
        return DropdownMenuItem<T>(
          value: val,
          child: Text(name[0].toUpperCase() + name.substring(1)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
