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

class PartialPayItemRow extends StatelessWidget {
  const PartialPayItemRow({
    super.key,
    required this.item,
    required this.selectedQuantity,
    required this.onQuantityChanged,
  });

  final OrderItemEntity item;

  final int selectedQuantity;
  final ValueChanged<int> onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final selected = selectedQuantity > 0;
    final subtotal = item.price * selectedQuantity;
    final hasImage = (item.imagePath ?? '').isNotEmpty;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        border: Border.all(
          color: selected ? primary : AppColors.dividerColor.themeColor,
          width: selected ? 1.6 : 1,
        ),
      ),
      child: Row(
        children: [
          CustomTapEffect(
            onTap: () => onQuantityChanged(selected ? 0 : item.quantity),
            child: Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected ? primary : AppColors.dividerColor.themeColor,
              size: 24.sp,
            ),
          ),
          10.width,
          Container(
            width: 44.r,
            height: 44.r,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
            clipBehavior: Clip.antiAlias,
            child: hasImage
                ? CustomImage(image: item.imagePath!, fit: BoxFit.cover)
                : Container(
                    color: primary.withValues(alpha: 0.08),
                    alignment: Alignment.center,
                    child: Icon(Icons.fastfood_outlined,
                        color: primary, size: 18.sp),
                  ),
          ),
          10.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  item.displayName,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  color: AppColors.textPrimaryColor.themeColor,
                ),
                4.height,
                AppText(
                  '${item.quantity} × ${item.price.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
                  fontSize: 11,
                  color: AppColors.textSecondaryColor.themeColor,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              OrderStepper(
                quantity: selectedQuantity,
                onIncrement: () => onQuantityChanged(
                    (selectedQuantity + 1).clamp(0, item.quantity)),
                onDecrement: () => onQuantityChanged(
                    (selectedQuantity - 1).clamp(0, item.quantity)),
              ),
              4.height,
              AppText(
                '${subtotal.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimaryColor.themeColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
