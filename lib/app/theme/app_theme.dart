import 'package:flutter/material.dart';

import '../../core/utils/app_colors.dart';

class AppTheme {
  AppTheme._();

  static const String _font = 'Cairo';

  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        fontFamily: _font,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor.light,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.backgroundColor.light,
      );

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        fontFamily: _font,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor.dark,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.backgroundColor.dark,
      );
}
