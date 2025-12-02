import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_alternative/src/core/components/custom_button.dart';
import 'package:l_alternative/src/features/admin/model/activity_model.dart';
import 'package:l_alternative/src/features/admin/provider/new_activity_provier.dart';
import 'package:l_alternative/src/features/admin/views/admin_view.dart';
import 'package:l_alternative/src/features/connections/view/auth_wrapper.dart';
import 'package:l_alternative/src/features/connections/view/login_view.dart';
import 'package:l_alternative/src/features/connections/view/register_view.dart';
import 'package:l_alternative/src/features/evaluations/view/evalutaions_view.dart';
import 'package:l_alternative/src/features/faq/faq_view.dart';
import 'package:l_alternative/src/features/history/view/history_view.dart';
import 'package:l_alternative/src/features/home/view/home_view.dart';
import 'package:l_alternative/src/features/notifications/view/notifications_view.dart';
import 'package:l_alternative/src/features/profile/model/evaluation_model.dart';
import 'package:l_alternative/src/features/profile/view/profile_view.dart';
import 'package:l_alternative/src/features/relaxation/view/activity_template.dart';
import 'package:monikode_event_store/monikode_event_store.dart';

import 'core/provider/app_providers.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Inclusive Sans',
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Colors.white,
          onPrimary: Colors.black,
          secondary: const Color(0xFF636C70),
          onSecondary: Colors.white,
          tertiary: const Color(0xFFF8B29C),
          onTertiary: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
          error: Colors.red,
          onError: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF8B29C),
          foregroundColor: Colors.black,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF636C70),
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Inclusive Sans',
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: const Color(0xFF636C70),
          onPrimary: Colors.white,
          secondary: Colors.white,
          onSecondary: Colors.black,
          tertiary: const Color(0xFFF8B29C),
          onTertiary: Colors.black,
          surface: Colors.black,
          onSurface: Colors.white,
          error: Colors.red,
          onError: Colors.black,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF636C70),
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFF8B29C),
          foregroundColor: Colors.black,
        ),
        useMaterial3: true,
      ),
      themeMode: themeMode,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => const AuthWrapper());
          case '/login':
            return MaterialPageRoute(builder: (context) => const LoginView());
          case '/register':
            return MaterialPageRoute(
              builder: (context) => const RegisterView(),
            );
          case '/home':
            return MaterialPageRoute(builder: (context) => const HomeView());
          case '/profile':
            return MaterialPageRoute(builder: (context) => const ProfileView());
          case '/notifications':
            return MaterialPageRoute(builder: (context) => NotificationsView());
          case '/evaluations':
            final args = settings.arguments;
            if (args is EvaluationModel) {
              return MaterialPageRoute(
                builder: (context) => EvaluationsView(evaluation: args),
              );
            } else {
              return MaterialPageRoute(
                builder: (context) => EvaluationsView(evaluation: null),
              );
            }
          case '/moodHistory':
            final args = settings.arguments;
            if (args is String) {
              return MaterialPageRoute(
                builder: (context) => HistoryView(category: args),
              );
            } else if (args is Map<String, dynamic>) {
              return MaterialPageRoute(
                builder: (context) =>
                    HistoryView(category: args['category'] ?? 'mood_history'),
              );
            } else {
              return MaterialPageRoute(
                builder: (context) =>
                    const HistoryView(category: 'mood_history'),
              );
            }
          case '/admin':
            return MaterialPageRoute(builder: (context) => AdminView());
          case '/admin/new_activity':
            return MaterialPageRoute(
              builder: (context) =>
                  ActivityTemplate(model: settings.arguments as ActivityModel),
            );
          case '/admin/edit_activity':
            var model = settings.arguments as ActivityModel;
            model = model.copyWith(isCompleted: false);
            ref.watch(newActivityProvider.notifier).updateActivity(model);
            ref.watch(newActivityProvider.notifier).updateCompletion(false);
            return MaterialPageRoute(
              builder: (context) =>
                  ActivityTemplate(model: ref.read(newActivityProvider)),
            );
          case '/faq':
            return MaterialPageRoute(builder: (context) => FaqView());
          default:
            EventStore.getInstance().eventLogger.log(
              'app.page_not_found',
              EventLevel.warning,
              {'route_name': settings.name ?? 'unknown'},
            );
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(title: const Text('Page non trouvée')),
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 16,
                      children: [
                        Text('La page demandée est introuvable.'),
                        CustomButton(
                          text: "Retour à l'accueil",
                          routeName: '/login',
                          predicate: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
        }
      },
    );
  }
}
