import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghostnet/providers/captain_provider.dart';
import 'package:ghostnet/screens/captain_profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('CaptainProfileScreen Widget Tests', () {
    late CaptainProvider captainProvider;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      captainProvider = CaptainProvider();
    });

    Future<void> pumpProfileScreen(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/home': (context) => const Scaffold(body: Text('Home Page')),
          },
          home: ChangeNotifierProvider<CaptainProvider>.value(
            value: captainProvider,
            child: const CaptainProfileScreen(),
          ),
        ),
      );
    }

    // Showing validation errors when fields are empty
    testWidgets('Shows validation errors when fields are empty', (tester) async {
      // Set test screen size
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1.0;

      await pumpProfileScreen(tester);
      await tester.tap(find.text('Save Profile'));
      await tester.pump();

      expect(find.text('Please enter your username'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);
      expect(find.text('Please enter your name'), findsOneWidget);
      expect(find.text('Please enter your title'), findsOneWidget);
      expect(find.text('Please select a faction'), findsOneWidget);

      addTearDown(() {
        // Clean up after test
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    // Showing validation errors when passwords are invalid and do not match
    testWidgets('Shows error when passwords do not match', (tester) async {
      // Set test screen size
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1.0;

      await pumpProfileScreen(tester);

      await tester.enterText(find.byKey(const Key('usernameField')), 'Nyx');
      await tester.enterText(find.byKey(const Key('passwordField')), 'abc123');
      await tester.enterText(find.byKey(const Key('confirmPasswordField')), 'def456');

      await tester.tap(find.text('Save Profile'));
      await tester.pump();

      expect(find.text('Passwords do not match'), findsOneWidget);

      addTearDown(() {
        // Clean up after test
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    // Submitting the form successfully and navigating to home
    testWidgets('Successfully submits form and navigates to home', (tester) async {
      // Set test screen size
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1.0;
      
      await pumpProfileScreen(tester);

      await tester.enterText(find.byKey(const Key('usernameField')), 'nyx');
      await tester.enterText(find.byKey(const Key('passwordField')), 'test123');
      await tester.enterText(find.byKey(const Key('confirmPasswordField')), 'test123');
      await tester.enterText(find.byKey(const Key('nameField')), 'Nyx');
      await tester.enterText(find.byKey(const Key('titleField')), 'Warden');

      await tester.tap(find.text('Choose Faction'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Syndicate').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save Profile'));
      await tester.pumpAndSettle();

      expect(find.text('Home Page'), findsOneWidget);

      addTearDown(() {
        // Clean up after test
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    testWidgets('toggles password visibility on icon press', (tester) async {
      // Set test screen size
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1.0;
      
      await pumpProfileScreen(tester);

      // Initially obscured
      final passwordField = find.byKey(const Key('passwordField'));
      final confirmField = find.byKey(const Key('confirmPasswordField'));

      // Tap visibility icon for password
      final toggleIcon = find.descendant(
        of: passwordField,
        matching: find.byIcon(Icons.visibility),
      );
      expect(toggleIcon, findsOneWidget);

      await tester.tap(toggleIcon);
      await tester.pump();

      // Tap visibility icon for confirm password
      final toggleConfirmIcon = find.descendant(
        of: confirmField,
        matching: find.byIcon(Icons.visibility),
      );
      expect(toggleConfirmIcon, findsOneWidget);

      await tester.tap(toggleConfirmIcon);
      await tester.pump();

      addTearDown(() {
        // Clean up after test
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });
  });
}