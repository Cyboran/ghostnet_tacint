import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghostnet/models/defence/armour_extensions.dart';
import 'package:ghostnet/models/defence/armour_stats.dart';
import 'package:ghostnet/models/defence/armour_type.dart';
import 'package:ghostnet/models/defence/hull_extensions.dart';
import 'package:ghostnet/models/defence/hull_stats.dart';
import 'package:ghostnet/models/defence/hull_type.dart';
import 'package:ghostnet/models/defence/shield_extensions.dart';
import 'package:ghostnet/models/defence/shield_stats.dart';
import 'package:ghostnet/models/defence/shield_type.dart';
import 'package:ghostnet/models/module/thruster_extensions.dart';
import 'package:ghostnet/models/module/thruster_stats.dart';
import 'package:ghostnet/models/module/thruster_type.dart';
import 'package:ghostnet/models/ship/ship.dart';
import 'package:ghostnet/models/ship/ship_class.dart';
import 'package:ghostnet/screens/ship_builder_screen.dart';
import 'package:ghostnet/providers/loadout_provider.dart';
import 'package:ghostnet/providers/captain_provider.dart';
import 'package:ghostnet/models/profile/captain.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ShipBuilderScreen Widget Tests', () {
    late Captain testCaptain;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      testCaptain = Captain(
        id: 'captain-id',
        username: 'testuser',
        password: 'pass',
        name: 'Nyx',
        title: 'Warden',
        faction: 'Syndicate',
        profileImagePath: 'assets/images/default_profile.png',
      );
    });

    Widget createTestWidget({Ship? existingShip}) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<CaptainProvider>(
            create: (_) => CaptainProvider()..saveCaptain(testCaptain),
          ),
          ChangeNotifierProvider<LoadoutProvider>(
            create: (_) => LoadoutProvider(),
          ),
        ],
        child: MaterialApp(
          home: ShipBuilderScreen(existingShip: existingShip),
        ),
      );
    }

    testWidgets('renders ShipBuilderScreen correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Ship Builder'), findsOneWidget);
      expect(find.text('Save Loadout'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('shows error if required fields are missing', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('Save Loadout'));
      await tester.pump(); // allow snackbar to show

      expect(find.textContaining('Missing:'), findsOneWidget);
    });

    testWidgets('prepopulates fields when editing', (tester) async {
      final ship = Ship(
        id: 'ship-1',
        name: 'Test Ship',
        captainId: testCaptain.id,
        shipImagePath: 'assets/images/ship_sample.gif',
        shipClass: ShipClass.frigate,
        hull: hullData[HullType.siegeplate]!.toHull(HullType.siegeplate),
        armour: armourData[ArmourType.ironshroud]!.toArmour(ArmourType.ironshroud),
        shield: shieldData[ShieldType.aegis]!.toShield(ShieldType.aegis),
        thruster: thrusterData[ThrusterType.standard]!.toThruster(ThrusterType.standard),
        weapons: [],
        captain: testCaptain,
      );

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => CaptainProvider()..saveCaptain(testCaptain)),
            ChangeNotifierProvider(create: (_) => LoadoutProvider()),
          ],
          child: MaterialApp(
            onGenerateRoute: (_) => MaterialPageRoute(
              settings: RouteSettings(arguments: ship), // THIS is the key
              builder: (_) => const ShipBuilderScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final nameField = find.byKey(const Key('loadout_name_input'));
      final textFieldWidget = tester.widget<TextField>(nameField);
      expect(textFieldWidget.controller?.text, equals('Test Ship'));
    });
  });
}
