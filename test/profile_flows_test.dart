// // Copyright (c) 2025 Monikode. All rights reserved.
// // Unauthorized copying of this file, via any medium, is strictly prohibited.
// // Created by MoniK.
//
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:l_alternative/src/features/connections/provider/user_provider.dart';
// import 'package:l_alternative/src/features/profile/services/user_services.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// void main() {
//   group('Profile Update Flow Tests', () {
//     late ProviderContainer container;
//
//     setUp(() {
//       SharedPreferences.setMockInitialValues({});
//       container = ProviderContainer();
//     });
//
//     tearDown(() {
//       container.dispose();
//     });
//
//     group('UserProvider updateUserDetails', () {
//       test(
//         'should update user display name in state and persist to storage',
//         () async {
//           // Arrange
//           const newName = 'John Doe';
//           final userNotifier = container.read(userProvider.notifier);
//
//           // Act
//           await userNotifier.updateUserDetails(displayName: newName);
//
//           // Assert
//           final userState = container.read(userProvider);
//           expect(userState.displayName, equals(newName));
//
//           // Verify persistence
//           final prefs = await SharedPreferences.getInstance();
//           final savedName = prefs.getString('user_display_name');
//           expect(savedName, equals(newName));
//         },
//       );
//
//       test('should handle empty name update', () async {
//         // Arrange
//         const emptyName = '';
//         final userNotifier = container.read(userProvider.notifier);
//
//         // Act
//         await userNotifier.updateUserDetails(displayName: emptyName);
//
//         // Assert
//         final userState = container.read(userProvider);
//         expect(userState.displayName, equals(emptyName));
//       });
//
//       test('should handle special characters in name', () async {
//         // Arrange
//         const specialName = 'José María-López O\'Connor';
//         final userNotifier = container.read(userProvider.notifier);
//
//         // Act
//         await userNotifier.updateUserDetails(displayName: specialName);
//
//         // Assert
//         final userState = container.read(userProvider);
//         expect(userState.displayName, equals(specialName));
//       });
//
//       test('should handle very long name', () async {
//         // Arrange
//         final longName = 'A' * 1000;
//         final userNotifier = container.read(userProvider.notifier);
//
//         // Act
//         await userNotifier.updateUserDetails(displayName: longName);
//
//         // Assert
//         final userState = container.read(userProvider);
//         expect(userState.displayName, equals(longName));
//       });
//
//       test('should update name multiple times correctly', () async {
//         // Arrange
//         final userNotifier = container.read(userProvider.notifier);
//         const firstName = 'Alice';
//         const secondName = 'Bob';
//         const thirdName = 'Charlie';
//
//         // Act & Assert
//         await userNotifier.updateUserDetails(displayName: firstName);
//         expect(container.read(userProvider).displayName, equals(firstName));
//
//         await userNotifier.updateUserDetails(displayName: secondName);
//         expect(container.read(userProvider).displayName, equals(secondName));
//
//         await userNotifier.updateUserDetails(displayName: thirdName);
//         expect(container.read(userProvider).displayName, equals(thirdName));
//       });
//     });
//
//     group('UserServices', () {
//       test('should save and load user name correctly', () async {
//         // Arrange
//         final service = UserServices();
//         const testName = 'Test User';
//
//         // Act
//         await service.saveUserName(testName);
//         final loadedName = await service.loadUserName();
//
//         // Assert
//         expect(loadedName, equals(testName));
//       });
//
//       test('should return default name when no saved name exists', () async {
//         // Arrange
//         final service = UserServices();
//
//         // Act
//         final loadedName = await service.loadUserName();
//
//         // Assert
//         expect(loadedName, equals('NAME'));
//       });
//
//       test('should overwrite existing name when saving new one', () async {
//         // Arrange
//         final service = UserServices();
//         const oldName = 'Old Name';
//         const newName = 'New Name';
//
//         // Act
//         await service.saveUserName(oldName);
//         await service.saveUserName(newName);
//         final loadedName = await service.loadUserName();
//
//         // Assert
//         expect(loadedName, equals(newName));
//       });
//     });
//   });
//
//   group('Delete Account Flow Tests', () {
//     late ProviderContainer container;
//
//     setUp(() {
//       // Set up mock data in SharedPreferences
//       SharedPreferences.setMockInitialValues({
//         'user_info': 'Test User',
//         'mood_history': ['2025-09-01:happy.png', '2025-09-02:sad.png'],
//         'evaluations_key': 'some_evaluation_data',
//         'other_app_data': 'important_data',
//       });
//       container = ProviderContainer();
//     });
//
//     tearDown(() {
//       container.dispose();
//     });
//   });
//
//   group('Integration Tests', () {
//     late ProviderContainer container;
//
//     setUp(() {
//       SharedPreferences.setMockInitialValues({});
//       container = ProviderContainer();
//     });
//
//     tearDown(() {
//       container.dispose();
//     });
//
//     test('should handle complete profile update flow', () async {
//       // Arrange
//       final userNotifier = container.read(userProvider.notifier);
//       const testName = 'Integration Test User';
//
//       // Act - Complete profile update flow
//       await userNotifier.updateUserDetails(displayName: testName);
//
//       // Assert - State updated
//       expect(container.read(userProvider).displayName, equals(testName));
//
//       // Assert - Data persisted in SharedPreferences
//       final prefs = await SharedPreferences.getInstance();
//       final persistedName = prefs.getString('user_display_name');
//       expect(persistedName, equals(testName));
//
//       // Act - Update again
//       const updatedName = 'Updated User';
//       await userNotifier.updateUserDetails(displayName: updatedName);
//
//       // Assert - Both state and persistence updated
//       expect(container.read(userProvider).displayName, equals(updatedName));
//       final newPersistedName = prefs.getString('user_display_name');
//       expect(newPersistedName, equals(updatedName));
//     });
//
//     // test('should handle complete delete account flow', () async {
//     //   // Arrange - Set up user with data
//     //   final userNotifier = container.read(userProvider.notifier);
//     //   await userNotifier.changeName('User To Delete');
//     //
//     //   // Verify setup
//     //   expect(container.read(userProvider).name, equals('User To Delete'));
//     //   expect(
//     //     container.read(evaluationsProvider).evaluations.length,
//     //     greaterThan(0),
//     //   );
//     //
//     //   // Act - Complete delete flow
//     //   await userNotifier.deleteUserData();
//     //
//     //   // Assert - Everything reset
//     //   expect(container.read(userProvider).name, equals('NAME'));
//     //   expect(container.read(evaluationsProvider).evaluations, isEmpty);
//     //
//     //   // Assert - SharedPreferences cleared
//     //   final prefs = await SharedPreferences.getInstance();
//     //   expect(prefs.getKeys(), isEmpty);
//     // });
//
//     test(
//       'should handle profile update followed by delete',
//       () async {
//         // Arrange
//         final userNotifier = container.read(userProvider.notifier);
//
//         // Act - Update profile first
//         await userNotifier.updateUserDetails(displayName: 'Temp User');
//         expect(container.read(userProvider).displayName, equals('Temp User'));
//
//         // Act - Then delete everything (requires Firebase)
//         // await userNotifier.removeUser();
//
//         // Assert - Everything should be reset
//         // expect(container.read(userProvider).displayName, equals(''));
//         // expect(container.read(evaluationsProvider).evaluations, isEmpty);
//
//         // Assert - Can still update after delete
//         await userNotifier.updateUserDetails(
//           displayName: 'New User After Delete',
//         );
//         expect(
//           container.read(userProvider).displayName,
//           equals('New User After Delete'),
//         );
//       },
//       skip:
//           'Requires Firebase Auth initialization - should be integration test',
//     );
//   });
//
//   group('Error Handling Tests', () {
//     late ProviderContainer container;
//
//     setUp(() {
//       SharedPreferences.setMockInitialValues({});
//       container = ProviderContainer();
//     });
//
//     tearDown(() {
//       container.dispose();
//     });
//
//     test('should handle null name gracefully', () async {
//       // Note: Dart null safety prevents passing null directly,
//       // but we can test with nullable operations
//       final userNotifier = container.read(userProvider.notifier);
//
//       // Act & Assert - Should handle without throwing
//       await userNotifier.updateUserDetails(displayName: '');
//       expect(container.read(userProvider).displayName, equals(''));
//     });
//
//     test(
//       'should maintain state consistency during concurrent operations',
//       () async {
//         // Arrange
//         final userNotifier = container.read(userProvider.notifier);
//
//         // Act - Simulate concurrent name changes
//         final futures = <Future>[];
//         for (int i = 0; i < 10; i++) {
//           futures.add(userNotifier.updateUserDetails(displayName: 'User $i'));
//         }
//
//         await Future.wait(futures);
//
//         // Assert - Final state should be consistent (last update wins)
//         final finalState = container.read(userProvider);
//         expect(finalState.displayName, startsWith('User'));
//       },
//     );
//   });
// }
