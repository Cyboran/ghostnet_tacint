import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghostnet/models/profile/captain.dart';
import 'package:ghostnet/models/ship/ship.dart';
import 'package:ghostnet/models/ship/ship_class.dart';
import 'package:ghostnet/models/defence/armour_stats.dart';
import 'package:ghostnet/models/defence/armour_extensions.dart';
import 'package:ghostnet/models/defence/armour_type.dart';
import 'package:ghostnet/models/defence/hull_stats.dart';
import 'package:ghostnet/models/defence/hull_extensions.dart';
import 'package:ghostnet/models/defence/hull_type.dart';
import 'package:ghostnet/models/defence/shield_stats.dart';
import 'package:ghostnet/models/defence/shield_extensions.dart';
import 'package:ghostnet/models/defence/shield_type.dart';
import 'package:ghostnet/models/module/thruster_stats.dart';
import 'package:ghostnet/models/module/thruster_extensions.dart';
import 'package:ghostnet/models/module/thruster_type.dart';
import 'package:ghostnet/models/weapon/weapon_stats.dart';
import 'package:ghostnet/models/weapon/weapon_extensions.dart';
import 'package:ghostnet/models/weapon/weapon_type.dart';
import 'package:ghostnet/providers/captain_provider.dart';
import 'package:ghostnet/providers/loadout_provider.dart';
import 'package:ghostnet/screens/loadout_screen.dart';
import 'package:provider/provider.dart';

/// Mock CaptainProvider that returns a static captain
class MockCaptainProvider extends CaptainProvider {
  @override
  Captain? get captain => Captain(
        id: 'cap-001',
        username: 'mockuser',
        password: 'mockpass',
        name: 'Captain Test',
        title: 'The Iron Vanguard',
        faction: 'Test Fleet',
        profileImagePath: 'assets/images/default_profile.png',
      );
}

/// Mock LoadoutProvider for test scenarios
class MockLoadoutProvider extends LoadoutProvider {
  final bool withLoadouts;

  MockLoadoutProvider({this.withLoadouts = true});

  @override
  List<Ship> get loadouts => withLoadouts
      ? [
          Ship(
            id: 'test-id',
            name: 'Mock Battleship',
            captainId: 'cap-001',
            shipImagePath: 'assets/images/ship_sample.gif',
            shipClass: ShipClass.battleship,
            hull: hullData[HullType.siegeplate]!.toHull(HullType.siegeplate),
            armour: armourData[ArmourType.ironshroud]!.toArmour(ArmourType.ironshroud),
            shield: shieldData[ShieldType.aegis]!.toShield(ShieldType.aegis),
            thruster: thrusterData[ThrusterType.standard]!.toThruster(ThrusterType.standard),
            weapons: [
              weaponData[WeaponType.energyBeam]!.toWeapon(WeaponType.energyBeam),
            ],
            captain: Captain(
              id: 'cap-001',
              username: 'mockuser',
              password: 'mockpass',
              name: 'Captain Test',
              title: 'The Iron Vanguard',
              faction: 'Test Fleet',
              profileImagePath: 'assets/images/default_profile.png',
            ),
          )
        ]
      : [];
}

// Builds LoadoutScreen with necessary providers and routing
Widget buildTestableWidget({
  required LoadoutProvider loadoutProvider,
  required CaptainProvider captainProvider,
  RouteFactory? onGenerateRoute,
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<LoadoutProvider>.value(value: loadoutProvider),
      ChangeNotifierProvider<CaptainProvider>.value(value: captainProvider),
    ],
    child: MaterialApp(
      onGenerateRoute: onGenerateRoute,
      home: const LoadoutScreen(),
    ),
  );
}

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  // Title and buttons are displayed correctly
  testWidgets('Displays title and buttons', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(
      loadoutProvider: MockLoadoutProvider(),
      captainProvider: MockCaptainProvider(),
    ));

    expect(find.text('Ship Loadouts'), findsOneWidget);
    expect(find.text('Begin Battle'), findsOneWidget);
    expect(find.text('New Loadout'), findsOneWidget);
  });

  // If there are no loadouts, it should show a message and disable the button
  testWidgets('Handles empty loadout list', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(
      loadoutProvider: MockLoadoutProvider(withLoadouts: false),
      captainProvider: MockCaptainProvider(),
    ));

    expect(find.text('No loadouts saved.'), findsOneWidget);
    expect(tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Begin Battle')).enabled, isFalse);
  });

  // Check if the loadout list is displayed and selected correctly
  testWidgets('Displays and selects loadout correctly', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(
      loadoutProvider: MockLoadoutProvider(),
      captainProvider: MockCaptainProvider(),
    ));

    // Expect the mock loadout to be present
    expect(find.text('Mock Battleship'), findsOneWidget);

    // Tap the loadout button and confirm it's selected
    await tester.tap(find.text('Mock Battleship'));
    await tester.pump();
    expect(find.textContaining('Currently showing: Mock Battleship'), findsOneWidget);
  });

  // Navigate to battle screen when "Begin Battle" is tapped
  testWidgets('Navigates to /battle with selected loadout', (WidgetTester tester) async {
    Object? passedArgument;

    await tester.pumpWidget(buildTestableWidget(
      loadoutProvider: MockLoadoutProvider(),
      captainProvider: MockCaptainProvider(),
      onGenerateRoute: (settings) {
        if (settings.name == '/battle') {
          passedArgument = settings.arguments;
          return MaterialPageRoute(builder: (_) => const Scaffold(body: Text('Battle Screen')));
        }
        return null;
      },
    ));

    await tester.tap(find.text('Begin Battle'));
    await tester.pumpAndSettle();

    expect(passedArgument, isA<Ship>());
    expect(find.text('Battle Screen'), findsOneWidget);
  });

  // Navigate to ship builder screen when "New Loadout" is tapped
  testWidgets('Navigates to /builder on "New Loadout"', (WidgetTester tester) async {
    bool navigated = false;

    await tester.pumpWidget(buildTestableWidget(
      loadoutProvider: MockLoadoutProvider(),
      captainProvider: MockCaptainProvider(),
      onGenerateRoute: (settings) {
        if (settings.name == '/builder') {
          navigated = true;
          return MaterialPageRoute(builder: (_) => const Scaffold(body: Text('Builder Screen')));
        }
        return null;
      },
    ));

    await tester.tap(find.text('New Loadout'));
    await tester.pumpAndSettle();

    expect(navigated, isTrue);
    expect(find.text('Builder Screen'), findsOneWidget);
  });

  // Display the profile card widget with captain details
  testWidgets('Displays captain profile card', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(
      loadoutProvider: MockLoadoutProvider(),
      captainProvider: MockCaptainProvider(),
    ));

    expect(find.byType(ClipRRect), findsOneWidget);
    expect(find.text('Captain Test'), findsOneWidget);
  });
}