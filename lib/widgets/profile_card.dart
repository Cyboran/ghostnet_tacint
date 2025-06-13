import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ghostnet/providers/captain_provider.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Load captain info from provider
    final captain = context.watch<CaptainProvider>().captain;

    // Fallback values if captain is for some reason null
    final displayName = captain?.name ?? 'Unnamed Captain';
    final displayTitle = captain?.title ?? 'Fleetless';
    final profileImage = captain?.profileImagePath ?? 'assets/images/default_profile.png';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.zero,
      ),
      child: Row(
        children: [
          // Profile image
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/profile'),
            child: ClipRRect(
              borderRadius: BorderRadius.zero,
              child: Image(
                image: profileImage.startsWith('assets/')
                    ? AssetImage(profileImage)
                    : FileImage(File(profileImage)) as ImageProvider,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.none,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Captain info
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/profile'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(displayName, style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Silkscreen',
                  )),
                  Text(displayTitle, style: const TextStyle(
                    color: Colors.white60,
                    fontFamily: 'Silkscreen',
                  )),
                ],
              ),
            ),
          ),
          // Logout button
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            tooltip: 'Logout',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.grey[900],
                  title: const Text('Confirm Logout', 
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'PressStart2P',
                      fontSize: 20
                    )
                  ),
                  content: const Text('Are you sure you want to log out?', style: TextStyle(
                      color: Colors.white70,
                      fontFamily: 'Silkscreen',
                    )
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      ),
                      child: const Text('Cancel', 
                        style: TextStyle(
                          fontFamily: 'Silkscreen',
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      ),
                      child: const Text('Logout',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontFamily: 'Silkscreen',
                        ),
                      ),
                    ),
                  ],
                ),
              );

              if (confirm == true && context.mounted) {
                Provider.of<CaptainProvider>(context, listen: false).logoutCaptain();
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              }
            },
          ),
        ],
      ),
    );
  }
}