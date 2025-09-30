// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l_alternative/src/features/profile/provider/evaluation_provider.dart';
import 'package:l_alternative/src/features/profile/provider/user_provider.dart';
import 'package:l_alternative/src/features/profile/services/user_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Profile Update Flow Tests', () {
    late ProviderContainer container;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('UserNotifier changeName', () {
      test('should update user name in state and persist to storage', () async {
        // Arrange
        const newName = 'John Doe';
        final userNotifier = container.read(userProvider.notifier);

        // Act
        await userNotifier.changeName(newName);

        // Assert
        final userState = container.read(userProvider);
        expect(userState.name, equals(newName));

        // Verify persistence
        final service = UserServices();
        final savedName = await service.loadUserName();
        expect(savedName, equals(newName));
      });

      test('should handle empty name update', () async {
        // Arrange
        const emptyName = '';
        final userNotifier = container.read(userProvider.notifier);

        // Act
        await userNotifier.changeName(emptyName);

        // Assert
        final userState = container.read(userProvider);
        expect(userState.name, equals(emptyName));
      });

      test('should handle special characters in name', () async {
        // Arrange
        const specialName = 'José María-López O\'Connor';
        final userNotifier = container.read(userProvider.notifier);

        // Act
        await userNotifier.changeName(specialName);

        // Assert
        final userState = container.read(userProvider);
        expect(userState.name, equals(specialName));
      });

      test('should handle very long name', () async {
        // Arrange
        final longName = 'A' * 1000;
        final userNotifier = container.read(userProvider.notifier);

        // Act
        await userNotifier.changeName(longName);

        // Assert
        final userState = container.read(userProvider);
        expect(userState.name, equals(longName));
      });

      test('should update name multiple times correctly', () async {
        // Arrange
        final userNotifier = container.read(userProvider.notifier);
        const firstName = 'Alice';
        const secondName = 'Bob';
        const thirdName = 'Charlie';

        // Act & Assert
        await userNotifier.changeName(firstName);
        expect(container.read(userProvider).name, equals(firstName));

        await userNotifier.changeName(secondName);
        expect(container.read(userProvider).name, equals(secondName));

        await userNotifier.changeName(thirdName);
        expect(container.read(userProvider).name, equals(thirdName));
      });
    });

    group('UserServices', () {
      test('should save and load user name correctly', () async {
        // Arrange
        final service = UserServices();
        const testName = 'Test User';

        // Act
        await service.saveUserName(testName);
        final loadedName = await service.loadUserName();

        // Assert
        expect(loadedName, equals(testName));
      });

      test('should return default name when no saved name exists', () async {
        // Arrange
        final service = UserServices();

        // Act
        final loadedName = await service.loadUserName();

        // Assert
        expect(loadedName, equals('NAME'));
      });

      test('should overwrite existing name when saving new one', () async {
        // Arrange
        final service = UserServices();
        const oldName = 'Old Name';
        const newName = 'New Name';

        // Act
        await service.saveUserName(oldName);
        await service.saveUserName(newName);
        final loadedName = await service.loadUserName();

        // Assert
        expect(loadedName, equals(newName));
      });
    });
  });

  group('Delete Account Flow Tests', () {
    late ProviderContainer container;

    setUp(() {
      // Set up mock data in SharedPreferences
      SharedPreferences.setMockInitialValues({
        'user_info': 'Test User',
        'mood_history': ['2025-09-01:happy.png', '2025-09-02:sad.png'],
        'evaluations_key': 'some_evaluation_data',
        'other_app_data': 'important_data',
      });
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('UserNotifier deleteUserData', () {
      test('should clear all user data and reset state to default', () async {
        // Arrange
        final userNotifier = container.read(userProvider.notifier);
        container.read(evaluationsProvider.notifier);

        // Set up initial state
        await userNotifier.changeName('Test User');

        // Act
        await userNotifier.deleteUserData();

        // Assert - User state should be reset
        final userState = container.read(userProvider);
        expect(userState.name, equals('NAME'));

        // Assert - Evaluations should be cleared
        final evaluationsState = container.read(evaluationsProvider);
        expect(evaluationsState.evaluations, isEmpty);
      });

      test('should clear all SharedPreferences data', () async {
        // Arrange
        final userNotifier = container.read(userProvider.notifier);

        // Verify initial data exists
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('user_info'), isNotNull);
        expect(prefs.getStringList('mood_history'), isNotNull);
        expect(prefs.getString('evaluations_key'), isNotNull);
        expect(prefs.getString('other_app_data'), isNotNull);

        // Act
        await userNotifier.deleteUserData();

        // Assert - All preferences should be cleared
        final clearedPrefs = await SharedPreferences.getInstance();
        expect(clearedPrefs.getString('user_info'), isNull);
        expect(clearedPrefs.getStringList('mood_history'), isNull);
        expect(clearedPrefs.getString('evaluations_key'), isNull);
        expect(clearedPrefs.getString('other_app_data'), isNull);
      });

      test('should handle delete when no data exists', () async {
        // Arrange
        SharedPreferences.setMockInitialValues({}); // Empty preferences
        final container2 = ProviderContainer();

        // Act & Assert - Should not throw exception
        expect(() async {
          final userNotifier = container2.read(userProvider.notifier);
          await userNotifier.deleteUserData();
        }, returnsNormally);

        // Wait for any async operations to complete
        await Future.delayed(Duration(milliseconds: 10));

        // Verify state is still reset to default
        final userState = container2.read(userProvider);
        expect(userState.name, equals('NAME'));

        container2.dispose();
      });

      test('should reset user name even if already default', () async {
        // Arrange
        final userNotifier = container.read(userProvider.notifier);

        // Start with default name
        await userNotifier.deleteStoredName(); // This sets to 'NAME'
        expect(container.read(userProvider).name, equals('NAME'));

        // Act
        await userNotifier.deleteUserData();

        // Assert - Should still be 'NAME'
        final userState = container.read(userProvider);
        expect(userState.name, equals('NAME'));
      });

      test('should clear evaluations through provider reference', () async {
        // Arrange
        final userNotifier = container.read(userProvider.notifier);
        container.read(evaluationsProvider.notifier);

        // Verify evaluations exist initially (from default state)
        final initialEvaluations = container.read(evaluationsProvider);
        expect(initialEvaluations.evaluations.length, greaterThan(0));

        // Act
        await userNotifier.deleteUserData();

        // Assert
        final finalEvaluations = container.read(evaluationsProvider);
        expect(finalEvaluations.evaluations, isEmpty);
      });
    });

    group('EvaluationsNotifier clearEvaluations', () {
      test('should clear all evaluations from state', () async {
        // Arrange
        final evaluationsNotifier = container.read(
          evaluationsProvider.notifier,
        );

        // Verify initial evaluations exist
        final initialState = container.read(evaluationsProvider);
        expect(initialState.evaluations.length, greaterThan(0));

        // Act
        await evaluationsNotifier.clearEvaluations();

        // Assert
        final finalState = container.read(evaluationsProvider);
        expect(finalState.evaluations, isEmpty);
      });

      test('should handle clearing already empty evaluations', () async {
        // Arrange
        final evaluationsNotifier = container.read(
          evaluationsProvider.notifier,
        );

        // Clear once
        await evaluationsNotifier.clearEvaluations();
        expect(container.read(evaluationsProvider).evaluations, isEmpty);

        // Act - Clear again
        await evaluationsNotifier.clearEvaluations();

        // Assert - Should still be empty and not throw
        final finalState = container.read(evaluationsProvider);
        expect(finalState.evaluations, isEmpty);
      });
    });
  });

  group('Integration Tests', () {
    late ProviderContainer container;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should handle complete profile update flow', () async {
      // Arrange
      final userNotifier = container.read(userProvider.notifier);
      const testName = 'Integration Test User';

      // Act - Complete profile update flow
      await userNotifier.changeName(testName);

      // Assert - State updated
      expect(container.read(userProvider).name, equals(testName));

      // Assert - Data persisted
      final service = UserServices();
      final persistedName = await service.loadUserName();
      expect(persistedName, equals(testName));

      // Act - Update again
      const updatedName = 'Updated User';
      await userNotifier.changeName(updatedName);

      // Assert - Both state and persistence updated
      expect(container.read(userProvider).name, equals(updatedName));
      final newPersistedName = await service.loadUserName();
      expect(newPersistedName, equals(updatedName));
    });

    test('should handle complete delete account flow', () async {
      // Arrange - Set up user with data
      final userNotifier = container.read(userProvider.notifier);
      await userNotifier.changeName('User To Delete');

      // Verify setup
      expect(container.read(userProvider).name, equals('User To Delete'));
      expect(
        container.read(evaluationsProvider).evaluations.length,
        greaterThan(0),
      );

      // Act - Complete delete flow
      await userNotifier.deleteUserData();

      // Assert - Everything reset
      expect(container.read(userProvider).name, equals('NAME'));
      expect(container.read(evaluationsProvider).evaluations, isEmpty);

      // Assert - SharedPreferences cleared
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getKeys(), isEmpty);
    });

    test('should handle profile update followed by delete', () async {
      // Arrange
      final userNotifier = container.read(userProvider.notifier);

      // Act - Update profile first
      await userNotifier.changeName('Temp User');
      expect(container.read(userProvider).name, equals('Temp User'));

      // Act - Then delete everything
      await userNotifier.deleteUserData();

      // Assert - Everything should be reset
      expect(container.read(userProvider).name, equals('NAME'));
      expect(container.read(evaluationsProvider).evaluations, isEmpty);

      // Assert - Can still update after delete
      await userNotifier.changeName('New User After Delete');
      expect(
        container.read(userProvider).name,
        equals('New User After Delete'),
      );
    });
  });

  group('Error Handling Tests', () {
    late ProviderContainer container;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should handle null name gracefully', () async {
      // Note: Dart null safety prevents passing null directly,
      // but we can test with nullable operations
      final userNotifier = container.read(userProvider.notifier);

      // Act & Assert - Should handle without throwing
      await userNotifier.changeName('');
      expect(container.read(userProvider).name, equals(''));
    });

    test(
      'should maintain state consistency during concurrent operations',
      () async {
        // Arrange
        final userNotifier = container.read(userProvider.notifier);

        // Act - Simulate concurrent name changes
        final futures = <Future>[];
        for (int i = 0; i < 10; i++) {
          futures.add(userNotifier.changeName('User $i'));
        }

        await Future.wait(futures);

        // Assert - Final state should be consistent (last update wins)
        final finalState = container.read(userProvider);
        expect(finalState.name, startsWith('User'));
      },
    );
  });
}
