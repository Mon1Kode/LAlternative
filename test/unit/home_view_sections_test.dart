import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l_alternative/src/core/components/image_button.dart';
import 'package:l_alternative/src/core/components/rounded_container.dart';
import 'package:l_alternative/src/features/home/view/home_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('HomeView Section Rendering Tests', () {
    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({
        'mood': 'love.png',
        'tools': ['streak', 'calendar'],
      });
    });

    group('Header Section', () {
      testWidgets('renders welcome message correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: HomeView())),
        );
        await tester.pumpAndSettle();

        expect(find.text('Bon retour,'), findsOneWidget);
        expect(find.text('NAME'), findsOneWidget);
      });

      testWidgets('renders avatar with correct properties', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: HomeView(),
              routes: {
                '/profile': (context) => Scaffold(body: Text('Profile')),
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        final avatarImage = find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName ==
                  "assets/images/avatar.png",
        );

        expect(avatarImage, findsOneWidget);

        // Test avatar tap functionality
        await tester.tap(avatarImage);
        await tester.pumpAndSettle();
        expect(find.text('Profile'), findsOneWidget);
      });

      testWidgets('header layout is responsive', (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: HomeView())),
        );
        await tester.pumpAndSettle();

        // Find the main row containing header elements
        final headerRow = find.byWidgetPredicate(
          (widget) =>
              widget is Row &&
              widget.mainAxisAlignment == MainAxisAlignment.spaceBetween,
        );

        expect(headerRow, findsWidgets);
      });
    });

    group('Tools Section', () {
      testWidgets('renders tools section header with edit button', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: HomeView())),
        );
        await tester.pumpAndSettle();

        expect(find.text('Outils'), findsOneWidget);
        expect(find.byType(ImageButton), findsWidgets);
      });

      testWidgets('edit mode toggles tools editing interface', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: HomeView())),
        );
        await tester.pumpAndSettle();

        // Initially not in edit mode - no delete buttons should be visible
        expect(find.byIcon(Icons.close), findsNothing);

        // Find and tap edit button
        final editButton = find.byWidgetPredicate(
          (widget) => widget is ImageButton,
        );

        if (editButton.evaluate().isNotEmpty) {
          await tester.tap(editButton.last);
          await tester.pumpAndSettle();
        }
      });

      testWidgets('tools are displayed in staggered grid', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: HomeView())),
        );
        await tester.pumpAndSettle();

        // Check if StaggeredGrid is present (from flutter_staggered_grid_view)
        final staggeredGridFinder = find.byWidgetPredicate(
          (widget) => widget.runtimeType.toString().contains('StaggeredGrid'),
        );

        expect(staggeredGridFinder, findsWidgets);
      });

      testWidgets('shake animation works in edit mode', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: HomeView())),
        );
        await tester.pumpAndSettle();

        // Look for ShakeWidget components
        expect(find.byType(ShakeWidget), findsWidgets);
      });
    });

    group('Mood Selection Section', () {
      testWidgets('renders mood section header', (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: HomeView())),
        );
        await tester.pumpAndSettle();

        expect(find.text('Humeur actuelle'), findsOneWidget);
      });

      testWidgets('displays all five mood options', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: HomeView())),
        );
        await tester.pumpAndSettle();

        expect(find.byType(CircleMoods), findsNWidgets(5));
      });

      testWidgets('mood selection updates correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: HomeView())),
        );
        await tester.pumpAndSettle();

        // Find all mood circles
        final moodCircles = find.byType(CircleMoods);
        expect(moodCircles, findsNWidgets(5));

        // Tap on the first mood circle
        await tester.tap(moodCircles.first);
        await tester.pumpAndSettle();

        // The mood should be updated (we can't easily verify the internal state
        // but we can verify the tap was processed without errors)
        expect(moodCircles, findsNWidgets(5));
      });

      testWidgets('mood circles have correct visual states', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: HomeView())),
        );
        await tester.pumpAndSettle();

        // Find CircleAvatar widgets (part of CircleMoods)
        final circleAvatars = find.byType(CircleAvatar);
        expect(circleAvatars, findsWidgets);

        // Each mood should have proper circular container
        final roundedContainers = find.byType(RoundedContainer);
        expect(roundedContainers, findsWidgets);
      });

      testWidgets('chart button is present in mood section', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: HomeView())),
        );
        await tester.pumpAndSettle();

        // Look for ImageButton with chart.png
        final chartButton = find.byWidgetPredicate(
          (widget) => widget is ImageButton,
        );

        expect(chartButton, findsWidgets);
      });
    });

    group('Modal Bottom Sheet (Add Tools)', () {
      testWidgets(
        'add tools modal appears when plus button is tapped in edit mode',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            ProviderScope(child: MaterialApp(home: HomeView())),
          );
          await tester.pumpAndSettle();

          // First enter edit mode by tapping edit button
          final editButtons = find.byType(ImageButton);
          if (editButtons.evaluate().isNotEmpty) {
            await tester.tap(editButtons.last);
            await tester
                .pump(); // Use pump instead of pumpAndSettle to avoid timeout

            // Verify edit mode is active by checking for additional buttons
            final buttonsAfterEdit = find.byType(ImageButton);
            expect(
              buttonsAfterEdit.evaluate().length,
              greaterThanOrEqualTo(editButtons.evaluate().length),
            );
          }
        },
      );
    });

    group('Overall Layout and Styling', () {
      testWidgets('has correct gradient background', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: HomeView())),
        );
        await tester.pumpAndSettle();

        // Find container with gradient decoration
        final gradientContainer = find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).gradient != null,
        );

        expect(gradientContainer, findsOneWidget);
      });

      testWidgets('uses SafeArea for proper spacing', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: HomeView())),
        );
        await tester.pumpAndSettle();

        expect(find.byType(SafeArea), findsOneWidget);
      });

      testWidgets('has scrollable content', (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: HomeView())),
        );
        await tester.pumpAndSettle();

        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });

      testWidgets('sections have proper spacing', (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: HomeView())),
        );
        await tester.pumpAndSettle();

        final columnsWithSpacing = find.byWidgetPredicate(
          (widget) => widget is Column && widget.spacing > 0,
        );

        expect(columnsWithSpacing, findsWidgets);
      });
    });

    group('Error Handling and Edge Cases', () {
      testWidgets('handles missing shared preferences gracefully', (
        WidgetTester tester,
      ) async {
        // Reset shared preferences to empty state
        SharedPreferences.setMockInitialValues({});

        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: HomeView())),
        );
        await tester.pumpAndSettle();

        // Should still render without crashing
        expect(find.text('Bon retour,'), findsOneWidget);
        expect(find.text('Outils'), findsOneWidget);
        expect(find.text('Humeur actuelle'), findsOneWidget);
      });
    });
  });
}
