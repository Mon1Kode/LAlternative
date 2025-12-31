// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monikode_event_store/monikode_event_store.dart';

/// Service to handle and format errors across the application
class ErrorService {
  /// Convert Firebase Auth exceptions to user-friendly messages
  static String getFirebaseAuthErrorMessage(FirebaseAuthException e) {
    EventStore.getInstance().eventLogger.log(
      'firebase.auth.error',
      EventLevel.error,
      {
        'parameters': {'code': e.code, 'message': e.message ?? 'No message'},
      },
    );
    switch (e.code) {
      // Login/Sign-in errors
      case 'user-not-found':
        return 'Aucun utilisateur trouvé avec cet email.';
      case 'wrong-password':
        return 'Mot de passe incorrect.';
      case 'invalid-credential':
        return 'Les identifiants fournis sont invalides.';
      case 'user-disabled':
        return 'Ce compte a été désactivé.';
      case 'too-many-requests':
        return 'Trop de tentatives. Veuillez réessayer plus tard.';

      // Registration errors
      case 'email-already-in-use':
        return 'Un compte existe déjà avec cet email.';
      case 'weak-password':
        return 'Le mot de passe est trop faible. Il doit contenir au moins 6 caractères.';
      case 'invalid-email':
        return 'L\'adresse email n\'est pas valide.';
      case 'operation-not-allowed':
        return 'Cette opération n\'est pas autorisée.';

      // Password reset errors
      case 'expired-action-code':
        return 'Le code de réinitialisation a expiré.';
      case 'invalid-action-code':
        return 'Le code de réinitialisation est invalide.';

      // Account management errors
      case 'requires-recent-login':
        return 'Cette opération nécessite une reconnexion récente.';
      case 'provider-already-linked':
        return 'Ce compte est déjà lié à un autre fournisseur.';
      case 'credential-already-in-use':
        return 'Ces identifiants sont déjà utilisés par un autre compte.';

      // Network errors
      case 'network-request-failed':
        return 'Erreur de connexion. Vérifiez votre connexion internet.';

      // Generic error
      default:
        return 'Une erreur s\'est produite: ${e.message ?? 'Erreur inconnue'}';
    }
  }

  /// Handle any exception and return a user-friendly message
  static String getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      return getFirebaseAuthErrorMessage(error);
    } else if (error is String) {
      return error;
    } else if (error is FirebaseException) {
      EventStore.getInstance().eventLogger.log(
        'firebase.error',
        EventLevel.error,
        {
          'parameters': {
            'code': error.code,
            'message': error.message ?? 'No message',
          },
        },
      );
      return 'Erreur Firebase: ${error.message ?? 'Erreur inconnue'}';
    } else if (error is Exception) {
      EventStore.getInstance().eventLogger.log(
        'app.exception',
        EventLevel.error,
        {
          'parameters': {'message': error.toString()},
        },
      );
      return error.toString().replaceFirst('Exception: ', '');
    } else {
      EventStore.getInstance().eventLogger.log(
        'app.unknown_error',
        EventLevel.error,
        {
          'parameters': {'error': error.toString()},
        },
      );
      return 'Une erreur inattendue s\'est produite.';
    }
  }

  /// Show error message in a SnackBar
  static void showErrorSnackBar(BuildContext context, dynamic error) {
    final message = getErrorMessage(error);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Show success message in a SnackBar
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Show info message in a SnackBar
  static void showInfoSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Show a custom error dialog
  static Future<void> showErrorDialog(
    BuildContext context,
    dynamic error, {
    String? title,
  }) async {
    final message = getErrorMessage(error);
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title ?? 'Erreur'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Log error for debugging (can be extended to send to analytics)
  static void logError(dynamic error, [StackTrace? stackTrace]) {
    debugPrint('❌ Error: $error');
    if (stackTrace != null) {
      debugPrint('Stack trace: $stackTrace');
    }
    // EventStore.getInstance().eventLogger.log(
    //   'app.error_logged',
    //   EventLevel.error,
    //   {
    //     'parameters': {
    //       'error': error.toString(),
    //       if (stackTrace != null) 'stack_trace': stackTrace.toString(),
    //     },
    //   },
    // );
  }

  /// Handle error with logging and UI feedback
  static void handleError(
    BuildContext context,
    dynamic error, {
    StackTrace? stackTrace,
    bool showDialog = false,
    String? dialogTitle,
  }) {
    logError(error, stackTrace);

    if (showDialog) {
      showErrorDialog(context, error, title: dialogTitle);
    } else {
      showErrorSnackBar(context, error);
    }
  }
}
