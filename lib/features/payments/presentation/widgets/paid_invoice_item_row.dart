import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/image/custom_image.dart';
import '../../../orders/data/models/order_item_entity.dart';

/// Read-only line item for a settled invoice — no stepper, no delete, just
/// what was ordered. A paid invoice can't be edited (see [PaymentsInfoNote]).
class PaidInvoiceItemRow extends StatelessWidget {
  const PaidInvoiceItemRow({super.key, required this.item});

  final OrderItemEntity item;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final subtotal = item.price * item.quantity;
    final hasImage = (item.imagePath ?? '').isNotEmpty;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52.r,
            height: 52.r,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
            clipBehavior: Clip.antiAlias,
            child: hasImage
                ? CustomImage(image: item.imagePath!, fit: BoxFit.cover)
                : Container(
                    color: primary.withValues(alpha: 0.08),
                    alignment: Alignment.center,
                    child: Icon(Icons.fastfood_outlined,
                        color: primary, size: 22.sp),
                  ),
          ),
          12.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  item.displayName,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  color: AppColors.textPrimaryColor.themeColor,
                ),
                4.height,
                AppText(
                  '${item.quantity} × ${item.price.toStringAsFixed(0)} '
                  '${LocaleKeys.common_currency.tr()}',
                  fontSize: 12,
                  color: AppColors.textSecondaryColor.themeColor,
                ),
              ],
            ),
          ),
          12.width,
          AppText(
            '${subtotal.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryColor.themeColor,
          ),
        ],
      ),
    );
  }
}
