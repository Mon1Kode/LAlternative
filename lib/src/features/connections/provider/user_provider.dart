// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_alternative/src/core/service/database_services.dart';
import 'package:l_alternative/src/features/connections/model/user_model.dart';
import 'package:l_alternative/src/features/connections/service/connection_service.dart';
import 'package:monikode_event_store/monikode_event_store.dart';

var userProvider = StateNotifierProvider<UserProvider, UserModel>(
  (ref) => UserProvider(),
);

class UserProvider extends StateNotifier<UserModel> {
  UserProvider()
    : super(
        UserModel(
          id: '',
          displayName: '',
          firstName: '',
          lastName: '',
          email: '',
        ),
      );

  Future<void> setUser(UserModel user) async {
    state = user;
    await loadUserData();
  }

  Future<void> setUserFromCredentials(UserCredential credentials) async {
    final firebaseUser = credentials.user;
    if (firebaseUser != null) {
      state = UserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? 'NO_EMAIL',
        displayName: firebaseUser.displayName ?? 'NO_NAME',
      );
    }
    await saveUserData();
  }

  Future<void> updateUserDetails({
    String? email,
    String? firstName,
    String? lastName,
    String? displayName,
    String? profilePicture,
    int? streakCount,
    String? streakIcon,
    bool? hasTodayLoggedIn,
    DateTime? lastLoginDate,
  }) async {
    state = state.copyWith(
      email: email ?? state.email,
      firstName: firstName ?? state.firstName,
      lastName: lastName ?? state.lastName,
      displayName: displayName ?? state.displayName,
      profilePicture: profilePicture ?? state.profilePicture,
      streakCount: streakCount ?? state.streakCount,
      streakIcon: streakIcon != null
          ? StreakIcon.values.firstWhere(
              (e) => e.toString() == 'StreakIcon.$streakIcon',
              orElse: () => state.streakIcon,
            )
          : state.streakIcon,
      hasTodayLoggedIn: hasTodayLoggedIn ?? state.hasTodayLoggedIn,
      lastLoginDate: lastLoginDate ?? state.lastLoginDate,
    );
    if (email != null) {
      var user = FirebaseAuth.instance.currentUser;
      await user?.verifyBeforeUpdateEmail(email);
      EventStore.getInstance().eventLogger.log(
        "user.update_email",
        EventLevel.info,
        {
          "parameters": {"email": state.email},
        },
      );
      return;
    }
    if (displayName != null) {
      var user = FirebaseAuth.instance.currentUser;
      await user?.updateDisplayName(displayName);
      EventStore.getInstance().eventLogger.log(
        "user.update_name",
        EventLevel.info,
        {
          "parameters": {"display_name": state.displayName},
        },
      );
      return;
    }
    EventStore.getInstance().eventLogger.log("user.update", EventLevel.info, {
      "parameters": {
        "email": state.email,
        "first_name": state.firstName,
        "last_name": state.lastName,
        "display_name": state.displayName,
      },
    });
    await saveUserData();
  }

  UserModel getUser() {
    return state;
  }

  void logout(BuildContext context) {
    state = UserModel(
      id: '',
      displayName: '',
      firstName: '',
      lastName: '',
      email: '',
    );
    ConnectionService().logout();
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  Future<void> loadUserData() async {
    var snapshot = await DatabaseServices.get(
      "/users/${FirebaseAuth.instance.currentUser?.uid}",
    );
    var data = snapshot.value as Map<dynamic, dynamic>?;
    if (data != null) {
      var userId =
          data['id'] as String? ?? FirebaseAuth.instance.currentUser?.uid ?? '';
      var email =
          data['email'] as String? ??
          FirebaseAuth.instance.currentUser?.email ??
          '';
      var displayName =
          data['display_name'] as String? ??
          FirebaseAuth.instance.currentUser?.displayName ??
          '';
      var firstName = data['first_name'] as String? ?? '';
      var lastName = data['last_name'] as String? ?? '';
      var profilePicturePath = data['profile_picture'] as String? ?? 'm';
      var streakIconString = data['streak_icon'] as String? ?? 'default';
      var streakIcon = StreakIcon.values.firstWhere(
        (e) => e.toString() == 'StreakIcon.$streakIconString',
        orElse: () => StreakIcon.rose,
      );
      var hasTodayLoggedIn = data['has_today_logged_in'] as bool? ?? false;
      DateTime? lastLoginDate;
      if (data['last_login_date'] != null) {
        lastLoginDate = DateTime.fromMillisecondsSinceEpoch(
          data['last_login_date'] as int,
        );
      }
      state = UserModel(
        id: userId,
        email: email,
        displayName: displayName,
        firstName: firstName,
        lastName: lastName,
        profilePicture: profilePicturePath,
        streakCount: data['streak_count'] as int? ?? 0,
        streakIcon: streakIcon,
        hasTodayLoggedIn: hasTodayLoggedIn,
        lastLoginDate: lastLoginDate,
      );
    }
  }

  Future<void> saveUserData() async {
    DatabaseServices.update("/users/${state.id}", {
      'id': state.id,
      'email': state.email,
      'display_name': state.displayName,
      'first_name': state.firstName,
      'last_name': state.lastName,
      'profile_picture': state.profilePicture,
      'streak_count': state.streakCount,
      'streak_icon': state.streakIcon.toString().split('.').last,
      'has_today_logged_in': state.hasTodayLoggedIn,
      'last_login_date': state.lastLoginDate?.millisecondsSinceEpoch,
    });
  }

  Future<void> removeUser() async {
    state = UserModel(
      id: '',
      displayName: '',
      firstName: '',
      lastName: '',
      email: '',
    );
    ConnectionService().delete();
  }

  void incrementStreak({int nb = 1}) {
    state = state.copyWith(streakCount: state.streakCount + nb);
  }

  Future<void> resetStreak() async {
    EventStore.getInstance().eventLogger.log(
      "user.streak.reset",
      EventLevel.info,
      {
        "parameters": {"old_streak_count": state.streakCount},
      },
    );
    state = state.copyWith(streakCount: 1);
    await DatabaseServices.update("/users/${state.id}", {
      'streak_count': state.streakCount,
    });
  }
}
