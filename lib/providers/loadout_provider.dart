import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ghostnet/models/ship/ship.dart';

// Provider to manage loadouts in memory and persistent storage
class LoadoutProvider with ChangeNotifier {
  // List of saved ships/loadouts
  final List<Ship> _loadouts = [];

  // Unmodifiable list of loadouts for external access
  List<Ship> get loadouts => List.unmodifiable(_loadouts);

  // Load loadouts for a specific captain
  List<Ship> loadoutsForCaptain(String captainId) =>
      _loadouts.where((s) => s.captainId == captainId).toList();

  /// Adds a loadout to memory and persistent storage
  Future<void> addLoadout(Ship loadout) async {
    // Add to internal list and refresh UI
    _loadouts.add(loadout);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList('savedLoadouts') ?? [];

    // Convert to JSON and add to existing list
    final loadoutJson = jsonEncode(loadout.toJson());
    existing.add(loadoutJson);

    await prefs.setStringList('savedLoadouts', existing);
  }

  /// Updates a loadout (in memory and storage)
  Future<void> updateLoadout(Ship updated) async {
    final index = _loadouts.indexWhere((s) => s.id == updated.id);
    if (index != -1) {
      _loadouts[index] = updated;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final updatedList = _loadouts.map((s) => jsonEncode(s.toJson())).toList();
      await prefs.setStringList('savedLoadouts', updatedList);
    }
  }

  /// Removes a loadout (from memory and storage)
  Future<void> removeLoadout(Ship loadout) async {
    // Remove from internal list and refresh UI
    _loadouts.removeWhere((s) => s.id == loadout.id);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    // Re-encode the remaining loadouts to JSON and save
    final updated = _loadouts.map((s) => jsonEncode(s.toJson())).toList();
    await prefs.setStringList('savedLoadouts', updated);
  }
  
  /// Deletes a loadout by ID (from memory and storage)
  Future<void> deleteLoadout(String id) async {
    _loadouts.removeWhere((s) => s.id == id);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final updated = _loadouts.map((s) => jsonEncode(s.toJson())).toList();
    await prefs.setStringList('savedLoadouts', updated);
  }

  /// Clears all loadouts (memory + storage)
  Future<void> clearAll() async {
    // Clear internal list and refresh UI
    _loadouts.clear();
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('savedLoadouts');
  }

  /// Load existing saved loadouts from SharedPreferences
  Future<void> loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('savedLoadouts') ?? [];

    // Clear the current loadouts and add the loaded ones from JSON in storage
    _loadouts
      ..clear()
      ..addAll(saved.map((s) => Ship.fromJson(jsonDecode(s))));
    // Refresh the UI
    notifyListeners();
  }

  /// Load loadouts for a specific captain from SharedPreferences
  Future<void> loadLoadoutsForCaptain(String captainId) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('savedLoadouts') ?? [];

    _loadouts
      ..clear()
      ..addAll(
        saved.map((s) => Ship.fromJson(jsonDecode(s))).where((ship) => ship.captainId == captainId),
      );

    notifyListeners();
  }
}
