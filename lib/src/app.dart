import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_alternative/src/features/evaluations/view/evalutaions_view.dart';
import 'package:l_alternative/src/features/history/view/history_view.dart';
import 'package:l_alternative/src/features/home/view/home_view.dart';
import 'package:l_alternative/src/features/notifications/view/notifications_view.dart';
import 'package:l_alternative/src/features/profile/model/evaluation_model.dart';
import 'package:l_alternative/src/features/profile/view/profile_view.dart';

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
          default:
            return MaterialPageRoute(
              builder: (context) =>
                  const Scaffold(body: Center(child: Text('Page not found'))),
            );
        }
      },
    );
  }
}
