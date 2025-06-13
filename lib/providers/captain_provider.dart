import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ghostnet/models/profile/captain.dart';

class CaptainProvider with ChangeNotifier {
  Captain? _captain;

  Captain? get captain => _captain;

  // Load captain profile from SharedPreferences
  Future<void> loadCaptain(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final allCaptains = prefs.getStringList('captainProfiles') ?? [];

    for (final json in allCaptains) {
      final captain = Captain.fromJson(jsonDecode(json));
      if (captain.username.toLowerCase().trim() == username.toLowerCase().trim()) {
        _captain = captain;
        notifyListeners();
        break;
      }
    }
  }

  /// Check if a username already exists
  Future<bool> isUsernameTaken(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final allCaptains = prefs.getStringList('captainProfiles') ?? [];

    if (username.trim().isEmpty) return false;

    return allCaptains.any((json) {
      final captain = Captain.fromJson(jsonDecode(json));
      return captain.username == username.toLowerCase().trim();
    });
  }

  // Save or update the captain profile
  Future<void> saveCaptain(Captain captain) async {
    final prefs = await SharedPreferences.getInstance();
    final allCaptains = prefs.getStringList('captainProfiles') ?? [];

    // Hash the password
    final hashedPassword = sha256.convert(utf8.encode(captain.password)).toString();
    final storedCaptain = Captain(
      id: captain.id,
      username: captain.username.toLowerCase().trim(),
      password: hashedPassword,
      name: captain.name,
      title: captain.title,
      faction: captain.faction,
      profileImagePath: captain.profileImagePath,
    );

    // Replace existing captain with same username, or add new one
    final updatedList = allCaptains.where((json) {
      final existing = Captain.fromJson(jsonDecode(json));
      return existing.username != storedCaptain.username;
    }).toList();

    updatedList.add(jsonEncode(storedCaptain.toJson()));
    await prefs.setStringList('captainProfiles', updatedList);

    _captain = storedCaptain;
    notifyListeners();
  }

  // Validate login credentials
  Future<Captain?> validateLogin(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final allCaptains = prefs.getStringList('captainProfiles') ?? [];
    final hashedInput = sha256.convert(utf8.encode(password)).toString();

    for (final json in allCaptains) {
      final captain = Captain.fromJson(jsonDecode(json));
      if (captain.username.toLowerCase().trim() == username.toLowerCase().trim() && captain.password == hashedInput) {
        _captain = captain;
        notifyListeners();
        return captain;
      }
    }

    return null;
  }

  void logoutCaptain() {
    _captain = null;
    notifyListeners();
  }

  // Set the active captain when user logs in
  Future<bool> setActiveCaptainByCredentials(String username, String password) async {
    final result = await validateLogin(username, password);
    return result != null;
  }

  // Clear current active profile
  void clearCurrentCaptain() {
    _captain = null;
    notifyListeners();
  }

  bool get isProfileComplete =>
      _captain != null &&
      _captain!.name.isNotEmpty &&
      _captain!.title.isNotEmpty &&
      _captain!.faction.isNotEmpty;
}
