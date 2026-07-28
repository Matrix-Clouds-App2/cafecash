import 'package:app_base/app/router/navigation_services.dart';
import 'package:flutter/material.dart';

class ColorModel {
  final Color lightColor;
  final Color darkColor;

  const ColorModel({required this.lightColor, required this.darkColor});

  Color get light => lightColor;
  Color get dark => darkColor;


}
extension ColorTheme on ColorModel {
  Color get themeColor {
    final context = NavigationService.navigationKey.currentContext;
    if (context != null &&
        Theme.of(context).brightness == Brightness.dark) {
      return darkColor;
    } else {
      return lightColor;
    }
  }
}

class AppColors {
  AppColors._();

  static const ColorModel primaryColor = ColorModel(
    lightColor: Color(0xff0a3320),
    darkColor: Color(0xff0a3320),
  );

  static const ColorModel secondaryColor = ColorModel(
    lightColor: Color(0xff1B5583),
    darkColor: Color(0xff1B5583),
  );

  static const ColorModel backgroundColor = ColorModel(
    lightColor: Color(0xffFFFFFF),
    darkColor: Color(0xff121212),
  );

  static const ColorModel surfaceColor = ColorModel(
    lightColor: Color(0xffF5F5F5),
    darkColor: Color(0xff1E1E1E),
  );

  static const ColorModel textPrimaryColor = ColorModel(
    lightColor: Color(0xff1A1A1A),
    darkColor: Color(0xffFFFFFF),
  );

  static const ColorModel textSecondaryColor = ColorModel(
    lightColor: Color(0xff757575),
    darkColor: Color(0xffB0B0B0),
  );

  static const ColorModel errorColor = ColorModel(
    lightColor: Color(0xffD32F2F),
    darkColor: Color(0xffEF5350),
  );

  static const ColorModel successColor = ColorModel(
    lightColor: Color(0xff388E3C),
    darkColor: Color(0xff66BB6A),
  );

  static const ColorModel dividerColor = ColorModel(
    lightColor: Color(0xffE0E0E0),
    darkColor: Color(0xff424242),
  );

  static const ColorModel hintColor = ColorModel(
    lightColor: Color(0xffBDBDBD),
    darkColor: Color(0xff616161),
  );

  static const ColorModel cardColor = ColorModel(
    lightColor: Color(0xffFFFFFF),
    darkColor: Color(0xff2C2C2C),
  );

  /// Golden accent — used for the final onboarding CTA button.
  static const ColorModel accentGold = ColorModel(
    lightColor: Color(0xFFD4A843),
    darkColor: Color(0xFFD4A843),
  );
}
