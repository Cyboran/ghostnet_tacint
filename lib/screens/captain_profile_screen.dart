import 'package:flutter/material.dart';
import 'package:ghostnet/models/profile/captain.dart';
import 'package:ghostnet/models/profile/faction_info.dart';
import 'package:ghostnet/models/profile/faction_type.dart';
import 'package:ghostnet/providers/captain_provider.dart';
import 'package:ghostnet/widgets/profile_image_selector.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CaptainProfileScreen extends StatefulWidget {
  const CaptainProfileScreen({super.key});

  @override
  State<CaptainProfileScreen> createState() => _CaptainProfileScreenState();
}

class _CaptainProfileScreenState extends State<CaptainProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  String? _selectedFaction;
  String? _profileImagePath;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();

    // Delay to ensure context is ready
    Future.microtask(() {
      if (!mounted) return;
      final captain = Provider.of<CaptainProvider>(context, listen: false).captain;
      if (captain != null) {
        _nameController.text = captain.name;
        _usernameController.text = captain.username;
        _passwordController.text = '';
        _titleController.text = captain.title;
        _selectedFaction = captain.faction;
        _profileImagePath = captain.profileImagePath;

        // Also update state to refresh dropdown
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  // Save the captain profile to local storage via the provider
  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final existingCaptain = Provider.of<CaptainProvider>(context, listen: false).captain;

      final captain = Captain(
        // Preserve existing ID if it exists, otherwise generate a new one
        id: existingCaptain?.id ?? const Uuid().v4(),
        username: _usernameController.text,
        password: _passwordController.text,
        name: _nameController.text,
        title: _titleController.text,
        faction: _selectedFaction!,
        profileImagePath: _profileImagePath ?? 'assets/images/default_profile.png',
      );

      // Check if the username is already taken
      final isTaken = await Provider.of<CaptainProvider>(context, listen: false)
          .isUsernameTaken(_usernameController.text);

      if (isTaken && existingCaptain == null) {
        if (!mounted) return;
        // Show a snackbar if the username is already taken
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username is already taken', style: TextStyle(color: Colors.red, fontFamily: 'Silkscreen'))),
        );
        return;
      }

      if (!mounted) return;

      await Provider.of<CaptainProvider>(context, listen: false).saveCaptain(captain);

      if (!mounted) return;
      Navigator.pushNamed(context, '/home');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Page Title
                  const SizedBox(height: 10),
                  const Text(
                    'Captain Profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                      fontFamily: 'SuperTechnology',
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Profile Image
                  ProfileImageSelector(
                    key: const Key('profileImageSelector'),
                    initialImagePath: _profileImagePath,
                    onImageSelected: (newPath) {
                      setState(() {
                        _profileImagePath = newPath;
                      });
                    },
                  ),
                  const SizedBox(height: 30),

                  // Name Field
                  TextFormField(
                    key: const Key('nameField'),
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Name',
                      labelStyle: TextStyle(
                        fontFamily: 'PressStart2P',
                      ),
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'PressStart2P',
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
                  ),
                  const SizedBox(height: 20),

                  // Title Field
                  TextFormField(
                    key: const Key('titleField'),
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Title',
                      labelStyle: TextStyle(
                        fontFamily: 'PressStart2P',
                      ),
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'PressStart2P',
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Please enter your title' : null,
                  ),
                  const SizedBox(height: 20),

                  // Username Field
                  TextFormField(
                    key: const Key('usernameField'),
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Username',
                      labelStyle: TextStyle(
                        fontFamily: 'PressStart2P',
                      ),
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'PressStart2P',
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Please enter your username' : null,
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  TextFormField(
                    key: const Key('passwordField'),
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Enter Password',
                      labelStyle: TextStyle(
                        fontFamily: 'PressStart2P',
                      ),
                      filled: true,
                      fillColor: Colors.white10,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'PressStart2P'
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Please enter your password' : null,
                  ),
                  const SizedBox(height: 20),

                  // Confirm Password Field
                  TextFormField(
                    key: const Key('confirmPasswordField'),
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(
                        fontFamily: 'PressStart2P',
                      ),
                      filled: true,
                      fillColor: Colors.white10,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'PressStart2P',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please confirm your password';
                      if (value != _passwordController.text) return 'Passwords do not match';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Faction Dropdown
                  DropdownButtonFormField<FactionType>(
                    key: const Key('factionDropdown'),
                    value: _selectedFaction != null
                        ? FactionType.values.firstWhere((f) => f.name == _selectedFaction)
                        : null,
                    decoration: const InputDecoration(
                      labelText: 'Choose Faction',
                      labelStyle: TextStyle(
                        fontFamily: 'PressStart2P',
                      ),
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    items: FactionType.values.map((factionType) {
                      final info = factionData[factionType]!;
                      return DropdownMenuItem<FactionType>(
                        value: factionType,
                        child: Text(info.name, style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'PressStart2P',
                        ),),
                      );
                    }).toList(),
                    onChanged: (selected) {
                      setState(() {
                        _selectedFaction = selected?.name;
                      });
                    },
                    dropdownColor: Colors.grey[900],
                    style: const TextStyle(color: Colors.white),
                    validator: (value) => value == null ? 'Please select a faction' : null,
                  ),
                  const SizedBox(height: 20),

                  // Save Profile Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      key: const Key('saveProfileButton'),
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'PressStart2P',
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: const Text('Save Profile'),
                    ),
                  )
                ],
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}
