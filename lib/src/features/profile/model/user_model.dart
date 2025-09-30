// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

class UserModel {
  final String name;
  const UserModel(this.name);

  UserModel copyWith({String? newName}) => UserModel(newName ?? name);
}
