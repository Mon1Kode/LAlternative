import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:l_alternative/src/core/model/app_model.dart';
import 'package:l_alternative/src/features/notifications/services/fcm_service.dart';
import 'package:l_alternative/src/features/notifications/services/notifications_services.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize date formatting early so locale data is available to any
  // service or widget that runs during app startup.
  await initializeDateFormatting();
  await Firebase.initializeApp();
  await NotificationService.init();
  await FCMService.initialize();
  await AppModel.getIllustrations();

  // fix portrait mode only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const ProviderScope(child: MyApp()));
}
