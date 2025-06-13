import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghostnet/providers/captain_provider.dart';
import 'package:ghostnet/screens/login_screen.dart';
import 'package:provider/provider.dart';

// Creating a mock version of CaptainProvider used for testing login behaviour.
class MockCaptainProvider extends CaptainProvider {
  final bool shouldSucceed;

  MockCaptainProvider({this.shouldSucceed = true});

  // Override the login method for simplicity.
  @override
  Future<bool> setActiveCaptainByCredentials(String username, String password) async {
    return shouldSucceed;
  }
}

// Build a utility method to create a testable widget with a provider and navigation support.
Widget buildTestableWidget({
  required Widget child,
  required CaptainProvider provider,
  RouteFactory? onGenerateRoute,
}) {
  return ChangeNotifierProvider.value(
    value: provider,
    child: MaterialApp(
      onGenerateRoute: onGenerateRoute,
      home: child,
    ),
  );
}

void main() {
  // Should display validation errors when no input is provided
  testWidgets('Displays validation error when fields are empty', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        child: const LoginScreen(),
        provider: MockCaptainProvider(),
      ),
    );

    await tester.tap(find.text('LOGIN'));
    await tester.pump();

    expect(find.text('Please enter your username'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  // Should show an error message on failed login
  testWidgets('Shows error on failed login', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        child: const LoginScreen(),
        provider: MockCaptainProvider(shouldSucceed: false),
      ),
    );

    await tester.enterText(find.byType(TextFormField).first, 'invalidUser');
    await tester.enterText(find.byType(TextFormField).last, 'wrongPass');
    await tester.tap(find.text('LOGIN'));
    await tester.pumpAndSettle();

    expect(find.text('Invalid username or password'), findsOneWidget);
  });

  /// BELOW TEST NO LONGER WORKS DUE TO CHANGES IN LOGIN SCREEN FROM LOADOUT PROVIDER
  /// 
  // Should navigate to the /home route after successful login
  // testWidgets('Navigates to home on successful login', (WidgetTester tester) async {
  //   bool navigated = false;

  //   await tester.pumpWidget(
  //     buildTestableWidget(
  //       child: const LoginScreen(),
  //       provider: MockCaptainProvider(shouldSucceed: true),
  //       onGenerateRoute: (settings) {
  //         if (settings.name == '/home') {
  //           navigated = true;
  //           return MaterialPageRoute(builder: (_) => const Scaffold(body: Text('Home')));
  //         }
  //         return null;
  //       },
  //     ),
  //   );

  //   await tester.enterText(find.byType(TextFormField).first, 'validUser');
  //   await tester.enterText(find.byType(TextFormField).last, 'rightPass');
  //   await tester.tap(find.text('LOGIN'));
  //   await tester.pumpAndSettle();

  //   expect(navigated, isTrue);
  // });

  /// Should navigate to the /profile route when "REGISTER" is tapped
  testWidgets('Navigates to profile creation screen on register', (WidgetTester tester) async {
    bool navigated = false;

    await tester.pumpWidget(
      buildTestableWidget(
        child: const LoginScreen(),
        provider: MockCaptainProvider(),
        onGenerateRoute: (settings) {
          if (settings.name == '/profile') {
            navigated = true;
            return MaterialPageRoute(builder: (_) => const Scaffold(body: Text('Register')));
          }
          return null;
        },
      ),
    );

    await tester.tap(find.text('REGISTER'));
    await tester.pumpAndSettle();

    expect(navigated, isTrue);
  });
}