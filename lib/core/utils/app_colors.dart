import 'package:cafecash/app/router/navigation_services.dart';
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
    if (context != null && Theme.of(context).brightness == Brightness.dark) {
      return darkColor;
    } else {
      return lightColor;
    }
  }
}

class AppColors {
  AppColors._();

  // ─── Brand palette (لوحة ألوان كافيه كاش) ────────────────────────────────
  static const ColorModel primaryColor = ColorModel(
    lightColor: Color(0xffFACB82),
    darkColor: Color(0xffFACB82),
  );

  static const ColorModel secondaryColor = ColorModel(
    lightColor: Color(0xFF7A4B24),
    darkColor: Color(0xFF7A4B24),
  );

  /// Accent — كراميل/ذهبي، لأي CTA أو تفصيلة مميزة.
  static const ColorModel accentGold = ColorModel(
    lightColor: Color(0xFFC58A32),
    darkColor: Color(0xFFC58A32),
  );

  /// Light Accent — ذهبي فاتح، لتظليل خفيف حوالين الـ accent.
  static const ColorModel lightAccentColor = ColorModel(
    lightColor: Color(0xFFE0B66A),
    darkColor: Color(0xFFE0B66A),
  );

  static const ColorModel backgroundColor = ColorModel(
    lightColor: Color(0xFFFFF7E8),
    darkColor: Color(0xFF1E1712),
  );

  static const ColorModel surfaceColor = ColorModel(
    lightColor: Color(0xFFF5E7CF),
    darkColor: Color(0xFF2A2119),
  );

  static const ColorModel cardColor = ColorModel(
    lightColor: Color(0xFFFFFFFF),
    darkColor: Color(0xFF2C2C2C),
  );

  static const ColorModel textPrimaryColor = ColorModel(
    lightColor: Color(0xff773702),
    darkColor: Color(0xffE09741),
  );

  static const ColorModel textSecondaryColor = ColorModel(
    lightColor: Color(0xFF765F50),
    darkColor: Color(0xFFB0A18F),
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

  /// Neutral gray — للحالات المعطّلة (زي ترابيزة/كرسي متوقف).
  static const ColorModel disabledColor = ColorModel(
    lightColor: Color(0xFF9E9E9E),
    darkColor: Color(0xFF6E6E6E),
  );

  /// كهرماني — لأزرار زي "دفع جزئي".
  static const ColorModel warningColor = ColorModel(
    lightColor: Color(0xFFF5A623),
    darkColor: Color(0xFFF5A623),
  );

  /// أزرق — لأزرار إعلامية زي "ترحيل للأجل".
  static const ColorModel infoColor = ColorModel(
    lightColor: Color(0xFF2F80ED),
    darkColor: Color(0xFF2F80ED),
  );
}
