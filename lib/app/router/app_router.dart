import 'package:flutter/material.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/layout/presentation/layout_screen.dart';
import '../../features/onboarding/presentation/on_boarding_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import 'routes.dart';

class RouteGenerator {
  RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments as Map<String, dynamic>?;

    switch (settings.name) {
      case Routes.splashScreen:
        return _pageRoute(const SplashScreen());

      case Routes.onBoardingScreen:
        return _pageRoute(const OnBoardingScreen());

      case Routes.loginScreen:
        return _pageRoute(const LoginScreen());

      case Routes.registerScreen:
        return _pageRoute(const RegisterScreen());

      case Routes.layoutScreen:
        return _pageRoute(LayoutScreen(
          currentPage: arguments?['currentPage'] ?? 0,
        ));

      default:
        return _pageRoute(const _UndefinedScreen());
    }
  }

  static PageRoute<dynamic> _pageRoute(Widget page) {
    return MaterialPageRoute(builder: (_) => page);
  }
}

class _UndefinedScreen extends StatelessWidget {
  const _UndefinedScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Page not found')),
    );
  }
}
