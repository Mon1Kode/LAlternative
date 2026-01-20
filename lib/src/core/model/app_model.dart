// Shared models for the app

import 'package:l_alternative/src/core/service/database_services.dart';

class AppModel {
  AppModel._();

  static List<String> illustrations = [];

  static Future<void> getIllustrations() async {
    var data = await DatabaseServices.getList("/illustrations");
    illustrations = List<String>.from(data);
  }
}
