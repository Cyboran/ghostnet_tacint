import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghostnet/models/weapon/weapon_type.dart';
import 'package:ghostnet/widgets/module_description.dart';
import 'package:ghostnet/widgets/weapon_picker.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WeaponPicker Widget', () {
    setUpAll(() {
    });

    // The Widget should display a list of weapons
    testWidgets('Displays weapon list and handles selection', (WidgetTester tester) async {
      List<WeaponType> selectedWeapons = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: WeaponPicker(
              maxSlots: 2,
              initialWeapon: [],
              onSelected: (weapons) => selectedWeapons = weapons,
            ),
          ),
        ),
      );

      expect(find.textContaining('Select Weapons'), findsOneWidget);

      // Tap on first weapon
      await tester.tap(find.byType(ListTile).first);
      await tester.pump();

      // Find selected square box with tealAccent color
      final selectedBox = tester.widgetList<Container>(find.byType(Container)).where((container) {
        final decoration = container.decoration;
        return decoration is BoxDecoration &&
            decoration.shape == BoxShape.rectangle &&
            decoration.color == Colors.tealAccent;
      });

      expect(
        selectedBox.length,
        greaterThan(0),
        reason: 'Selected weapon should have a square tealAccent box.',
      );

      // Tap SAVE and verify callback
      await tester.tap(find.text('SAVE'));
      await tester.pumpAndSettle();

      expect(selectedWeapons.length, 1);
    });

    // If maxSlots is 1, and the user tries to select more than 1 weapon, it should show a snackbar
    testWidgets('Enforces max slot limit with snackbar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeaponPicker(
              maxSlots: 1,
              initialWeapon: [],
              onSelected: (_) {},
            ),
          ),
        ),
      );

      // Select two weapons
      await tester.tap(find.byType(ListTile).at(0));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ListTile).at(1));
      await tester.pumpAndSettle();

      expect(find.textContaining('Max 1 weapons allowed.'), findsOneWidget);
    });

    // Test that the initial selected weapons are marked correctly
    testWidgets('Initial selected weapons are marked correctly', (WidgetTester tester) async {
      final initial = [WeaponType.kineticCannon];

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: WeaponPicker(
              maxSlots: 2,
              initialWeapon: initial,
              onSelected: (_) {},
            ),
          ),
        ),
      );

      // Find all square selection boxes (Container with BoxDecoration and color filled)
      final selectedBox = tester.widgetList<Container>(find.byType(Container)).where((container) {
        final decoration = container.decoration;
        return decoration is BoxDecoration &&
            decoration.shape == BoxShape.rectangle &&
            decoration.color == Colors.tealAccent;
      });

      // Expect at least one matching square selection box
      expect(selectedBox.length, greaterThan(0));
    });

    // Weapon description should be shown in a dialog when the image is tapped
    testWidgets('Shows weapon description dialog on image tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: WeaponPicker(
              maxSlots: 2,
              initialWeapon: [],
              onSelected: (_) {},
            ),
          ),
        ),
      );

      // Tap image to trigger ModuleDescription
      final image = find.byType(Image).first;
      await tester.tap(image);
      await tester.pumpAndSettle();

      expect(find.byType(ModuleDescription), findsOneWidget);
    });
  });
}
