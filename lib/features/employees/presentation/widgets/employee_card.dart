import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../../../core/widgets/manage_options_sheet.dart';
import '../../data/models/employee_model.dart';

class EmployeeCard extends StatelessWidget {
  const EmployeeCard({
    super.key,
    required this.employee,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleActive,
  });

  final EmployeeModel employee;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggleActive;

  // void _showOptions(BuildContext context) {
  //   ManageOptionsSheet.show(
  //     context,
  //     title: employee.name,
  //     onEdit: onEdit,
  //     onDelete: () => _confirmDelete(context),
  //   );
  // }

  void _confirmDelete(BuildContext context) {
    AppConfirmDialog.show(
      context,
      icon: Icons.delete_outline_rounded,
      iconColor: AppColors.errorColor.themeColor,
      title: LocaleKeys.employees_deleteTitle.tr(),
      message: LocaleKeys.employees_deleteMessage.tr(),
      confirmLabel: LocaleKeys.common_delete.tr(),
      confirmColor: AppColors.errorColor.themeColor,
      onConfirm: () {
        Navigator.pop(context);
        onDelete();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final success = AppColors.successColor.themeColor;
    final error = AppColors.errorColor.themeColor;
    final statusColor = employee.isActive ? success : error;
    final initial =
        employee.name.trim().isNotEmpty ? employee.name.trim()[0] : '?';

    return CustomTapEffect(
      onTap: onEdit,
      child: Container(
        width: double.infinity,
        padding: 14.paddingAll,
        decoration: BoxDecoration(
          color: AppColors.cardColor.themeColor,
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46.w,
              height: 46.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: AppText(
                initial.toUpperCase(),
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: primary,
              ),
            ),
            12.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: AppText(
                          employee.name,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          color: AppColors.textPrimaryColor.themeColor,
                        ),
                      ),
                      8.width,
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: AppText(
                          employee.isActive
                              ? LocaleKeys.employees_statusActive.tr()
                              : LocaleKeys.employees_statusInactive.tr(),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                  4.height,
                  Row(
                    children: [
                      Icon(Icons.phone_outlined,
                          size: 13.sp,
                          color: AppColors.textSecondaryColor.themeColor),
                      4.width,
                      AppText(
                        employee.phone,
                        fontSize: 12.5,
                        color: AppColors.textSecondaryColor.themeColor,
                      ),
                    ],
                  ),
                  if (employee.email != null &&
                      employee.email!.isNotEmpty) ...[
                    3.height,
                    Row(
                      children: [
                        Icon(Icons.email_outlined,
                            size: 13.sp,
                            color: AppColors.textSecondaryColor.themeColor),
                        4.width,
                        Flexible(
                          child: AppText(
                            employee.email!,
                            fontSize: 12.5,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            color: AppColors.textSecondaryColor.themeColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.scale(
                  scale: 0.7,
                  child: Switch(
                    value: employee.isActive,
                    onChanged: onToggleActive,
                    activeThumbColor: AppColors.primaryColor.themeColor,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                6.height,
                CustomTapEffect(
                  onTap: () => _confirmDelete(context),
                  child: Container(
                    width: 32.r,
                    height: 32.r,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.delete,
                        color: Colors.red,
                        size: 18.sp),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
