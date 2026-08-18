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
import '../../data/models/customer_entity.dart';

class CustomerCard extends StatelessWidget {
  const CustomerCard({
    super.key,
    required this.customer,
    required this.deferredOrdersCount,
    required this.deferredBalance,
    required this.onEdit,
    required this.onDelete,
    required this.onViewDeferredOrders,
  });

  final CustomerEntity customer;

  final int deferredOrdersCount;

  final double deferredBalance;

  final VoidCallback onEdit;

  final VoidCallback onDelete;
  final VoidCallback onViewDeferredOrders;

  void _showOptions(BuildContext context) {
    final hasDeferred = deferredOrdersCount > 0;
    ManageOptionsSheet.show(
      context,
      title: customer.name,
      onEdit: onEdit,
      onDelete: () => _confirmDelete(context),
      extraLabel:
          hasDeferred ? LocaleKeys.customers_viewDeferredOrders.tr() : null,
      extraIcon: hasDeferred ? Icons.receipt_long_outlined : null,
      onExtra: hasDeferred ? onViewDeferredOrders : null,
    );
  }

  void _confirmDelete(BuildContext context) {
    AppConfirmDialog.show(
      context,
      icon: Icons.delete_outline_rounded,
      iconColor: AppColors.errorColor.themeColor,
      title: LocaleKeys.customers_deleteTitle.tr(),
      message: LocaleKeys.customers_deleteMessage.tr(),
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
    final accent = AppColors.accentGold.themeColor;
    final initial =
        customer.name.trim().isNotEmpty ? customer.name.trim()[0] : '?';

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
                  AppText(
                    customer.name,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    color: AppColors.textPrimaryColor.themeColor,
                  ),
                  4.height,
                  Row(
                    children: [
                      Icon(Icons.phone_outlined,
                          size: 13.sp,
                          color: AppColors.textSecondaryColor.themeColor),
                      4.width,
                      AppText(
                        customer.phone,
                        fontSize: 12.5,
                        color: AppColors.textSecondaryColor.themeColor,
                      ),
                    ],
                  ),
                  if (deferredOrdersCount > 0) ...[
                    6.height,
                    Wrap(
                      spacing: 6.w,
                      runSpacing: 4.h,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: AppText(
                            LocaleKeys.customers_deferredOrdersCount.tr(
                                namedArgs: {'count': '$deferredOrdersCount'}),
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: accent,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: accent,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: AppText(
                            '${deferredBalance.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            CustomTapEffect(
              onTap: () => _showOptions(context),
              child: Container(
                width: 32.r,
                height: 32.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surfaceColor.themeColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.more_vert_rounded,
                    color: AppColors.textSecondaryColor.themeColor,
                    size: 18.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
