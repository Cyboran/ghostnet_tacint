import 'package:flutter/material.dart';
import 'package:ghostnet/providers/captain_provider.dart';
import 'package:ghostnet/providers/loadout_provider.dart';
import 'package:ghostnet/screens/battle_screen.dart';
import 'package:ghostnet/screens/captain_profile_screen.dart';
import 'package:ghostnet/screens/home_screen.dart';
import 'package:ghostnet/screens/loadout_screen.dart';
import 'package:ghostnet/screens/login_screen.dart';
import 'package:ghostnet/screens/ship_builder_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Adding required providers for state management
        ChangeNotifierProvider(create: (_) => LoadoutProvider()),
        ChangeNotifierProvider(create: (_) => CaptainProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

/// Main application widget that serves as the entry point for the app.
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Title of the app
      title: 'Tactical Interface: GhostNet',
      debugShowCheckedModeBanner: false,
      // Routes for navigation
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/builder': (context) => const ShipBuilderScreen(),
        '/profile': (context) => const CaptainProfileScreen(),
        '/battle': (context) => const BattleScreen(),
        '/loadout': (context) => const LoadoutScreen(),
      },
    );
  }
}