import 'package:flutter/material.dart';
import 'package:ghostnet/widgets/profile_card.dart';
import 'package:provider/provider.dart';
import 'package:ghostnet/providers/loadout_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Load captain and loadout info from providers
    final loadoutProvider = context.watch<LoadoutProvider>();
    final hasLoadouts = loadoutProvider.loadouts.isNotEmpty;

    // Get ship image from the first loadout if available, otherwise use a placeholder
    final shipImagePath = hasLoadouts
        ? loadoutProvider.loadouts.first.shipImagePath : 'assets/images/empty_slot.png';

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              const SizedBox(height: 32),

              // Title
              const Text(
                'TACTICAL INTERFACE:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontFamily: 'SuperTechnology',
                ),
              ),
              const Text(
                'GHOSTNET',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 56,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontFamily: 'SuperTechnology',
                ),
              ),
              const SizedBox(height: 20),

              // View Loadouts Button
              ElevatedButton(
                key: const Key('view_loadouts_button'),
                onPressed: () {
                  Navigator.pushNamed(context, '/loadout');
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: const Text('View Loadouts', 
                  style: TextStyle(
                    fontFamily: 'PressStart2P',
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Ship Image
              Expanded(
                child: Center(
                  child: Image.asset(
                    key: const Key('ship_image'),
                    shipImagePath,
                    fit: BoxFit.contain,
                    width: 200,
                    gaplessPlayback: true,
                  ),
                ),
              ),

              // Ship Builder Button
              ElevatedButton(
                key: const Key('ship_builder_button'),
                onPressed: () {
                  Navigator.pushNamed(context, '/builder');
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: const Text('Ship Builder', 
                  style: TextStyle(
                    fontFamily: 'PressStart2P',
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Profile Card Placeholder
              const ProfileCard(key: Key('profile_card_widget')),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}