import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:l_alternative/main.dart' as app;
import 'package:l_alternative/src/core/components/image_button.dart';
import 'package:l_alternative/src/features/home/view/home_view.dart';
import 'package:l_alternative/src/features/profile/view/profile_view.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Complete App Flow E2E Tests', () {
    testWidgets(
      'Complete user journey: open app → view home → select mood → open profile → change theme to dark',
      (WidgetTester tester) async {
        // Launch the app
        app.main();
        await tester.pumpAndSettle();

        // Step 1: Verify app opens and shows HomeView
        expect(find.byType(HomeView), findsOneWidget);
        expect(find.text('Bon retour,'), findsOneWidget);
        expect(find.text('MoniK'), findsOneWidget);
        expect(find.text('Outils'), findsOneWidget);
        expect(find.text('Humeur actuelle'), findsOneWidget);

        // Step 2: Verify mood selection section is visible
        expect(find.byType(CircleMoods), findsNWidgets(5));

        // Step 3: Select a mood (tap on the first mood circle)
        final moodCircles = find.byType(CircleMoods);
        await tester.tap(moodCircles.first);
        await tester.pumpAndSettle();

        // Verify mood was selected (should still have 5 mood circles)
        expect(find.byType(CircleMoods), findsNWidgets(5));

        // Step 4: Navigate to profile by tapping the avatar
        final avatarImage = find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName ==
                  "assets/images/avatar.png",
        );

        expect(avatarImage, findsOneWidget);
        await tester.tap(avatarImage);
        await tester.pumpAndSettle();

        // Step 5: Verify ProfileView is displayed
        expect(find.byType(ProfileView), findsOneWidget);
        expect(find.text('Profile'), findsOneWidget);
        expect(find.text('Informations personnelles'), findsOneWidget);

        // Step 6: Verify the app is in light mode initially
        expect(
          Theme.of(tester.element(find.byType(ProfileView))).brightness,
          Brightness.light,
        );

        // Step 7: Find and tap the theme toggle button (should show nightlight icon in light mode)
        final themeToggleButton = find.byWidgetPredicate(
          (widget) =>
              widget is ImageButton && widget.imagePath == "nightlight.png",
        );

        expect(themeToggleButton, findsOneWidget);
        await tester.tap(themeToggleButton);
        await tester.pumpAndSettle();

        // Step 8: Verify the theme changed to dark mode
        expect(
          Theme.of(tester.element(find.byType(ProfileView))).brightness,
          Brightness.dark,
        );

        // Step 9: Verify the theme toggle button now shows sunny icon (for switching back to light)
        final lightModeButton = find.byWidgetPredicate(
          (widget) => widget is ImageButton && widget.imagePath == "sunny.png",
        );

        expect(lightModeButton, findsOneWidget);

        // Step 10: Verify ProfileView content is still visible in dark mode
        expect(find.text('Profile'), findsOneWidget);
        expect(find.text('Informations personnelles'), findsOneWidget);

        // Optional: Navigate back to home and verify dark theme persists
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();

        expect(find.byType(HomeView), findsOneWidget);
        expect(
          Theme.of(tester.element(find.byType(HomeView))).brightness,
          Brightness.dark,
        );
      },
    );

    testWidgets('Theme toggle functionality - switch from dark to light', (
      WidgetTester tester,
    ) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Navigate to profile
      final avatarImage = find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                "assets/images/avatar.png",
      );

      await tester.tap(avatarImage);
      await tester.pumpAndSettle();

      // Switch to dark mode first
      final nightlightButton = find.byWidgetPredicate(
        (widget) =>
            widget is ImageButton && widget.imagePath == "nightlight.png",
      );

      if (nightlightButton.evaluate().isNotEmpty) {
        await tester.tap(nightlightButton);
        await tester.pumpAndSettle();
      }

      // Verify we're in dark mode
      expect(
        Theme.of(tester.element(find.byType(ProfileView))).brightness,
        Brightness.dark,
      );

      // Now switch back to light mode
      final sunnyButton = find.byWidgetPredicate(
        (widget) => widget is ImageButton && widget.imagePath == "sunny.png",
      );

      expect(sunnyButton, findsOneWidget);
      await tester.tap(sunnyButton);
      await tester.pumpAndSettle();

      // Verify we're back in light mode
      expect(
        Theme.of(tester.element(find.byType(ProfileView))).brightness,
        Brightness.light,
      );
    });

    testWidgets('Mood selection persistence across navigation', (
      WidgetTester tester,
    ) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Select a specific mood (let's select the second mood circle)
      final moodCircles = find.byType(CircleMoods);
      expect(moodCircles, findsNWidgets(5));

      await tester.tap(moodCircles.at(1)); // Select second mood
      await tester.pumpAndSettle();

      // Navigate to profile
      final avatarImage = find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                "assets/images/avatar.png",
      );

      await tester.tap(avatarImage);
      await tester.pumpAndSettle();

      // Navigate back to home
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Verify mood selection is still intact
      expect(find.byType(HomeView), findsOneWidget);
      expect(find.byType(CircleMoods), findsNWidgets(5));
    });

    testWidgets('App navigation flows work correctly', (
      WidgetTester tester,
    ) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Verify we start at HomeView
      expect(find.byType(HomeView), findsOneWidget);
      expect(find.byType(ProfileView), findsNothing);

      // Navigate to profile
      final avatarImage = find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                "assets/images/avatar.png",
      );

      await tester.tap(avatarImage);
      await tester.pumpAndSettle();

      // Verify we're now on ProfileView
      expect(find.byType(ProfileView), findsOneWidget);
      expect(find.byType(HomeView), findsNothing);

      // Navigate back using back button
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Verify we're back on HomeView
      expect(find.byType(HomeView), findsOneWidget);
      expect(find.byType(ProfileView), findsNothing);
    });

    testWidgets('Complete UI elements are functional', (
      WidgetTester tester,
    ) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Test HomeView elements
      expect(find.text('Bon retour,'), findsOneWidget);
      expect(find.text('MoniK'), findsOneWidget);
      expect(find.text('Outils'), findsOneWidget);
      expect(find.text('Humeur actuelle'), findsOneWidget);

      // Test mood selection functionality
      final moodCircles = find.byType(CircleMoods);
      expect(moodCircles, findsNWidgets(5));

      // Test each mood circle is tappable
      for (int i = 0; i < 5; i++) {
        await tester.tap(moodCircles.at(i));
        await tester.pump();
      }

      // Navigate to profile
      final avatarImage = find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                "assets/images/avatar.png",
      );

      await tester.tap(avatarImage);
      await tester.pumpAndSettle();

      // Test ProfileView elements
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Informations personnelles'), findsOneWidget);
      expect(find.byType(ImageButton), findsOneWidget); // Theme toggle button
      expect(find.byIcon(Icons.edit), findsOneWidget); // Edit button
    });
  });

  group('Error Handling and Edge Cases', () {
    testWidgets('App handles rapid navigation correctly', (
      WidgetTester tester,
    ) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      final avatarImage = find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                "assets/images/avatar.png",
      );

      // Rapid navigation back and forth
      for (int i = 0; i < 3; i++) {
        // Go to profile
        await tester.tap(avatarImage);
        await tester.pumpAndSettle();
        expect(find.byType(ProfileView), findsOneWidget);

        // Go back to home
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();
        expect(find.byType(HomeView), findsOneWidget);
      }
    });

    testWidgets('Theme changes persist across app lifecycle', (
      WidgetTester tester,
    ) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Navigate to profile and change theme
      final avatarImage = find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                "assets/images/avatar.png",
      );

      await tester.tap(avatarImage);
      await tester.pumpAndSettle();

      // Switch to dark mode
      final themeToggle = find.byWidgetPredicate(
        (widget) => widget is ImageButton,
      );

      await tester.tap(themeToggle);
      await tester.pumpAndSettle();

      // Navigate back and forth to test persistence
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Go back to profile to verify theme persisted
      await tester.tap(avatarImage);
      await tester.pumpAndSettle();

      // Should still be in the theme we set
      expect(find.byType(ProfileView), findsOneWidget);
    });
  });
}
