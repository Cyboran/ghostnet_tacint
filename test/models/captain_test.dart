import 'package:flutter_test/flutter_test.dart';
import 'package:ghostnet/models/profile/captain.dart';

void main() {
  group('Captain Model Tests', () {
    late Captain captain;

    // Set up a Captain instance before each test
    setUp(() {
      captain = Captain(
        id: 'captain-123',
        username: 'testuser',
        password: 'securepass',
        name: 'Nyx',
        title: 'Warden',
        faction: 'Syndicate',
        profileImagePath: 'assets/images/default_profile.png',
      );
    });

    // Constructor should assign values correctly
    test('Constructor assigns values correctly', () {
      expect(captain.id, 'captain-123');
      expect(captain.username, 'testuser');
      expect(captain.password, 'securepass');
      expect(captain.name, 'Nyx');
      expect(captain.title, 'Warden');
      expect(captain.faction, 'Syndicate');
      expect(captain.profileImagePath, 'assets/images/default_profile.png');
    });

    // Serializing to JSON should return a map with the same values
    test('Serializes to JSON correctly', () {
      final json = captain.toJson();
      expect(json['id'], 'captain-123');
      expect(json['username'], 'testuser');
      expect(json['password'], 'securepass');
      expect(json['name'], 'Nyx');
      expect(json['title'], 'Warden');
      expect(json['faction'], 'Syndicate');
      expect(json['profileImagePath'], 'assets/images/default_profile.png');
    });

    // Deserializing from JSON should return a Captain object with the same values
    test('Deserializes from JSON correctly', () {
      // Test data
      final json = {
        'id': 'captain-123',
        'username': 'testuser',
        'password': 'securepass',
        'name': 'Nyx',
        'title': 'Warden',
        'faction': 'Syndicate',
        'profileImagePath': 'assets/images/default_profile.png',
      };

      // Execute test
      final newCaptain = Captain.fromJson(json);
      expect(newCaptain.id, captain.id);
      expect(newCaptain.username, captain.username);
      expect(newCaptain.password, captain.password);
      expect(newCaptain.name, captain.name);
      expect(newCaptain.title, captain.title);
      expect(newCaptain.faction, captain.faction);
      expect(newCaptain.profileImagePath, captain.profileImagePath);
    });

    // Seralizing and deserializing should keep the data intact
    test('Round-trip serialization keeps data intact', () {
      final json = captain.toJson();
      final newCaptain = Captain.fromJson(json);
      expect(newCaptain.toJson(), captain.toJson());
    });
  });
}
