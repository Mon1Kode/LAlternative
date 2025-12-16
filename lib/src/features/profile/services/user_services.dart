// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:monikode_event_store/monikode_event_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserServices {
  static const _counterKey = 'user_info';

  Future<String> loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    EventStore.getInstance().localEventStore.log(
      "user.name.get",
      EventLevel.debug,
      {
        "parameters": {"message": "User name loaded from local storage"},
      },
    );
    return prefs.getString(_counterKey) ?? "NAME";
  }

  Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_counterKey, name);
    await EventStore.getInstance().eventLogger.log(
      "user.name.update",
      EventLevel.info,
      {
        "parameters": {"new_name": name},
      },
    );
  }
}
