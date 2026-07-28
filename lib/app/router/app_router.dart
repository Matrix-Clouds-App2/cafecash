import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/di/injection.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/otp_screen.dart';

import '../../features/onboarding/presentation/on_boarding_screen.dart';
import '../../features/settings/logic/settings_cubit.dart';
import '../../features/settings/presentation/change_password_screen.dart';

import '../../features/settings/presentation/settings_screen.dart';
import '../../features/contact_us/logic/contact_us_cubit.dart';
import '../../features/contact_us/presentation/contact_us_screen.dart';
import '../../features/terms/logic/terms_cubit.dart';
import '../../features/terms/presentation/terms_screen.dart';

import '../../features/settings/presentation/update_profile_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/layout/presentation/layout_screen.dart';
import '../../features/home/presentation/slider_details_screen.dart';

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

      case Routes.otpScreen:
        return _pageRoute(OtpScreen(
          phone: arguments?['phone'],
          country: arguments?['country'],
        ));

      case Routes.layoutScreen:
        return _pageRoute(LayoutScreen(
          currentPage: arguments?['currentPage'] ?? 0,
        ));






      case Routes.settingsScreen:
        return _pageRoute(const SettingsScreen());

      case Routes.updateProfileScreen:
        return _pageRoute(
          BlocProvider<SettingsCubit>(
            create: (_) => getIt<SettingsCubit>(),
            child: const UpdateProfileScreen(),
          ),
        );

      case Routes.changePasswordScreen:
        return _pageRoute(
          BlocProvider<SettingsCubit>(
            create: (_) => getIt<SettingsCubit>(),
            child: const ChangePasswordScreen(),
          ),
        );



      case Routes.contactUsScreen:
        return _pageRoute(
          BlocProvider<ContactUsCubit>(
            create: (_) => getIt<ContactUsCubit>(),
            child: const ContactUsScreen(),
          ),
        );

      case Routes.termsScreen:
        return _pageRoute(
          BlocProvider<TermsCubit>(
            create: (_) => getIt<TermsCubit>(),
            child: const TermsScreen(),
          ),
        );

      case Routes.sliderDetailsScreen:
        return _pageRoute(
          SliderDetailsScreen(
            title: arguments?['title'] as String? ?? '',
            image: arguments?['image'] as String? ?? '',
            mainTitle: arguments?['mainTitle'] as String? ?? '',
            description: arguments?['description'] as String? ?? '',
          ),
        );


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
