// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l_alternative/src/core/components/image_button.dart';
import 'package:l_alternative/src/features/profile/provider/user_provider.dart';
import 'package:l_alternative/src/features/profile/view/profile_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ProfileView Widget Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('should display profile information correctly', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: ProfileView())),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Informations personnelles'), findsOneWidget);
      expect(find.text('Evaluations'), findsOneWidget); // Fixed typo
      expect(find.text('Zone sensible'), findsOneWidget);
      expect(find.text('Supprimer mes données'), findsOneWidget);
    });

    testWidgets('should find edit and theme buttons', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: ProfileView())),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert - Check that ImageButtons exist (edit button and theme button)
      expect(find.byType(ImageButton), findsWidgets);

      // The edit button should be present (shows edit.png initially)
      final imageButtons = tester.widgetList<ImageButton>(
        find.byType(ImageButton),
      );
      expect(
        imageButtons.any((button) => button.imagePath == 'edit.png'),
        isTrue,
      );
    });

    testWidgets('should display user name correctly', (tester) async {
      // Arrange
      const testName = 'Test User';
      final container = ProviderContainer();

      // Set up initial name in the container
      await container.read(userProvider.notifier).changeName(testName);

      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(home: ProfileView()),
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(testName), findsOneWidget);

      container.dispose();
    });

    // testWidgets('should display evaluations from provider', (tester) async {
    //   // Arrange
    //   await tester.pumpWidget(
    //     ProviderScope(child: MaterialApp(home: ProfileView())),
    //   );
    //
    //   // Act
    //   await tester.pumpAndSettle();
    //
    //   // Assert
    //   expect(find.text('Evaluations'), findsOneWidget);
    //
    //   // Should show evaluation dates (the default evaluations from provider)
    //   // We know from the provider there are default evaluations with specific dates
    //   expect(
    //     find.byType(Divider),
    //     findsWidgets,
    //   ); // Dividers between evaluations
    // });

    testWidgets('should handle widget rendering without crashing', (
      tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: ProfileView())),
      );

      // Assert - Widget should render successfully
      expect(find.byType(ProfileView), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should display theme toggle button', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: ProfileView())),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert - Should have theme toggle button in app bar
      expect(find.byType(AppBar), findsOneWidget);

      // Check for theme-related image buttons (sunny.png or nightlight.png)
      final imageButtons = tester.widgetList<ImageButton>(
        find.byType(ImageButton),
      );
      expect(
        imageButtons.any(
          (button) =>
              button.imagePath == 'sunny.png' ||
              button.imagePath == 'nightlight.png',
        ),
        isTrue,
      );
    });

    testWidgets('should show delete button in danger zone', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: ProfileView())),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Zone sensible'), findsOneWidget);
      expect(find.text('Supprimer mes données'), findsOneWidget);

      // Should have a trash button
      final imageButtons = tester.widgetList<ImageButton>(
        find.byType(ImageButton),
      );
      expect(
        imageButtons.any((button) => button.imagePath == 'trash.png'),
        isTrue,
      );
    });

    testWidgets('should display plus button for adding evaluations', (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: ProfileView())),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      final imageButtons = tester.widgetList<ImageButton>(
        find.byType(ImageButton),
      );
      expect(
        imageButtons.any((button) => button.imagePath == 'plus-circle.png'),
        isTrue,
      );
    });
  });

  group('ProfileView Unit Tests', () {
    testWidgets('should integrate properly with providers', (tester) async {
      // Arrange
      final container = ProviderContainer();
      const testName = 'Integration Test User';

      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(home: ProfileView()),
        ),
      );

      // Wait for initial provider setup
      await tester.pumpAndSettle();

      // Act - Change user name after widget is initialized
      await container.read(userProvider.notifier).changeName(testName);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(testName), findsOneWidget);

      container.dispose();
    });

    testWidgets('should handle provider state changes', (tester) async {
      // Arrange
      final container = ProviderContainer();

      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(home: ProfileView()),
        ),
      );

      // Wait for initial setup
      await tester.pumpAndSettle();

      // Act - Change user data
      await container.read(userProvider.notifier).changeName('First Name');
      await tester.pumpAndSettle();

      expect(find.text('First Name'), findsOneWidget);

      // Change again
      await container.read(userProvider.notifier).changeName('Second Name');
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Second Name'), findsOneWidget);
      expect(find.text('First Name'), findsNothing);

      container.dispose();
    });
  });

  group('ProfileView Error Handling', () {
    testWidgets('should render even with empty/null data', (tester) async {
      // Arrange
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: ProfileView())),
      );

      // Act & Assert - Should render without throwing
      await tester.pumpAndSettle();
      expect(find.byType(ProfileView), findsOneWidget);
    });

    testWidgets('should handle provider errors gracefully', (tester) async {
      // Arrange
      final container = ProviderContainer();

      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(home: ProfileView()),
        ),
      );

      // Act - Multiple rapid state changes
      for (int i = 0; i < 5; i++) {
        await container.read(userProvider.notifier).changeName('User $i');
      }
      await tester.pumpAndSettle();

      // Assert - Should handle without throwing
      expect(find.byType(ProfileView), findsOneWidget);
      // Check for any user name that was set (should be the last one)
      expect(find.textContaining('User'), findsAtLeastNWidgets(1));

      container.dispose();
    });
  });

  group('ProfileView Accessibility', () {
    testWidgets('should have accessible structure', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: ProfileView())),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert - Basic accessibility checks
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);

      // Check that important text is present for screen readers
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Informations personnelles'), findsOneWidget);
      expect(find.text('Zone sensible'), findsOneWidget);
    });

    testWidgets('should have proper widget hierarchy', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: ProfileView())),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert - Check widget structure
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(ProviderScope), findsOneWidget);
      expect(find.byType(ProfileView), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
    });
  });
}
