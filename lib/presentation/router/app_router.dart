import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/data/models/milestone_item.dart';
import 'package:child_milestone/presentation/screens/add_child/add_child_main.dart';
import 'package:child_milestone/presentation/screens/child_summary/child_summary_main.dart';
import 'package:child_milestone/presentation/screens/edit_child/edit_child_main.dart';
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
    switch (settings.name) {
      case Routes.splashScreen:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case Routes.welcome:
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
        );
      case Routes.login:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
        );
      case Routes.home:
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
        );
      case Routes.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        );
      case Routes.milestone:
        return MaterialPageRoute(
          builder: (_) =>
              MilestoneScreen(periodId: key != null ? key as int : null),
        );
      case Routes.addChild:
        return MaterialPageRoute(
          builder: (_) => AddChildScreen(),
        );
      case Routes.childSummary:
        return MaterialPageRoute(
          builder: (_) => const ChildSummaryScreen(),
        );
      case Routes.editChild:
        return MaterialPageRoute(
          builder: (_) => EditChildScreen(childId: key as int),
        );
      default:
        return null;
    }
  }
}
