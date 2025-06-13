// THIS FILE HAS BEEN COMMENTED OUT DUE TO IT TESTING UNINTENDED FUNCTIONALITY

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:ghostnet/widgets/module_description.dart';
// import 'package:ghostnet/models/defence/hull_type.dart';
// import 'package:ghostnet/models/defence/hull_stats.dart';

// void main() {
//   TestWidgetsFlutterBinding.ensureInitialized();

//   group('ModuleDescription Widget', () {
//     // Pull values from the actual `hullData` map
//     final testHull = hullData[HullType.voidframe]!;

//     // Render the widget with full module data and check if it displays correctly
//     testWidgets('renders name and image for selected module', (tester) async {
//       await tester.pumpWidget(
//         MaterialApp(
//           home: Scaffold(
//             body: ModuleDescription(
//               name: testHull.name,
//               imageAsset: testHull.imageAsset,
//               description: testHull.description,
//             ),
//           ),
//         ),
//       );

//       expect(find.text(testHull.name), findsOneWidget);
//       expect(find.byType(Image), findsOneWidget);
//     });

//     // Open the dialog when the image is tapped
//     testWidgets('opens dialog with description on image tap', (tester) async {
//       // Set test screen size
//       tester.view.physicalSize = const Size(800, 1000);
//       tester.view.devicePixelRatio = 1.0;

//       await tester.pumpWidget(
//         MaterialApp(
//           home: Scaffold(
//             body: ModuleDescription(
//               name: testHull.name,
//               imageAsset: testHull.imageAsset,
//               description: testHull.description,
//             ),
//           ),
//         ),
//       );

//       await tester.tap(find.byType(Image));
//       await tester.pumpAndSettle();

//       expect(find.text(testHull.name), findsWidgets); // header + dialog
//       expect(find.text(testHull.description), findsOneWidget);

//       addTearDown(() {
//         // Clean up after test
//         tester.view.resetPhysicalSize();
//         tester.view.resetDevicePixelRatio();
//       });
//     });
//   });
// }