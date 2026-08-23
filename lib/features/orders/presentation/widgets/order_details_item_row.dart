import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../../../core/widgets/image/custom_image.dart';
import '../../data/models/order_item_entity.dart';
import 'order_stepper.dart';

/// One order line on the order-details/payment screen — delete + subtotal
/// on one side, name/price/stepper in the middle, photo on the other.
class OrderDetailsItemRow extends StatelessWidget {
  const OrderDetailsItemRow({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
  });

  final OrderItemEntity item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTapEffect(
                onTap: onDelete,
                child: Icon(Icons.delete_outline_rounded,
                    color: AppColors.errorColor.themeColor, size: 22.sp),
              ),
              10.height,
              AppText(
                '${subtotal.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimaryColor.themeColor,
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppText(
                    item.displayName,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    color: AppColors.textPrimaryColor.themeColor,
                  ),
                  6.height,
                  AppText(
                    '${item.price.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
                    fontSize: 12,
                    color: AppColors.textSecondaryColor.themeColor,
                  ),
                  8.height,
                  OrderStepper(
                    quantity: item.quantity,
                    onIncrement: onIncrement,
                    onDecrement: onDecrement,
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 56.r,
            height: 56.r,
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
        ],
      ),
    );
  }
}
