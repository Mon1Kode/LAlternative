// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:image_picker/image_picker.dart';

enum StreakIcon { rose, flame, star, diamond, crown }

class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String firstName;
  final String lastName;
  XFile? profilePicture;
  final int streakCount;
  final StreakIcon streakIcon;
  final bool hasTodayLoggedIn;
  final DateTime? lastLoginDate;

  UserModel({
    this.id = 'XX00XX',
    this.email = 'EMAIL_NOT_FOUND',
    this.displayName = 'NAME',
    this.firstName = 'FIRST_NAME',
    this.lastName = 'LAST_NAME',
    this.profilePicture,
    this.streakCount = 1,
    this.streakIcon = StreakIcon.rose,
    this.hasTodayLoggedIn = false,
    this.lastLoginDate,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      id: documentId,
      email: data['email'] ?? 'EMAIL_NOT_FOUND',
      displayName: data['displayName'] ?? 'NAME',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      profilePicture: data['profilePicture'] != null
          ? XFile(data['profilePicture'])
          : null,
      streakCount: data['streakCount'] ?? 1,
      streakIcon: StreakIcon.values.firstWhere(
        (e) => e.toString() == 'StreakIcon.${data['streakIcon'] ?? 'rose'}',
        orElse: () => StreakIcon.rose,
      ),
      hasTodayLoggedIn: data["hasTodayLoggedIn"] ?? false,
      lastLoginDate: data["lastLoginDate"] != null
          ? DateTime.fromMillisecondsSinceEpoch(data["lastLoginDate"])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'firstName': firstName,
      'lastName': lastName,
      'profilePicture': profilePicture?.path,
      'streakCount': streakCount,
      'streakIcon': streakIcon.toString().split('.').last,
      'hasTodayLoggedIn': hasTodayLoggedIn,
      'lastLoginDate': lastLoginDate,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? firstName,
    String? lastName,
    XFile? profilePicture,
    int? streakCount,
    StreakIcon? streakIcon,
    bool? hasTodayLoggedIn,
    DateTime? lastLoginDate,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profilePicture: profilePicture ?? this.profilePicture,
      streakCount: streakCount ?? this.streakCount,
      streakIcon: streakIcon ?? this.streakIcon,
      hasTodayLoggedIn: hasTodayLoggedIn ?? this.hasTodayLoggedIn,
      lastLoginDate: lastLoginDate ?? this.lastLoginDate,
    );
  }

  @override
  String toString() {
    return 'UserModel{id: $id,'
        'email: $email,'
        'displayName: $displayName,'
        'firstName: $firstName,'
        'lastName: $lastName,'
        'profilePicture: ${profilePicture?.path},'
        'streakCount: $streakCount,'
        'streakIcon: $streakIcon'
        'hasTodayLoggedIn: $hasTodayLoggedIn,'
        'lastLoginDate: $lastLoginDate}';
  }
}
