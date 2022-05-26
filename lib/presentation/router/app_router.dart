import 'package:child_milestone/presentation/screens/login/login_main.dart';
import 'package:child_milestone/presentation/screens/home/home_main.dart';
import 'package:child_milestone/presentation/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:child_milestone/presentation/screens/home.dart';
import 'package:child_milestone/presentation/screens/splash_screen.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    // ignore: unused_local_variable
    final Object? key = settings.arguments;
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
      default:
        return null;
    }
  }
}
