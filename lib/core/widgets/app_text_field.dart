import 'package:app_base/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.hint,
    this.label,
    this.controller,
    this.validator,
    this.keyboardType,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.onChanged,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.filled = true,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.borderRadius,
    this.contentPadding,
    this.textStyle,
    this.hintStyle,
    this.labelStyle,
  });

  final String hint;
  final String? label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool isPassword;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool filled;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    const defaultFillColor = Color(0xFFE7EAE6);
    const defaultBorderColor = Color(0xFFD4D9D3);
    const defaultHintColor = Color(0xFF66706A);
    const defaultTextColor = Color(0xFF2C3430);

    final borderRadius = widget.borderRadius ?? 16;
    final enabledBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: widget.borderColor ?? defaultBorderColor),
    );

    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      obscureText: widget.isPassword && _obscure,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      onChanged: widget.onChanged,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      style: widget.textStyle ??
          const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: defaultTextColor,
          ),
      decoration: InputDecoration(
        hintText: widget.hint,
        labelText: widget.label,
        hintStyle: widget.hintStyle ??
            const TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: defaultHintColor,
            ),
        labelStyle: widget.labelStyle ??
            const TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: defaultHintColor,
            ),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(_obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined),
                onPressed: () => setState(() => _obscure = !_obscure),
              )
            : widget.suffixIcon,
        filled: widget.filled,
        fillColor: widget.fillColor ?? defaultFillColor,
        border: enabledBorder,
        enabledBorder: enabledBorder,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color:
                widget.focusedBorderColor ?? AppColors.primaryColor.themeColor,
            width: 1.2,
          ),
        ),
        disabledBorder: enabledBorder,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: AppColors.errorColor.themeColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide:
              BorderSide(color: AppColors.errorColor.themeColor, width: 1.2),
        ),
        contentPadding: widget.contentPadding ??
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      ),
    );
  }
}

@Deprecated('Use CustomTextField instead.')
typedef AppTextField = CustomTextField;
