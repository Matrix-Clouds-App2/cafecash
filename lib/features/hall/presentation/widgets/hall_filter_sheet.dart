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
import '../../logic/hall_cubit.dart';

class HallFilterSheet extends StatefulWidget {
  const HallFilterSheet({
    super.key,
    required this.initialSort,
    required this.onApply,
  });

  final HallSortOption initialSort;
  final ValueChanged<HallSortOption> onApply;

  static Future<void> show(
    BuildContext context, {
    required HallSortOption initialSort,
    required ValueChanged<HallSortOption> onApply,
  }) {
    return AppBottomSheet.show(
      context,
      title: LocaleKeys.hall_filterTitle.tr(),
      child: HallFilterSheet(initialSort: initialSort, onApply: onApply),
    );
  }

  @override
  State<HallFilterSheet> createState() => _HallFilterSheetState();
}

class _HallFilterSheetState extends State<HallFilterSheet> {
  late HallSortOption _selected;

  static final _options = {
    HallSortOption.numberAsc: LocaleKeys.hall_sortNumberAsc,
    HallSortOption.numberDesc: LocaleKeys.hall_sortNumberDesc,
    HallSortOption.priceAsc: LocaleKeys.hall_sortPriceAsc,
    HallSortOption.priceDesc: LocaleKeys.hall_sortPriceDesc,
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
