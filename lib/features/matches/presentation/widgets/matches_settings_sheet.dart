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

class MatchesSettingsSheet extends StatefulWidget {
  const MatchesSettingsSheet({
    super.key,
    required this.initialColumns,
    required this.onApply,
  });

  final int initialColumns;
  final ValueChanged<int> onApply;

  static Future<void> show(
    BuildContext context, {
    required int initialColumns,
    required ValueChanged<int> onApply,
  }) {
    return AppBottomSheet.show(
      context,
      title: LocaleKeys.matches_settingsTitle.tr(),
      child: MatchesSettingsSheet(
        initialColumns: initialColumns,
        onApply: onApply,
      ),
    );
  }

  @override
  State<MatchesSettingsSheet> createState() => _MatchesSettingsSheetState();
}

class _MatchesSettingsSheetState extends State<MatchesSettingsSheet> {
  late int _columns;

  @override
  void initState() {
    super.initState();
    _columns = widget.initialColumns;
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText(
          LocaleKeys.matches_columnsPerRow.tr(),
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondaryColor.themeColor,
        ),
        14.height,
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: List.generate(7, (i) {
            final value = i + 2;
            final isSelected = value == _columns;
            return CustomTapEffect(
              onTap: () => setState(() => _columns = value),
              child: Container(
                width: 44.w,
                height: 44.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:
                      isSelected ? primary : AppColors.surfaceColor.themeColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? primary
                        : AppColors.dividerColor.themeColor,
                  ),
                ),
                child: AppText(
                  '$value',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? Colors.white
                      : AppColors.textPrimaryColor.themeColor,
                ),
              ),
            );
          }),
        ),
        24.height,
        CustomButton(
          title: LocaleKeys.common_apply.tr(),
          onTap: () {
            Navigator.pop(context);
            widget.onApply(_columns);
          },
        ),
      ],
    );
  }
}
