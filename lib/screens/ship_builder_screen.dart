import 'package:flutter/material.dart';
import 'package:ghostnet/models/defence/armour.dart';
import 'package:ghostnet/models/defence/armour_extensions.dart';
import 'package:ghostnet/models/defence/armour_stats.dart';
import 'package:ghostnet/models/defence/armour_type.dart';
import 'package:ghostnet/models/defence/hull.dart';
import 'package:ghostnet/models/defence/hull_extensions.dart';
import 'package:ghostnet/models/defence/hull_stats.dart';
import 'package:ghostnet/models/defence/hull_type.dart';
import 'package:ghostnet/models/defence/shield.dart';
import 'package:ghostnet/models/defence/shield_extensions.dart';
import 'package:ghostnet/models/defence/shield_stats.dart';
import 'package:ghostnet/models/defence/shield_type.dart';
import 'package:ghostnet/models/module/thruster.dart';
import 'package:ghostnet/models/module/thruster_extensions.dart';
import 'package:ghostnet/models/module/thruster_stats.dart';
import 'package:ghostnet/models/module/thruster_type.dart';
import 'package:ghostnet/models/profile/captain.dart';
import 'package:ghostnet/models/ship/ship.dart';
import 'package:ghostnet/models/ship/ship_class.dart';
import 'package:ghostnet/models/weapon/weapon.dart';
import 'package:ghostnet/models/weapon/weapon_stats.dart';
import 'package:ghostnet/models/weapon/weapon_type.dart';
import 'package:ghostnet/providers/captain_provider.dart';
import 'package:ghostnet/providers/loadout_provider.dart';
import 'package:ghostnet/widgets/module_picker.dart';
import 'package:ghostnet/widgets/ship_stats.dart';
import 'package:ghostnet/widgets/weapon_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

// DO LATER: Think about optional polish to further improve this
class ShipBuilderScreen extends StatefulWidget {
  // Variable to hold an existing ship if one is passed in
  final Ship? existingShip;

  // Constructor for the ShipBuilderScreen, using existingShip if provided
  const ShipBuilderScreen({super.key, this.existingShip});

  @override
  State<ShipBuilderScreen> createState() => _ShipBuilderScreenState();
}

class _ShipBuilderScreenState extends State<ShipBuilderScreen> {
  // Controller for the loadout name input field
  final TextEditingController _nameController = TextEditingController();

  // Get Ship Classes from enum
  final List<ShipClass> shipClasses = ShipClass.values;

  // Variables to hold user selections
  ShipClass? _selectedShipClass;
  ArmourType? _selectedArmourType;
  HullType? _selectedHullType;
  ShieldType? _selectedShieldType;
  ThrusterType? _selectedThrusterType;
  List<WeaponType> _selectedWeapons = [];

  // Variables to track edit mode
  bool _isEditing = false;
  String? _existingId;

  // Variable to hold the existing ship if passed in
  Ship? _runtimeShip;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.existingShip != null;
  }

  // Prepopulate the fields if an existing ship is passed in
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Only run once
    if (_runtimeShip != null || widget.existingShip != null) return;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Ship) {
      _isEditing = true;
      _runtimeShip = args;

      _existingId = _runtimeShip!.id;
      _nameController.text = _runtimeShip!.name;
      _selectedShipClass = _runtimeShip!.shipClass;
      _selectedHullType = _runtimeShip!.hull.type;
      _selectedArmourType = _runtimeShip!.armour.type;
      _selectedShieldType = _runtimeShip!.shield.type;
      _selectedThrusterType = _runtimeShip!.thruster.type;
      _selectedWeapons = _runtimeShip!.weapons.map((w) => w.type).toList();

      setState(() {});
    } else {
      _isEditing = false;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveLoadout() async {
    // List to hold missing fields
    final missing = [];

    // Validate inputs and add to missing list if empty
    if (_nameController.text.isEmpty) missing.add('Loadout name');
    if (_selectedShipClass == null) missing.add('Ship class');
    if (_selectedHullType == null) missing.add('Hull');
    if (_selectedArmourType == null) missing.add('Armour');
    if (_selectedShieldType == null) missing.add('Shield');
    if (_selectedThrusterType == null) missing.add('Thruster');
    if (_selectedWeapons.isEmpty) missing.add('At least one weapon');

    // Show error message if any fields are missing and prevent saving
    if (missing.isNotEmpty) {
      final errorMsg = 'Missing: ${missing.join(', ')}';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMsg, style: TextStyle(color: Colors.red, fontFamily: 'Silkscreen'))));
      return;
    }

    final captain =
        Provider.of<CaptainProvider>(context, listen: false).captain;
    if (captain == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No captain profile found. Please create a profile first.', style: TextStyle(color: Colors.white, fontFamily: 'Silkscreen')
          ),
        ),
      );
      return;
    }

    // If all fields are filled, proceed to save the loadout
    final ship = _buildShip(captain);
    // Call the provider to save the loadout if new
    // Otherwise, update the existing loadout
    final loadoutProvider = Provider.of<LoadoutProvider>(
      context,
      listen: false,
    );
    if (_isEditing) {
      await loadoutProvider.updateLoadout(ship);
    } else {
      await loadoutProvider.addLoadout(ship);
    }

    if (!mounted) return;

    // Show success message
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Loadout saved to storage!', style: TextStyle(color: Colors.white, fontFamily: 'Silkscreen'))));

    // Navigate to the loadout screen after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      Navigator.pushNamed(context, '/loadout');
    });
  }

  Ship _buildShip(Captain captain) {
    // Generate a unique ID for the ship if new
    // Otherwise, use the existing ID
    final id = _existingId ?? const Uuid().v4();

    // Convert selected string to ShipClass enum
    final ShipClass shipClass = _selectedShipClass!;

    // Get the ship image path based on the selected ship class
    final shipImagePath = 'assets/images/player_ships/${shipClass.name}.png';

    // Get the selected module stats from the maps
    final hullStats = hullData[_selectedHullType!]!;
    final armourStats = armourData[_selectedArmourType!]!;
    final shieldStats = shieldData[_selectedShieldType!]!;
    final thrusterStats = thrusterData[_selectedThrusterType!]!;

    // Create the ship object with the selected modules and stats
    return Ship(
      id: id,
      name: _nameController.text,
      captainId: captain.id,
      shipImagePath: shipImagePath,
      shipClass: shipClass,
      hull: Hull(
        name: hullStats.name,
        description: hullStats.description,
        type: _selectedHullType!,
        maxHP: hullStats.maxHP,
        evasion: hullStats.evasion,
        kineticDR: hullStats.kineticDR,
        energyDR: hullStats.energyDR,
        explosiveDR: hullStats.explosiveDR,
        compatibleArmours: hullStats.compatibleArmours,
      ),
      armour: Armour(
        name: armourStats.name,
        description: armourStats.description,
        type: _selectedArmourType!,
        maxAP: armourStats.maxAP,
        kineticDR: armourStats.kineticDR,
        energyDR: armourStats.energyDR,
        explosiveDR: armourStats.explosiveDR,
        special: armourStats.special,
      ),
      shield: Shield(
        name: shieldStats.name,
        description: shieldStats.description,
        type: _selectedShieldType!,
        maxSP: shieldStats.maxSP,
        kineticDR: shieldStats.kineticDR,
        energyDR: shieldStats.energyDR,
        explosiveDR: shieldStats.explosiveDR,
      ),
      thruster: Thruster(
        name: thrusterStats.name,
        description: thrusterStats.description,
        type: _selectedThrusterType!,
        initiative: thrusterStats.initiative,
        bonus: thrusterStats.bonus,
        bonusValue: thrusterStats.bonusValue,
        compatibleClasses: thrusterStats.compatibleClasses,
      ),
      // Selecting multiple weapons
      weapons:
          _selectedWeapons.map((weaponType) {
            final weaponStats = weaponData[weaponType]!;
            return Weapon(
              name: weaponStats.name,
              description: weaponStats.description,
              type: weaponType,
              damageType: weaponStats.damageType,
              baseDamage: weaponStats.baseDamage,
              hitChance: weaponStats.hitChance,
            );
          }).toList(),
      captain: captain,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            children: [
              const Text(
                'Ship Builder',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'SuperTechnology',
                ),
              ),
              const SizedBox(height: 24),

              // Loadout Name
              TextField(
                key: const Key('loadout_name_input'),
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Loadout Name',
                  labelStyle: TextStyle(fontFamily: 'PressStart2P'),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'PressStart2P',
                ),
              ),
              const SizedBox(height: 16),

              // Ship Class Dropdown
              DropdownButtonFormField<ShipClass>(
                key: const Key('ship_class_dropdown'),
                value: _selectedShipClass,
                decoration: const InputDecoration(
                  labelText: 'Ship Class',
                  labelStyle: TextStyle(fontFamily: 'PressStart2P'),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                ),
                items:
                    shipClasses.map((shipClass) {
                      final label =
                          shipClass.name[0].toUpperCase() +
                          shipClass.name.substring(1);
                      return DropdownMenuItem(
                        value: shipClass,
                        child: Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'PressStart2P',
                          ),
                        ),
                      );
                    }).toList(),
                onChanged: (ShipClass? value) {
                  setState(() {
                    _selectedShipClass = value;
                  });
                },
                dropdownColor: Colors.grey[900],
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'PressStart2P',
                ),
              ),
              const SizedBox(height: 24),

              // Weapons & Modules Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    key: const Key('weapons_button'),
                    onPressed: () {
                      // Verify if a ship class is selected before proceeding
                      if (_selectedShipClass == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a ship class first', style: TextStyle(color: Colors.white, fontFamily: 'Silkscreen')),
                          ),
                        );
                        return;
                      }

                      // Use dummy data for hull, armour, shield, and thruster for the weapon picker
                      final dummyHull = hullData[HullType.aurasteel]!.toHull(
                        HullType.aurasteel,
                      );
                      final dummyArmour = armourData[ArmourType.ironshroud]!
                          .toArmour(ArmourType.ironshroud);
                      final dummyShield = shieldData[ShieldType.aegis]!
                          .toShield(ShieldType.aegis);
                      final dummyThruster = thrusterData[ThrusterType.standard]!
                          .toThruster(ThrusterType.standard);
                      final dummyCaptain =
                          Provider.of<CaptainProvider>(
                            context,
                            listen: false,
                          ).captain;

                      // Weapon picker widget
                      showDialog(
                        context: context,
                        builder:
                            (context) => WeaponPicker(
                              // Pass in dummy data for hull, armour, shield, and thruster to calculate max slots based on user selection
                              maxSlots:
                                  Ship(
                                    id: _existingId ?? '',
                                    name: _nameController.text,
                                    captainId: '',
                                    shipImagePath: '',
                                    shipClass: _selectedShipClass!,
                                    hull:
                                        _selectedHullType != null
                                            ? hullData[_selectedHullType!]!
                                                .toHull(_selectedHullType!)
                                            : dummyHull,
                                    armour:
                                        _selectedArmourType != null
                                            ? armourData[_selectedArmourType!]!
                                                .toArmour(_selectedArmourType!)
                                            : dummyArmour,
                                    shield:
                                        _selectedShieldType != null
                                            ? shieldData[_selectedShieldType!]!
                                                .toShield(_selectedShieldType!)
                                            : dummyShield,
                                    thruster:
                                        _selectedThrusterType != null
                                            ? thrusterData[_selectedThrusterType!]!
                                                .toThruster(
                                                  _selectedThrusterType!,
                                                )
                                            : dummyThruster,
                                    weapons: [],
                                    captain: dummyCaptain!,
                                  ).maxWeaponSlots ??
                                  1,
                              initialWeapon: _selectedWeapons,
                              onSelected: (selectedList) {
                                setState(() {
                                  _selectedWeapons = selectedList;
                                });
                              },
                            ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Text(
                      'Weapons',
                      style: TextStyle(fontFamily: 'PressStart2P'),
                    ),
                  ),
                  ElevatedButton(
                    key: const Key('modules_button'),
                    onPressed: () {
                      // Verify if a ship class is selected before proceeding
                      if (_selectedShipClass == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a ship class first', style: TextStyle(color: Colors.white, fontFamily: 'Silkscreen')),
                          ),
                        );
                        return;
                      }
                      // Module Picker widget
                      showDialog(
                        context: context,
                        builder:
                            (context) => ModulePicker(
                              initialHull: _selectedHullType,
                              initialArmour: _selectedArmourType,
                              initialShield: _selectedShieldType,
                              initialThruster: _selectedThrusterType,
                              onSelected: ({
                                required HullType hull,
                                required ArmourType armour,
                                required ShieldType shield,
                                required ThrusterType thruster,
                              }) {
                                setState(() {
                                  _selectedHullType = hull;
                                  _selectedArmourType = armour;
                                  _selectedShieldType = shield;
                                  _selectedThrusterType = thruster;
                                });
                              },
                            ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Text(
                      'Modules',
                      style: TextStyle(fontFamily: 'PressStart2P'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Ship Stats
              Expanded(
                child: ShipStatsWidget(
                  key: const Key('ship_stats_widget'),
                  // Pass in the appropriate stats based on user selections
                  // Hull
                  hull:
                      _selectedHullType != null
                          ? hullData[_selectedHullType!]!.toHull(
                            _selectedHullType!,
                          )
                          : null,
                  // Armour
                  armour:
                      _selectedArmourType != null
                          ? armourData[_selectedArmourType!]!.toArmour(
                            _selectedArmourType!,
                          )
                          : null,
                  // Shield
                  shield:
                      _selectedShieldType != null
                          ? shieldData[_selectedShieldType!]!.toShield(
                            _selectedShieldType!,
                          )
                          : null,
                  // Thruster
                  thruster:
                      _selectedThrusterType != null
                          ? thrusterData[_selectedThrusterType!]!.toThruster(
                            _selectedThrusterType!,
                          )
                          : null,
                  // Weapons
                  weapons:
                      _selectedWeapons.map((type) {
                        final stats = weaponData[type]!;
                        return Weapon(
                          name: stats.name,
                          description: stats.description,
                          type: type,
                          damageType: stats.damageType,
                          baseDamage: stats.baseDamage,
                          hitChance: stats.hitChance,
                        );
                      }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Save Loadout
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  key: const Key('save_loadout_button'),
                  onPressed: _saveLoadout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: const Text('Save Loadout', 
                    style: TextStyle(
                      fontFamily: 'PressStart2P',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
