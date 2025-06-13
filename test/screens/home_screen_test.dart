import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ghostnet/screens/home_screen.dart';
import 'package:ghostnet/models/profile/captain.dart';
import 'package:ghostnet/models/ship/ship.dart';
import 'package:ghostnet/models/ship/ship_class.dart';
import 'package:ghostnet/models/defence/hull_stats.dart';
import 'package:ghostnet/models/defence/hull_extensions.dart';
import 'package:ghostnet/models/defence/hull_type.dart';
import 'package:ghostnet/models/defence/armour_stats.dart';
import 'package:ghostnet/models/defence/armour_extensions.dart';
import 'package:ghostnet/models/defence/armour_type.dart';
import 'package:ghostnet/models/defence/shield_stats.dart';
import 'package:ghostnet/models/defence/shield_extensions.dart';
import 'package:ghostnet/models/defence/shield_type.dart';
import 'package:ghostnet/models/module/thruster_stats.dart';
import 'package:ghostnet/models/module/thruster_extensions.dart';
import 'package:ghostnet/models/module/thruster_type.dart';
import 'package:ghostnet/models/weapon/weapon_stats.dart';
import 'package:ghostnet/models/weapon/weapon_extensions.dart';
import 'package:ghostnet/models/weapon/weapon_type.dart';
import 'package:ghostnet/providers/loadout_provider.dart';
import 'package:ghostnet/providers/captain_provider.dart';

// Mock CaptainProvider that returns a static captain
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

// Mock LoadoutProvider that returns one valid ship if `withLoadouts` is true
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
              weaponData[WeaponType.kineticCannon]!.toWeapon(WeaponType.kineticCannon),
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

// Wraps HomeScreen with all required providers and routing
Widget buildTestableHome({
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
      home: const HomeScreen(),
    ),
  );
}

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  // Should display the app title and subtitle
  testWidgets('Displays app title', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestableHome(
        loadoutProvider: MockLoadoutProvider(),
        captainProvider: MockCaptainProvider(),
      ),
    );

    expect(find.text('TACTICAL INTERFACE:'), findsOneWidget);
    expect(find.text('GHOSTNET'), findsOneWidget);
  });

  // Should display the ship image from the first loadout
  testWidgets('Displays correct ship image depending on loadouts', (WidgetTester tester) async {
    // Load screen with one loadout
    await tester.pumpWidget(
      buildTestableHome(
        loadoutProvider: MockLoadoutProvider(withLoadouts: true),
        captainProvider: MockCaptainProvider(),
      ),
    );

    // Verify image for first loadout
    final firstImage = tester.widget<Image>(find.byKey(const Key('ship_image')));
    expect(firstImage.image, isA<AssetImage>());
    expect((firstImage.image as AssetImage).assetName, 'assets/images/ship_sample.gif');

    // Rebuild screen with empty loadouts
    await tester.pumpWidget(
      buildTestableHome(
        loadoutProvider: MockLoadoutProvider(withLoadouts: false),
        captainProvider: MockCaptainProvider(),
      ),
    );
    await tester.pumpAndSettle(); // important for layout and image updates

    // Verify fallback image is shown
    final fallbackImage = tester.widget<Image>(find.byKey(const Key('ship_image')));
    expect(fallbackImage.image, isA<AssetImage>());
    expect((fallbackImage.image as AssetImage).assetName, 'assets/images/empty_slot.png');
  });

  // Navigate to loadout screen when button is tapped
  testWidgets('Navigates to /loadout when "View Loadouts" is tapped', (WidgetTester tester) async {
    bool navigated = false;

    await tester.pumpWidget(
      buildTestableHome(
        loadoutProvider: MockLoadoutProvider(),
        captainProvider: MockCaptainProvider(),
        onGenerateRoute: (settings) {
          if (settings.name == '/loadout') {
            navigated = true;
            return MaterialPageRoute(builder: (_) => const Scaffold(body: Text('Loadout Screen')));
          }
          return null;
        },
      ),
    );

    await tester.tap(find.text('View Loadouts'));
    await tester.pumpAndSettle();

    expect(navigated, isTrue);
  });

  // Navigate to ship builder screen when button is tapped
  testWidgets('Navigates to /builder when "Ship Builder" is tapped', (WidgetTester tester) async {
    bool navigated = false;

    await tester.pumpWidget(
      buildTestableHome(
        loadoutProvider: MockLoadoutProvider(),
        captainProvider: MockCaptainProvider(),
        onGenerateRoute: (settings) {
          if (settings.name == '/builder') {
            navigated = true;
            return MaterialPageRoute(builder: (_) => const Scaffold(body: Text('Builder Screen')));
          }
          return null;
        },
      ),
    );

    await tester.tap(find.text('Ship Builder'));
    await tester.pumpAndSettle();

    expect(navigated, isTrue);
  });

  // Should display the ProfileCard widget
  testWidgets('ProfileCard widget is present', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestableHome(
        loadoutProvider: MockLoadoutProvider(),
        captainProvider: MockCaptainProvider(),
      ),
    );

    expect(find.byType(Row), findsWidgets);
  });
}