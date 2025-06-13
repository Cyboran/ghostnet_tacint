import 'package:flutter/material.dart';
import 'package:ghostnet/widgets/loadout_summary.dart';
import 'package:provider/provider.dart';
import 'package:ghostnet/models/ship/ship.dart';
import 'package:ghostnet/providers/loadout_provider.dart';
import 'package:ghostnet/widgets/profile_card.dart';

class LoadoutScreen extends StatefulWidget {
  const LoadoutScreen({super.key});

  @override
  State<LoadoutScreen> createState() => _LoadoutScreenState();
}

class _LoadoutScreenState extends State<LoadoutScreen> {
  int selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    final loadoutProvider = context.watch<LoadoutProvider>();
    final List<Ship> loadouts = loadoutProvider.loadouts;

    // Clamp index if out of bounds
    int clampedIndex = selectedIndex;
    if (clampedIndex >= loadouts.length && loadouts.isNotEmpty) {
      clampedIndex = loadouts.length - 1;
    }

    if (clampedIndex != selectedIndex) {
      // Schedule the update after the current frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            selectedIndex = clampedIndex;
          });
        }
      });
    }

    final bool hasLoadouts = loadouts.isNotEmpty;
    final Ship? selectedLoadout = hasLoadouts ? loadouts[clampedIndex] : null;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ship Loadouts',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'SuperTechnology',
                ),
              ),
              const SizedBox(height: 16),
              // Horizontal Loadout Selector
              SizedBox(
                height: 50,
                child: hasLoadouts
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: loadouts.length,
                        itemBuilder: (context, index) {
                          final ship = loadouts[index];
                          final isSelected = index == selectedIndex;
                          return Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: OutlinedButton(
                              key: Key('loadout_button_$index'),
                              onPressed: () {
                                // Updates selected loadout and refreshes the UI
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor:
                                    isSelected ? Colors.white10 : Colors.transparent,
                                side: BorderSide(
                                  color: isSelected ? Colors.white : Colors.white30,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              child: SizedBox(
                                width: 100,
                                child: Text(
                                  ship.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.white, 
                                      fontFamily: 'PressStart2P',),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          'No loadouts saved.',
                          style: TextStyle(color: Colors.white54, fontFamily: 'Silkscreen'),
                        ),
                      ),
              ),
              const SizedBox(height: 24),

              // Loadout Summary Box
              Expanded(
                child: hasLoadouts
                    ? LoadoutSummary(
                        key: const Key('loadout_summary'),
                        loadout: selectedLoadout!)
                    : const Center(
                        child: Text(
                          'No loadout selected',
                          style: TextStyle(color: Colors.white54, fontFamily: 'Silkscreen'),
                        ),
                      ),
              ),

              // Begin Battle Button
              // Pass loadout data to the battle screen
              ElevatedButton(
                key: const Key('begin_battle_button'),
                onPressed: hasLoadouts
                    ? () => Navigator.pushNamed(
                          context,
                          '/battle',
                          arguments: selectedLoadout,
                        )
                    : null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: const Center(child: Text('Begin Battle', 
                  style: TextStyle(
                    fontFamily: 'PressStart2P',
                    fontSize: 16,
                  ),
                )),
              ),
              const SizedBox(height: 16),

              // New Loadout Button
              ElevatedButton(
                key: const Key('new_loadout_button'),
                onPressed: () => Navigator.pushNamed(context, '/builder'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: const Center(child: Text('New Loadout', 
                  style: TextStyle(
                    fontFamily: 'PressStart2P',
                    fontSize: 16,
                  ),
                )),
              ),
              const SizedBox(height: 24),

              // Profile Card Placeholder
              const ProfileCard(key: Key('profile_card_widget')),
            ],
          ),
        ),
      ),
    );
  }
}