// This file defines the Captain class, which represents a captain in the game.
// The class contains properties such as name, title, faction, and profileImagePath.

class Captain {
  /// Player's captain id
  final String id;
  /// Player's username
  final String username;
  /// Player's password
  final String password;
  /// Player's captain name
  final String name;
  /// Player's captain title
  final String title;
  /// Player's captain faction
  final String faction;
  /// Player's captain profile image path
  final String profileImagePath;

  /// Save to json format for local storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'name': name,
      'title': title,
      'faction': faction,
      'profileImagePath': profileImagePath,
    };
  }
  
  /// Load from local storage in json format
  factory Captain.fromJson(Map<String, dynamic> json) {
    return Captain(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      name: json['name'],
      title: json['title'],
      faction: json['faction'],
      profileImagePath: json['profileImagePath'],
    );
  }

  /// Constructor for the Captain class
  Captain({
    required this.id,
    required this.username,
    required this.password,
    required this.name,
    required this.title,
    required this.faction,
    required this.profileImagePath,
  });
}
