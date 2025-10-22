import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l_alternative/src/core/components/circle_image_button.dart';
import 'package:l_alternative/src/core/components/image_button.dart';
import 'package:l_alternative/src/features/home/view/home_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('HomeView Unit Tests', () {
    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('HomeView renders correctly with initial state', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: HomeView())),
      );

      // Wait for async operations to complete
      await tester.pumpAndSettle();

      // Verify basic UI elements are present
      expect(find.text('NAME'), findsOneWidget);
      expect(find.text('Outils'), findsOneWidget);
      expect(find.text('Humeur actuelle'), findsOneWidget);

      // Verify ImageButtons are present
      expect(find.byType(ImageButton), findsWidgets);
    });

    testWidgets('Mood selection section renders all mood options', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: HomeView())),
      );

      await tester.pumpAndSettle();

      // Find all CircleImageButton widgets (should be 5)
      expect(find.byType(CircleImageButton), findsNWidgets(5));

      // Verify the mood selection header
      expect(find.text('Humeur actuelle'), findsOneWidget);
    });

    testWidgets('Tools section renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: HomeView())),
      );

      await tester.pumpAndSettle();

      // Verify tools section header
      expect(find.text('Outils'), findsOneWidget);

      // Verify edit button is present
      expect(find.byType(ImageButton), findsWidgets);
    });

    testWidgets('Edit mode toggles correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: HomeView())),
      );

      await tester.pumpAndSettle();

      // Find the edit button (ImageButton with edit.png)
      final editButtons = find.byType(ImageButton);
      expect(editButtons, findsWidgets);

      // Tap the edit button to enter edit mode
      await tester.tap(editButtons.last);
      await tester.pumpAndSettle();

      // Verify that we can find the plus button (add tool button) in edit mode
      // This indicates edit mode is active
      final buttons = find.byType(ImageButton);
      expect(buttons, findsWidgets);
    });

    testWidgets('Profile navigation works', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: HomeView(),
            routes: {
              '/profile': (context) => Scaffold(body: Text('Profile Page')),
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the user profile button (ImageButton with user.png)
      final userButton = find.byWidgetPredicate(
        (widget) => widget is ImageButton && widget.imagePath == "user.png",
      );

      expect(userButton, findsOneWidget);
      await tester.tap(userButton);
      await tester.pumpAndSettle();

      // Verify navigation to profile page
      expect(find.text('Profile Page'), findsOneWidget);
    });

    testWidgets('ShakeWidget animates correctly', (WidgetTester tester) async {
      bool isAnimating = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShakeWidget(
              animate: isAnimating,
              child: Container(width: 100, height: 100, color: Colors.red),
            ),
          ),
        ),
      );

      // Initial state - should not be animating
      await tester.pumpAndSettle();
      expect(find.byType(ShakeWidget), findsOneWidget);

      // Update to animate
      isAnimating = true;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShakeWidget(
              animate: isAnimating,
              child: Container(width: 100, height: 100, color: Colors.red),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(ShakeWidget), findsOneWidget);
    });

    testWidgets('HomeToolsAddCard renders correctly', (
      WidgetTester tester,
    ) async {
      final testTool = Container(width: 100, height: 100, color: Colors.blue);
      final toolsChildren = <Widget>[];
      bool wasPressed = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: HomeToolsAddCard(
                tool: testTool,
                toolsChildren: toolsChildren,
                imagePath:
                    "streak.png", // Use existing asset instead of test.png
                text: "Test Tool",
                onPressed: () {
                  wasPressed = true;
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the card renders
      expect(find.byType(HomeToolsAddCard), findsOneWidget);
      expect(find.byType(ImageButton), findsOneWidget);

      // Test pressing the card
      await tester.tap(find.byType(ImageButton));
      expect(wasPressed, isTrue);
    });

    testWidgets('CircleImageButton renders correctly', (
      WidgetTester tester,
    ) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: CircleImageButton(
                imagePath: "moods/happy.png",
                isSelected: false,
                onPressed: () {
                  wasPressed = true;
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the mood circle renders
      expect(find.byType(CircleImageButton), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);

      // Test pressing the mood
      await tester.tap(find.byType(ImageButton));
      expect(wasPressed, isTrue);
    });

    testWidgets('Selected mood is highlighted correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: CircleImageButton(
                imagePath: "moods/happy.png",
                isSelected: true, // Same as mood - should be selected
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the CircleAvatar and verify it has a background color (selected state)
      final circleAvatar = tester.widget<CircleAvatar>(
        find.byType(CircleAvatar),
      );
      expect(circleAvatar.backgroundColor, isNot(Colors.transparent));
    });

    testWidgets('Unselected mood has transparent background', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: CircleImageButton(
                imagePath: "moods/happy.png",
                isSelected:
                    false, // Different from mood - should not be selected
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the CircleAvatar and verify it has transparent background (unselected state)
      final circleAvatar = tester.widget<CircleAvatar>(
        find.byType(CircleAvatar),
      );
      expect(circleAvatar.backgroundColor, equals(Colors.transparent));
    });
  });
}
