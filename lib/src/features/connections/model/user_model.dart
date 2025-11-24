// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:image_picker/image_picker.dart';

class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String firstName;
  final String lastName;
  XFile? profilePicture;

  UserModel({
    this.id = 'XX00XX',
    this.email = 'EMAIL_NOT_FOUND',
    this.displayName = 'NAME',
    this.firstName = 'FIRST_NAME',
    this.lastName = 'LAST_NAME',
    this.profilePicture,
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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'firstName': firstName,
      'lastName': lastName,
      'profilePicture': profilePicture?.path,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? firstName,
    String? lastName,
    XFile? profilePicture,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }

  @override
  String toString() {
    return 'UserModel{id: $id, email: $email, displayName: $displayName, firstName: $firstName, lastName: $lastName, profilePicture: ${profilePicture?.path}}';
  }
}
