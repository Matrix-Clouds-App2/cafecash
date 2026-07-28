import 'package:coffee_shop/core/extensions/extensions.dart';
import 'package:coffee_shop/core/utils/app_colors.dart';
import 'package:coffee_shop/core/widgets/app_text.dart';
import 'package:coffee_shop/core/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_tap_effect.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback _onTap;
  final Widget? _child;
  final String? _title;
  final Color? _color;
  final Color? _borderColor;
  final Color? _textColor;
  final double? _width;
  final double? _height;
  final double? _fontSize;
  final bool _isRounded;
  final bool _isOutlined;
  final bool _widerPadding;
  final bool _loading;
  final bool _expanded;
  final double _radius;
  final double? _customRadius;

  const CustomButton({
    super.key,
    required VoidCallback onTap,
    Widget? child,
    String? title,
    Color? color,
    Color? borderColor,
    Color? textColor,
    double? width,
    double? customRadius,
    double? fontSize,
    double? height,
    double radius = 16,
    bool isRounded = true,
    bool isOutlined = false,
    bool widerPadding = false,
    bool loading = false,
    bool expanded = true,
  })  : _onTap = onTap,
        _child = child,
        _title = title,
        _expanded = expanded,
        _color = color,
        _textColor = textColor,
        _borderColor = borderColor,
        _width = width,
        _radius = radius,
        _customRadius = customRadius,
        _fontSize = fontSize,
        _height = height,
        _isRounded = isRounded,
        _isOutlined = isOutlined,
        _widerPadding = widerPadding,
        _loading = loading;

  @override
  Widget build(BuildContext context) {
    double radius = _customRadius ?? _radius;
    return SizedBox(
      width: _width?? double.infinity,
      height: (_height ?? 46).h,
      child: CustomTapEffect(
        isClickable: !_loading,
        onTap: _loading ? null : _onTap,
        child: MaterialButton(
          color: _isOutlined ? Colors.transparent : (_color ?? AppColors.primaryColor.darkColor),
          highlightElevation: 0,
          onPressed: _loading ? () {} : _onTap,
          padding: !_widerPadding ? EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w) : EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          elevation: 0,
          shape: _isRounded
              ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius), side: BorderSide(color: _borderColor ?? Theme.of(context).primaryColor, width: 1.5.w))
              : RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius), side: BorderSide(color: _borderColor ?? Theme.of(context).primaryColor, width: 1.5.w)),
          child: _loading
              ? CustomLoadingWidget(size: (_height ?? 20).h, color: _isOutlined? _borderColor : Colors.white)
              : _title != null
              ? Container(
            padding: 2.paddingBottom,
            child:
            AppText(_title,
            fontSize:  _fontSize ?? 15,
              fontWeight: FontWeight.bold,
             color: _textColor ??(_isOutlined? AppColors.primaryColor.themeColor :
             Colors.white),
            )

          )
              : _child ?? const SizedBox(),
        ),
      ),
    );
  }
}
