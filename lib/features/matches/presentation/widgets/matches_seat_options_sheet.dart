import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';

class MatchesSeatOptionsSheet extends StatelessWidget {
  const MatchesSeatOptionsSheet({
    super.key,
    required this.onDisable,
    required this.onDelete,
    required this.canDelete,
  });

  final VoidCallback onDisable;
  final VoidCallback onDelete;

  final bool canDelete;

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onDisable,
    required VoidCallback onDelete,
    required bool canDelete,
  }) {
    return AppBottomSheet.show(
      context,
      title: LocaleKeys.matches_seatLabel.tr(),
      child: MatchesSeatOptionsSheet(
        onDisable: onDisable,
        onDelete: onDelete,
        canDelete: canDelete,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final error = AppColors.errorColor.themeColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTapEffect(
          onTap: () {
            Navigator.pop(context);
            onDisable();
          },
          child: _OptionTile(
            icon: Icons.power_settings_new_rounded,
            label: LocaleKeys.matches_disableOption.tr(),
            color: error,
          ),
        ),
        if (canDelete) ...[
          10.height,
          CustomTapEffect(
            onTap: () {
              Navigator.pop(context);
              onDelete();
            },
            child: _OptionTile(
              icon: Icons.delete_outline_rounded,
              label: LocaleKeys.matches_deleteOption.tr(),
              color: error,
            ),
          ),
        ],
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20.sp),
          ),
          12.width,
          AppText(
            label,
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ],
      ),
    );
  }
}
