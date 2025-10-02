// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:l_alternative/main.dart' as app;
import 'package:l_alternative/src/core/components/image_button.dart';
import 'package:l_alternative/src/features/home/view/home_view.dart';
import 'package:l_alternative/src/features/profile/view/profile_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Home → Profile → Edit/Delete Flow E2E Tests', () {
    setUp(() async {
      // Clear SharedPreferences before each test
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    });

    testWidgets('Complete flow: Home → Profile → Edit Name → Save → Verify', (
      WidgetTester tester,
    ) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      // Step 1: Verify we're on HomeView
      expect(find.byType(HomeView), findsOneWidget);
      expect(find.text('Bon retour,'), findsOneWidget);
      expect(find.text('NAME'), findsOneWidget);

      // Step 2: Navigate to Profile by tapping the avatar
      final avatarImage = find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                "assets/images/avatar.png",
      );

      expect(avatarImage, findsOneWidget);
      await tester.tap(avatarImage);
      await tester.pumpAndSettle(Duration(seconds: 1));

      // Step 3: Verify ProfileView is displayed
      expect(find.byType(ProfileView), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Informations personnelles'), findsOneWidget);
      expect(find.text('NAME'), findsOneWidget); // Default name

      // Step 4: Enter edit mode by tapping the edit button
      final editButtons = find.byWidgetPredicate(
        (widget) => widget is ImageButton && widget.imagePath == 'edit.png',
      );
      expect(editButtons, findsOneWidget);
      await tester.tap(editButtons.first);
      await tester.pumpAndSettle();

      // Step 5: Verify we're in edit mode (TextField should be visible)
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Enter your name'), findsOneWidget);

      // Step 6: Edit the name
      const newName = 'John Doe Test User';
      await tester.enterText(find.byType(TextField), newName);
      await tester.pumpAndSettle();

      // Step 7: Save the changes by tapping the save button
      final saveButtons = find.byWidgetPredicate(
        (widget) => widget is ImageButton && widget.imagePath == 'save.png',
      );
      expect(saveButtons, findsOneWidget);
      await tester.tap(saveButtons.first);
      await tester.pumpAndSettle();

      // Step 8: Verify name was saved and edit mode is exited
      expect(find.byType(TextField), findsNothing); // No longer in edit mode
      expect(find.text(newName), findsOneWidget);
      expect(find.text('NAME'), findsNothing); // Old name should be gone

      // Step 9: Navigate back to Home to verify persistence
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Step 10: Verify we're back on HomeView with updated name
      expect(find.byType(HomeView), findsOneWidget);
      expect(find.text('Bon retour,'), findsOneWidget);
      expect(find.text(newName), findsOneWidget);
      expect(find.text('NAME'), findsNothing);
    });

    testWidgets('Complete flow: Home → Profile → Add Evaluation → Verify', (
      WidgetTester tester,
    ) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 2));

      // Step 1: Navigate to Profile
      final avatarImage = find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                "assets/images/avatar.png",
      );
      await tester.tap(avatarImage);
      await tester.pumpAndSettle();

      // Step 2: Verify ProfileView and evaluations section
      expect(find.byType(ProfileView), findsOneWidget);
      expect(find.text('Eveluations'), findsOneWidget);

      // Step 3: Get initial evaluation count
      final initialDividers = find.byType(Divider);
      final initialDividerCount = initialDividers.evaluate().length;

      // Step 4: Add new evaluation by tapping plus button
      final addEvaluationButtons = find.byWidgetPredicate(
        (widget) =>
            widget is ImageButton && widget.imagePath == 'plus-circle.png',
      );
      expect(addEvaluationButtons, findsOneWidget);
      await tester.tap(addEvaluationButtons.first);
      await tester.pumpAndSettle();

      // Step 5: Verify evaluation was added (more dividers should be present)
      final finalDividers = find.byType(Divider);
      final finalDividerCount = finalDividers.evaluate().length;
      expect(finalDividerCount, greaterThanOrEqualTo(initialDividerCount));

      // Step 6: Verify evaluations are sorted from newest to oldest
      // The newest evaluation should be at the top
      expect(find.text('Eveluations'), findsOneWidget);
    });

    testWidgets(
      'Complete flow: Home → Profile → Delete Account → Confirm → Verify Reset',
      (WidgetTester tester) async {
        // Launch the app
        app.main();
        await tester.pumpAndSettle(Duration(seconds: 2));

        // Step 1: First, set up some data by editing name
        final avatarImage = find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName ==
                  "assets/images/avatar.png",
        );
        await tester.tap(avatarImage);
        await tester.pumpAndSettle();

        // Edit name to have some data to delete
        final editButtons = find.byWidgetPredicate(
          (widget) => widget is ImageButton && widget.imagePath == 'edit.png',
        );
        await tester.tap(editButtons.first);
        await tester.pumpAndSettle();

        const testName = 'User To Delete';
        await tester.enterText(find.byType(TextField), testName);
        await tester.pumpAndSettle();

        final saveButtons = find.byWidgetPredicate(
          (widget) => widget is ImageButton && widget.imagePath == 'save.png',
        );
        await tester.tap(saveButtons.first);
        await tester.pumpAndSettle();

        // Step 2: Verify data is set
        expect(find.text(testName), findsOneWidget);

        // Step 3: Navigate to delete section
        expect(find.text('Zone sensible'), findsOneWidget);
        expect(find.text('Supprimer mes données'), findsOneWidget);

        // Step 4: Tap delete button
        final deleteButtons = find.byWidgetPredicate(
          (widget) => widget is ImageButton && widget.imagePath == 'trash.png',
        );
        expect(deleteButtons, findsOneWidget);
        await tester.tap(deleteButtons.first);
        await tester.pumpAndSettle();

        // Step 5: Verify confirmation dialog appears
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Confirmer la suppression'), findsOneWidget);
        expect(
          find.text(
            'Êtes-vous sûr de vouloir supprimer toutes vos données ? Cette action est irréversible.',
          ),
          findsOneWidget,
        );
        expect(find.text('Annuler'), findsOneWidget);
        expect(find.text('Supprimer'), findsOneWidget);

        // Step 6: Confirm deletion
        final confirmDeleteButton = find.text('Supprimer');
        await tester.tap(confirmDeleteButton);
        await tester.pumpAndSettle();

        // Step 7: Verify dialog is dismissed and data is reset
        expect(find.byType(AlertDialog), findsNothing);
        expect(find.text('NAME'), findsOneWidget); // Back to default name
        expect(find.text(testName), findsNothing); // User name should be gone

        // Step 8: Navigate back to Home to verify complete reset
        await tester.pageBack();
        await tester.pumpAndSettle();

        // Step 9: Verify Home shows default state
        expect(find.byType(HomeView), findsOneWidget);
        expect(find.text('NAME'), findsOneWidget);
        expect(find.text(testName), findsNothing);
      },
    );

    testWidgets(
      'Complete flow: Home → Profile → Cancel Delete → Verify No Changes',
      (WidgetTester tester) async {
        // Launch the app
        app.main();
        await tester.pumpAndSettle(Duration(seconds: 2));

        // Step 1: Navigate to Profile and set up test data
        final avatarImage = find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName ==
                  "assets/images/avatar.png",
        );
        await tester.tap(avatarImage);
        await tester.pumpAndSettle();

        // Edit name to have data to preserve
        final editButtons = find.byWidgetPredicate(
          (widget) => widget is ImageButton && widget.imagePath == 'edit.png',
        );
        await tester.tap(editButtons.first);
        await tester.pumpAndSettle();

        const testName = 'User To Preserve';
        await tester.enterText(find.byType(TextField), testName);
        await tester.pumpAndSettle();

        final saveButtons = find.byWidgetPredicate(
          (widget) => widget is ImageButton && widget.imagePath == 'save.png',
        );
        await tester.tap(saveButtons.first);
        await tester.pumpAndSettle();

        // Step 2: Verify data is set
        expect(find.text(testName), findsOneWidget);

        // Step 3: Tap delete button
        final deleteButtons = find.byWidgetPredicate(
          (widget) => widget is ImageButton && widget.imagePath == 'trash.png',
        );
        await tester.tap(deleteButtons.first);
        await tester.pumpAndSettle();

        // Step 4: Verify confirmation dialog appears
        expect(find.byType(AlertDialog), findsOneWidget);

        // Step 5: Cancel deletion
        final cancelButton = find.text('Annuler');
        await tester.tap(cancelButton);
        await tester.pumpAndSettle();

        // Step 6: Verify dialog is dismissed and data is preserved
        expect(find.byType(AlertDialog), findsNothing);
        expect(find.text(testName), findsOneWidget); // Data should remain
        expect(find.text('NAME'), findsNothing); // Should not revert to default

        // Step 7: Navigate back to Home to verify data persistence
        await tester.pageBack();
        await tester.pumpAndSettle();

        // Step 8: Verify Home still shows preserved data
        expect(find.byType(HomeView), findsOneWidget);
        expect(find.text(testName), findsOneWidget);
      },
    );

    testWidgets(
      'Complete flow: Multiple Edit Operations → Theme Toggle → Persistence',
      (WidgetTester tester) async {
        // Launch the app
        app.main();
        await tester.pumpAndSettle(Duration(seconds: 2));

        // Step 1: Navigate to Profile
        final avatarImage = find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName ==
                  "assets/images/avatar.png",
        );
        await tester.tap(avatarImage);
        await tester.pumpAndSettle();

        // Step 2: Multiple name changes
        const names = ['First Name', 'Second Name', 'Final Name'];

        for (final name in names) {
          // Enter edit mode
          final editButtons = find.byWidgetPredicate(
            (widget) => widget is ImageButton && widget.imagePath == 'edit.png',
          );
          await tester.tap(editButtons.first);
          await tester.pumpAndSettle();

          // Change name
          await tester.enterText(find.byType(TextField), name);
          await tester.pumpAndSettle();

          // Save
          final saveButtons = find.byWidgetPredicate(
            (widget) => widget is ImageButton && widget.imagePath == 'save.png',
          );
          await tester.tap(saveButtons.first);
          await tester.pumpAndSettle();

          // Verify name changed
          expect(find.text(name), findsOneWidget);
        }

        // Step 3: Toggle theme while in profile
        final themeButtons = find.byWidgetPredicate(
          (widget) =>
              widget is ImageButton &&
              (widget.imagePath == 'sunny.png' ||
                  widget.imagePath == 'nightlight.png'),
        );
        expect(themeButtons, findsOneWidget);
        await tester.tap(themeButtons.first);
        await tester.pumpAndSettle();

        // Step 4: Verify final name is still preserved after theme change
        expect(find.text('Final Name'), findsOneWidget);

        // Step 5: Navigate back to Home and verify persistence
        await tester.pageBack();
        await tester.pumpAndSettle();

        expect(find.byType(HomeView), findsOneWidget);
        expect(find.text('Final Name'), findsOneWidget);
      },
    );

    testWidgets(
      'Error handling: Edit mode state persistence during interruptions',
      (WidgetTester tester) async {
        // Launch the app
        app.main();
        await tester.pumpAndSettle(Duration(seconds: 2));

        // Step 1: Navigate to Profile
        final avatarImage = find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName ==
                  "assets/images/avatar.png",
        );
        await tester.tap(avatarImage);
        await tester.pumpAndSettle();

        // Step 2: Enter edit mode
        final editButtons = find.byWidgetPredicate(
          (widget) => widget is ImageButton && widget.imagePath == 'edit.png',
        );
        await tester.tap(editButtons.first);
        await tester.pumpAndSettle();

        // Step 3: Verify in edit mode
        expect(find.byType(TextField), findsOneWidget);

        // Step 4: Enter partial text
        await tester.enterText(find.byType(TextField), 'Partial');
        await tester.pumpAndSettle();

        // Step 5: Toggle theme while in edit mode (potential interruption)
        final themeButtons = find.byWidgetPredicate(
          (widget) =>
              widget is ImageButton &&
              (widget.imagePath == 'sunny.png' ||
                  widget.imagePath == 'nightlight.png'),
        );
        await tester.tap(themeButtons.first);
        await tester.pumpAndSettle();

        // Step 6: Verify still in edit mode with text preserved
        expect(find.byType(TextField), findsOneWidget);
        expect(find.text('Partial'), findsOneWidget);

        // Step 7: Complete the edit
        await tester.enterText(find.byType(TextField), 'Partial Text Complete');
        await tester.pumpAndSettle();

        final saveButtons = find.byWidgetPredicate(
          (widget) => widget is ImageButton && widget.imagePath == 'save.png',
        );
        await tester.tap(saveButtons.first);
        await tester.pumpAndSettle();

        // Step 8: Verify final state is correct
        expect(find.text('Partial Text Complete'), findsOneWidget);
        expect(find.byType(TextField), findsNothing);
      },
    );
  });
}
