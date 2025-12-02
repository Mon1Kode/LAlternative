// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:l_alternative/src/core/service/database_services.dart';
import 'package:monikode_event_store/monikode_event_store.dart';

class ConnectionService {
  bool validateEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  bool validatePassword(String password) {
    return password.length >= 6;
  }

  bool passwordsMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  Future<UserCredential> singInViaFirebaseEmailPassword(
    String email,
    String password,
  ) async {
    if (!validateEmail(email) || !validatePassword(password)) {
      throw Exception("Email ou mot de passe invalide");
    }
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    if (userCredential.user == null) {
      throw FirebaseAuthException(code: 'user-not-found');
    }
    EventStore.getInstance().eventLogger.log("user.login", EventLevel.info, {
      "parameters": {"email": email},
    });
    return userCredential;
  }

  Future<UserCredential> signUpViaFirebaseEmailPassword(
    String email,
    String password,
  ) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    if (userCredential.user == null) {
      throw FirebaseAuthException(code: 'user-not-found');
    }
    await ConnectionService().sendEmailVerification();
    DatabaseServices.update("/users/${userCredential.user?.uid}", {
      "email": email,
      "id": userCredential.user?.uid,
    });
    EventStore.getInstance().eventLogger.log("user.signup", EventLevel.info, {
      "parameters": {"email": email},
    });
    return userCredential;
  }

  void logout() {
    EventStore.getInstance().eventLogger.log("user.logout", EventLevel.info, {
      "parameters": {"email": FirebaseAuth.instance.currentUser?.email},
    });
    FirebaseAuth.instance.signOut();
  }

  bool isUserLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  void delete() {
    EventStore.getInstance().eventLogger.log(
      "user.delete_account",
      EventLevel.warning,
      {
        "parameters": {"email": FirebaseAuth.instance.currentUser?.email},
      },
    );
    DatabaseServices.remove("/users/${FirebaseAuth.instance.currentUser?.uid}");
    FirebaseAuth.instance.currentUser?.delete();
    FirebaseAuth.instance.signOut();
  }

  Future<void> updateEmail(String newEmail) async {
    await FirebaseAuth.instance.currentUser?.verifyBeforeUpdateEmail(newEmail);
    DatabaseServices.update(
      "/users/${FirebaseAuth.instance.currentUser?.uid}",
      {"email": newEmail},
    );
    EventStore.getInstance().eventLogger.log(
      "user.update_email",
      EventLevel.warning,
      {
        "parameters": {"new_email": newEmail},
      },
    );
  }

  Future<void> sendEmailVerification() async {
    await FirebaseAuth.instance.currentUser?.sendEmailVerification();
  }
}
