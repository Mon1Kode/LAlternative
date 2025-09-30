// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_alternative/src/features/profile/model/user_model.dart';
import 'package:l_alternative/src/features/profile/provider/evaluation_provider.dart';
import 'package:l_alternative/src/features/profile/services/user_services.dart';
import 'package:monikode_event_store/monikode_event_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserModel>(
  (ref) => UserNotifier(ref),
);

class UserNotifier extends StateNotifier<UserModel> {
  final Ref ref;

  UserNotifier(this.ref) : super(const UserModel("NAME")) {
    _getStoredName();
  }

  Future<void> _getStoredName() async {
    final service = UserServices();
    final value = await service.loadUserName();
    state = UserModel(value);
  }

  Future<void> deleteStoredName() async {
    final service = UserServices();
    await service.saveUserName("NAME");
    state = const UserModel("NAME");
  }

  Future<void> changeName(String newName) async {
    state = state.copyWith(newName: newName);
    await UserServices().saveUserName(newName);
  }

  Future<void> deleteUserData() async {
    var pref = await SharedPreferences.getInstance();
    await pref.clear();
    state = const UserModel("NAME");
    ref.read(evaluationsProvider.notifier).clearEvaluations();
    EventStore.getInstance().localEventStore.log(
      "user_delete",
      EventLevel.warning,
      {"message": "User data deleted"},
    );
  }
}
