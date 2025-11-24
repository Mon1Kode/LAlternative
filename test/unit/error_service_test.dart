// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l_alternative/src/core/service/error_service.dart';

void main() {
  group('ErrorService', () {
    group('getFirebaseAuthErrorMessage', () {
      test('returns correct message for user-not-found', () {
        final exception = FirebaseAuthException(code: 'user-not-found');
        final message = ErrorService.getFirebaseAuthErrorMessage(exception);
        expect(message, 'Aucun utilisateur trouvé avec cet email.');
      });

      test('returns correct message for wrong-password', () {
        final exception = FirebaseAuthException(code: 'wrong-password');
        final message = ErrorService.getFirebaseAuthErrorMessage(exception);
        expect(message, 'Mot de passe incorrect.');
      });

      test('returns correct message for email-already-in-use', () {
        final exception = FirebaseAuthException(code: 'email-already-in-use');
        final message = ErrorService.getFirebaseAuthErrorMessage(exception);
        expect(message, 'Un compte existe déjà avec cet email.');
      });

      test('returns correct message for weak-password', () {
        final exception = FirebaseAuthException(code: 'weak-password');
        final message = ErrorService.getFirebaseAuthErrorMessage(exception);
        expect(
          message,
          'Le mot de passe est trop faible. Il doit contenir au moins 6 caractères.',
        );
      });

      test('returns correct message for invalid-email', () {
        final exception = FirebaseAuthException(code: 'invalid-email');
        final message = ErrorService.getFirebaseAuthErrorMessage(exception);
        expect(message, 'L\'adresse email n\'est pas valide.');
      });

      test('returns correct message for invalid-credential', () {
        final exception = FirebaseAuthException(code: 'invalid-credential');
        final message = ErrorService.getFirebaseAuthErrorMessage(exception);
        expect(message, 'Les identifiants fournis sont invalides.');
      });

      test('returns correct message for too-many-requests', () {
        final exception = FirebaseAuthException(code: 'too-many-requests');
        final message = ErrorService.getFirebaseAuthErrorMessage(exception);
        expect(message, 'Trop de tentatives. Veuillez réessayer plus tard.');
      });

      test('returns correct message for network-request-failed', () {
        final exception = FirebaseAuthException(code: 'network-request-failed');
        final message = ErrorService.getFirebaseAuthErrorMessage(exception);
        expect(
          message,
          'Erreur de connexion. Vérifiez votre connexion internet.',
        );
      });

      test('returns default message for unknown error code', () {
        final exception = FirebaseAuthException(
          code: 'unknown-error',
          message: 'Some error message',
        );
        final message = ErrorService.getFirebaseAuthErrorMessage(exception);
        expect(message, 'Une erreur s\'est produite: Some error message');
      });

      test(
        'returns default message for unknown error code without message',
        () {
          final exception = FirebaseAuthException(code: 'unknown-error');
          final message = ErrorService.getFirebaseAuthErrorMessage(exception);
          expect(message, 'Une erreur s\'est produite: Erreur inconnue');
        },
      );
    });

    group('getErrorMessage', () {
      test('handles FirebaseAuthException', () {
        final exception = FirebaseAuthException(code: 'user-not-found');
        final message = ErrorService.getErrorMessage(exception);
        expect(message, 'Aucun utilisateur trouvé avec cet email.');
      });

      test('handles generic Exception', () {
        final exception = Exception('Test error message');
        final message = ErrorService.getErrorMessage(exception);
        expect(message, 'Test error message');
      });

      test('handles unknown error type', () {
        final error = 'String error';
        final message = ErrorService.getErrorMessage(error);
        expect(message, 'Une erreur inattendue s\'est produite.');
      });
    });

    group('logError', () {
      test('logs error without stacktrace', () {
        // This test just ensures the method runs without throwing
        expect(
          () => ErrorService.logError(Exception('Test error')),
          returnsNormally,
        );
      });

      test('logs error with stacktrace', () {
        // This test just ensures the method runs without throwing
        expect(
          () => ErrorService.logError(
            Exception('Test error'),
            StackTrace.current,
          ),
          returnsNormally,
        );
      });
    });
  });
}
