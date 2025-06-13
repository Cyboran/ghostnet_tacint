import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ghostnet/providers/captain_provider.dart';
import 'package:ghostnet/models/profile/captain.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('CaptainProvider Tests', () {
    late CaptainProvider provider;
    late Captain testCaptain;

    // Set up a fresh provider and mock captain for each test
    setUp(() {
      SharedPreferences.setMockInitialValues({});
      provider = CaptainProvider();

      testCaptain = Captain(
        id: const Uuid().v4(),
        username: 'TestUser',
        password: 'SecurePass123',
        name: 'Nyx',
        title: 'Warden',
        faction: 'Syndicate',
        profileImagePath: 'assets/images/default_profile.png',
      );
    });

    // Saving a captain profile and loading it back should return the same captain
    test('Save and load captain profile', () async {
      await provider.saveCaptain(testCaptain);

      // Should hash password internally
      expect(provider.captain, isNotNull);
      expect(provider.captain!.username, 'testuser');
      expect(provider.captain!.name, 'Nyx');

      // Create a new instance and load from storage
      final newProvider = CaptainProvider();
      await newProvider.loadCaptain('TestUser');

      expect(newProvider.captain, isNotNull);
      expect(newProvider.captain!.name, 'Nyx');
    });

    // Checking to see if the username is taken should return true for the saved captain
    test('Check for taken username', () async {
      await provider.saveCaptain(testCaptain);
      final isTaken = await provider.isUsernameTaken('TestUser');
      expect(isTaken, isTrue);
    });

    // Validating login credentials should return the correct captain for valid credentials
    test('Validate login credentials (correct)', () async {
      await provider.saveCaptain(testCaptain);
      final loginResult = await provider.validateLogin('TestUser', 'SecurePass123');
      expect(loginResult, isNotNull);
      expect(loginResult!.username, 'testuser');
    });

    // Validating login credentials should return null for incorrect credentials
    test('Validate login credentials (incorrect)', () async {
      await provider.saveCaptain(testCaptain);
      final result = await provider.validateLogin('TestUser', 'WrongPassword');
      expect(result, isNull);
    });

    // Clearing the current captain should set the captain to null
    test('Clear captain profile', () async {
      await provider.saveCaptain(testCaptain);
      provider.clearCurrentCaptain();
      expect(provider.captain, isNull);
    });

    // Checking if the profile is complete should return true if all fields are filled
    test('Profile completion check', () async {
      await provider.saveCaptain(testCaptain);
      expect(provider.isProfileComplete, isTrue);

      provider.clearCurrentCaptain();
      expect(provider.isProfileComplete, isFalse);
    });

    // Check if password is hashed in storage and not stored in plain text
    test('Password is hashed in storage, not stored in plain text', () async {
      await provider.saveCaptain(testCaptain);

      final prefs = await SharedPreferences.getInstance();
      final storedList = prefs.getStringList('captainProfiles')!;
      final storedJson = storedList.first;
      expect(storedJson.contains('SecurePass123'), isFalse); // raw password must not appear
    });
  });
}