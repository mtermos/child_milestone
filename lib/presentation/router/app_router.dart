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
      default:
        return null;
    }
  }
}
