import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text_field.dart';

/// Item-name search field at the top of the order-builder sheet.
class OrderSearchField extends StatelessWidget {
  const OrderSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      onChanged: onChanged,
      hint: LocaleKeys.orders_searchHint.tr(),
      fillColor: AppColors.cardColor.themeColor,
      borderColor: Colors.transparent,
      borderRadius: 14,
      suffixIcon: Icon(Icons.search_rounded,
          color: AppColors.textSecondaryColor.themeColor, size: 22.sp),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
    );
  }
}
