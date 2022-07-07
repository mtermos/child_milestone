import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/presentation/screens/add_child/add_child_main.dart';
import 'package:child_milestone/presentation/screens/child_summary/child_summary_main.dart';
import 'package:child_milestone/presentation/screens/login/login_main.dart';
import 'package:child_milestone/presentation/screens/home/home_main.dart';
import 'package:child_milestone/presentation/screens/milestone/milestone_main.dart';
import 'package:child_milestone/presentation/screens/settings/settings_main.dart';
import 'package:child_milestone/presentation/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:child_milestone/presentation/screens/splash_screen.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    // ignore: unused_local_variable
    final Object? key = settings.arguments;
    print('key: ${key}');
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
        );
      case '/welcome':
        return MaterialPageRoute(
          builder: (_) => WelcomeScreen(),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
        );
      case '/settings':
        return MaterialPageRoute(
          builder: (_) => SettingsScreen(),
        );
      case '/milestone':
        return MaterialPageRoute(
          builder: (_) => MilestoneScreen(category: key != null ? key as int : 1),
        );
      case '/add_child':
        return MaterialPageRoute(
          builder: (_) => AddChildScreen(),
        );
      case childSummaryRoute:
        return MaterialPageRoute(
          builder: (_) => ChildSummaryScreen(),
        );
      default:
        return null;
    }
  }
}
