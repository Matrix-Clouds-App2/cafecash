import 'package:app_base/app/router/navigation_services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/di/injection.dart';
import '../core/storage/local_storage.dart';
import '../features/home/logic/home_cubit.dart';
import '../features/auth/logic/auth_cubit.dart';
import '../features/profile/logic/profile_cubit.dart';
import 'router/app_router.dart';
import 'router/routes.dart';
import 'theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => getIt<AuthCubit>()),
        BlocProvider<ProfileCubit>(
          create: (_) {
            final cubit = getIt<ProfileCubit>();
            // Avoid unauthenticated profile request when app is in guest mode.
            if (getIt<LocalStorage>().isLoggedIn) {
              cubit.getProfile();
            }
            return cubit;
          },
        ),

        BlocProvider<HomeCubit>(
          create: (_) => getIt<HomeCubit>()..loadHome(),
        ),

      ],
      child: ScreenUtilInit(
          designSize: const Size(375, 812),
          useInheritedMediaQuery: true,
          builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            title: 'WUF 13',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.light,
            initialRoute: Routes.splashScreen,
            navigatorKey: NavigationService.navigationKey,

            onGenerateRoute: RouteGenerator.generateRoute,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
          );
        }
      ),
    );
  }
}
