import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../logic/customers_cubit.dart';

class CustomersFilterSheet extends StatefulWidget {
  const CustomersFilterSheet({
    super.key,
    required this.initialSort,
    required this.onApply,
  });

  final CustomersSortOption initialSort;
  final ValueChanged<CustomersSortOption> onApply;

  static Future<void> show(
    BuildContext context, {
    required CustomersSortOption initialSort,
    required ValueChanged<CustomersSortOption> onApply,
  }) {
    return AppBottomSheet.show(
      context,
      title: LocaleKeys.customers_filterTitle.tr(),
      child: CustomersFilterSheet(initialSort: initialSort, onApply: onApply),
    );
  }

  @override
  State<CustomersFilterSheet> createState() => _CustomersFilterSheetState();
}

class _CustomersFilterSheetState extends State<CustomersFilterSheet> {
  late CustomersSortOption _selected;

  static final _options = {
    CustomersSortOption.nameAsc: LocaleKeys.customers_sortNameAsc,
    CustomersSortOption.nameDesc: LocaleKeys.customers_sortNameDesc,
    CustomersSortOption.newest: LocaleKeys.customers_sortNewest,
    CustomersSortOption.oldest: LocaleKeys.customers_sortOldest,
  };

  @override
  void initState() {
    super.initState();
    _selected = widget.initialSort;
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ..._options.entries.map((entry) {
          final isSelected = entry.key == _selected;
          return Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: CustomTapEffect(
              onTap: () => setState(() => _selected = entry.key),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? primary.withValues(alpha: 0.08)
                      : AppColors.surfaceColor.themeColor,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: isSelected
                        ? primary
                        : AppColors.dividerColor.themeColor,
                    width: isSelected ? 1.6 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    AppText(
                      entry.value.tr(),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? primary
                          : AppColors.textPrimaryColor.themeColor,
                    ),
                    const Spacer(),
                    if (isSelected)
                      Icon(Icons.check_circle_rounded,
                          color: primary, size: 20.sp)
                    else
                      Icon(Icons.radio_button_unchecked_rounded,
                          color: AppColors.dividerColor.themeColor,
                          size: 20.sp),
                  ],
                ),
              ),
            ),
          );
        }),
        10.height,
        CustomButton(
          title: LocaleKeys.common_apply.tr(),
          onTap: () {
            Navigator.pop(context);
            widget.onApply(_selected);
          },
        ),
      ],
    );
  }
}
