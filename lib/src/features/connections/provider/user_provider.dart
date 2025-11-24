// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:l_alternative/src/features/connections/model/user_model.dart';
import 'package:l_alternative/src/features/connections/service/connection_service.dart';
import 'package:monikode_event_store/monikode_event_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    XFile? profilePicture,
  }) async {
    state = state.copyWith(
      email: email ?? state.email,
      firstName: firstName ?? state.firstName,
      lastName: lastName ?? state.lastName,
      displayName: displayName ?? state.displayName,
      profilePicture: profilePicture ?? state.profilePicture,
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
      "parameters ": {
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
    var prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('user_id') ?? '';
    var email = prefs.getString('user_email') ?? '';
    var displayName = prefs.getString('user_display_name') ?? '';
    var firstName = prefs.getString('user_first_name') ?? '';
    var lastName = prefs.getString('user_last_name') ?? '';
    var profilePicturePath = prefs.getString('user_profile_picture') ?? '';
    XFile? profilePicture;
    if (profilePicturePath.isNotEmpty) {
      profilePicture = XFile(profilePicturePath);
    }
    state = UserModel(
      id: userId,
      email: email,
      displayName: displayName,
      firstName: firstName,
      lastName: lastName,
      profilePicture: profilePicture,
    );
  }

  Future<void> saveUserData() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', state.id);
    await prefs.setString('user_email', state.email);
    await prefs.setString('user_display_name', state.displayName);
    await prefs.setString('user_first_name', state.firstName);
    await prefs.setString('user_last_name', state.lastName);
    if (state.profilePicture != null) {
      await prefs.setString('user_profile_picture', state.profilePicture!.path);
    }
  }

  Future<void> clearUserData() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('user_email');
    await prefs.remove('user_display_name');
    await prefs.remove('user_first_name');
    await prefs.remove('user_last_name');
    await prefs.remove('user_profile_picture');
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
    await clearUserData();
  }
}
