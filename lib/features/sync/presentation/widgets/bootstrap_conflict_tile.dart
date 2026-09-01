import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../../../core/widgets/image/custom_image.dart';
import '../../data/models/bootstrap_merge_plan.dart';

class BootstrapConflictTile extends StatelessWidget {
  const BootstrapConflictTile({
    super.key,
    required this.conflict,
    required this.choice,
    required this.onChanged,
  });

  final BootstrapConflict conflict;
  final BootstrapConflictChoice choice;
  final ValueChanged<BootstrapConflictChoice> onChanged;

  @override
  Widget build(BuildContext context) {
    final showImages = conflict.localImage != null &&
        conflict.serverImage != null &&
        conflict.localImage != conflict.serverImage;

    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 12.h),
      padding: 14.paddingAll,
      decoration: BoxDecoration(
        color: AppColors.backgroundColor.themeColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.dividerColor.themeColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _chip(context),
              8.width,
              Expanded(
                child: AppText(
                  conflict.title,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryColor.themeColor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          10.height,
          if (conflict.deletedOnServer)
            AppText(
              LocaleKeys.sync_conflictDeletedRemotely.tr(),
              fontSize: 12.5,
              color: AppColors.errorColor.themeColor,
              fontWeight: FontWeight.w600,
            )
          else ...[
            _columnHeaders(context),
            6.height,
            ...conflict.fields.map((f) => _fieldRow(context, f)),
            if (showImages) ...[
              8.height,
              _imageRow(),
            ],
          ],
          12.height,
          _selector(context),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.themeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: AppText(
        _kindLabel(),
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryColor.themeColor,
      ),
    );
  }

  Widget _columnHeaders(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 64.w),
        Expanded(
          child: AppText(
            LocaleKeys.sync_conflictLocal.tr(),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondaryColor.themeColor,
          ),
        ),
        Expanded(
          child: AppText(
            LocaleKeys.sync_conflictServer.tr(),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondaryColor.themeColor,
          ),
        ),
      ],
    );
  }

  Widget _fieldRow(BuildContext context, BootstrapConflictField field) {
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 64.w,
            child: AppText(
              field.label,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondaryColor.themeColor,
            ),
          ),
          Expanded(
            child: AppText(
              field.localValue,
              fontSize: 12.5,
              color: AppColors.textPrimaryColor.themeColor,
            ),
          ),
          Expanded(
            child: AppText(
              field.serverValue,
              fontSize: 12.5,
              color: AppColors.textPrimaryColor.themeColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageRow() {
    return Row(
      children: [
        SizedBox(width: 64.w),
        Expanded(
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: CustomImage(
              image: conflict.localImage!,
              width: 44.w,
              height: 44.w,
              radius: 8.r,
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: CustomImage(
              image: conflict.serverImage!,
              width: 44.w,
              height: 44.w,
              radius: 8.r,
            ),
          ),
        ),
      ],
    );
  }

  Widget _selector(BuildContext context) {
    final serverLabel = conflict.deletedOnServer
        ? LocaleKeys.sync_conflictDelete.tr()
        : LocaleKeys.sync_conflictTakeServer.tr();
    final localLabel = conflict.deletedOnServer
        ? LocaleKeys.sync_conflictKeep.tr()
        : LocaleKeys.sync_conflictKeepLocal.tr();

    return Row(
      children: [
        Expanded(
          child: _option(
            label: serverLabel,
            selected: choice == BootstrapConflictChoice.takeServer,
            onTap: () => onChanged(BootstrapConflictChoice.takeServer),
          ),
        ),
        8.width,
        Expanded(
          child: _option(
            label: localLabel,
            selected: choice == BootstrapConflictChoice.keepLocal,
            onTap: () => onChanged(BootstrapConflictChoice.keepLocal),
          ),
        ),
      ],
    );
  }

  Widget _option({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final color = AppColors.primaryColor.themeColor;
    return CustomTapEffect(
      onTap: onTap,
      child: Container(
        height: 38.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? color.withValues(alpha: 0.12)
              : AppColors.cardColor.themeColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: selected ? color : AppColors.dividerColor.themeColor,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: AppText(
          label,
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: selected ? color : AppColors.textSecondaryColor.themeColor,
        ),
      ),
    );
  }

  String _kindLabel() => switch (conflict.kind) {
        BootstrapConflictKind.category =>
          LocaleKeys.sync_conflictTypeCategory.tr(),
        BootstrapConflictKind.menuItem => LocaleKeys.sync_conflictTypeItem.tr(),
        BootstrapConflictKind.customer =>
          LocaleKeys.sync_conflictTypeCustomer.tr(),
      };
}
