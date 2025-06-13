import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghostnet/widgets/module_picker.dart';
import 'package:ghostnet/models/defence/hull_type.dart';
import 'package:ghostnet/models/defence/armour_type.dart';
import 'package:ghostnet/models/defence/shield_type.dart';
import 'package:ghostnet/models/module/thruster_type.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ModulePicker Widget', () {

    // Initializes with default values and calls onSelected on save, checks if the dropdowns are populated with the correct values
    testWidgets('initializes with provided values and calls onSelected on save', (tester) async {
      HullType? selectedHull;
      ArmourType? selectedArmour;
      ShieldType? selectedShield;
      ThrusterType? selectedThruster;
      
      // Expected names for the initial values
      final expectedHullName = HullType.aurasteel.name[0].toUpperCase() + HullType.aurasteel.name.substring(1);
      final expectedArmourName = ArmourType.aetherglint.name[0].toUpperCase() + ArmourType.aetherglint.name.substring(1);
      final expectedShieldName = ShieldType.aegis.name[0].toUpperCase() + ShieldType.aegis.name.substring(1);
      final expectedThrusterName = ThrusterType.highVelocity.name[0].toUpperCase() + ThrusterType.highVelocity.name.substring(1);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ModulePicker(
              initialHull: HullType.aurasteel,
              initialArmour: ArmourType.aetherglint,
              initialShield: ShieldType.aegis,
              initialThruster: ThrusterType.highVelocity,
              onSelected: ({
                required HullType hull,
                required ArmourType armour,
                required ShieldType shield,
                required ThrusterType thruster,
              }) {
                selectedHull = hull;
                selectedArmour = armour;
                selectedShield = shield;
                selectedThruster = thruster;
              },
            ),
          ),
        ),
      );

      // Verify all dropdowns contain their initial values (stringified)
      expect(find.textContaining(expectedHullName), findsOneWidget);
      expect(find.textContaining(expectedArmourName), findsOneWidget);
      expect(find.textContaining(expectedShieldName), findsOneWidget);
      expect(find.textContaining(expectedThrusterName), findsOneWidget);

      // Tap SAVE
      await tester.tap(find.text('SAVE'));
      await tester.pumpAndSettle();

      // Verify callback values
      expect(selectedHull, HullType.aurasteel);
      expect(selectedArmour, ArmourType.aetherglint);
      expect(selectedShield, ShieldType.aegis);
      expect(selectedThruster, ThrusterType.highVelocity);
    });

    // Check if the dropdowns are populated with the correct values
    testWidgets('dropdown changes update selected values', (tester) async {
      HullType? selectedHull;
      ArmourType? selectedArmour;

      // Expected names for the initial values
      final expectedHullName = HullType.voidframe.name[0].toUpperCase() + HullType.voidframe.name.substring(1);
      final expectedArmourName = ArmourType.lera.name[0].toUpperCase() + ArmourType.lera.name.substring(1);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ModulePicker(
              onSelected: ({
                required HullType hull,
                required ArmourType armour,
                required ShieldType shield,
                required ThrusterType thruster,
              }) {
                selectedHull = hull;
                selectedArmour = armour;
              },
            ),
          ),
        ),
      );

      // Change hull selection
      await tester.tap(find.byType(DropdownButtonFormField<HullType>).first);
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining(expectedHullName).last); // select Voidframe
      await tester.pumpAndSettle();

      // Change armour selection
      await tester.tap(find.byType(DropdownButtonFormField<ArmourType>).first);
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining(expectedArmourName).last); // select LERA (Krill)
      await tester.pumpAndSettle();

      await tester.tap(find.text('SAVE'));
      await tester.pumpAndSettle();

      expect(selectedHull, HullType.voidframe);
      expect(selectedArmour, ArmourType.lera);
    });
  });
}
