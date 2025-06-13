import 'package:flutter/material.dart';
import 'package:ghostnet/providers/loadout_provider.dart';
import 'package:provider/provider.dart';
import 'package:ghostnet/providers/captain_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _loginError;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final captainProvider = Provider.of<CaptainProvider>(context, listen: false);
      
      final success = await captainProvider.setActiveCaptainByCredentials(
        _usernameController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;

      // Valid input, proceed to home
      if (success) {
        final loadoutProvider = Provider.of<LoadoutProvider>(context, listen: false);
        await loadoutProvider.loadLoadoutsForCaptain(captainProvider.captain!.id);

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          _loginError = 'Invalid username or password';
        });
      }
    }
  }

  void _register() {
    // Redirect to profile creation (register) flow
    Navigator.pushNamed(context, '/profile');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/logo.png',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 20),
                  // Title
                  const Text(
                    'TACTICAL INTERFACE:',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SuperTechnology',
                    ),
                  ),
                  const Text(
                    'GHOSTNET',
                    style: TextStyle(
                      fontSize: 60,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SuperTechnology',
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Username field
                  TextFormField(
                    key: const Key('username_field'),
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
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
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  TextFormField(
                    key: const Key('password_field'),
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Error message
                  if (_loginError != null)
                    Text(
                      _loginError!,
                      style: const TextStyle(color: Colors.redAccent),
                    ),

                  const SizedBox(height: 24),

                  // Login button
                  ElevatedButton(
                    key: const Key('login_button'),
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 30,
                        fontFamily: 'PressStart2P',
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    ),
                    child: const Text('LOGIN'),
                  ),
                  const SizedBox(height: 20),

                  // Register button
                  TextButton(
                    key: const Key('register_button'),
                    onPressed: _register,
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 30,
                        fontFamily: 'PressStart2P',
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    ),
                    child: const Text('REGISTER'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}