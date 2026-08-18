import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../../../core/widgets/image/custom_image.dart';
import '../../../items/data/models/menu_item_entity.dart';
import 'order_stepper.dart';

/// A single menu item row inside the order-builder sheet — either a plain
/// "+" (not yet in the order) or a full [OrderStepper] once it is.
class OrderItemRow extends StatelessWidget {
  const OrderItemRow({
    super.key,
    required this.item,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final MenuItemEntity item;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final hasImage = (item.imagePath ?? '').isNotEmpty;

    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor.themeColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Container(
            width: 46.r,
            height: 46.r,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
            clipBehavior: Clip.antiAlias,
            child: hasImage
                ? CustomImage(image: item.imagePath!, fit: BoxFit.cover)
                : Container(
                    color: primary.withValues(alpha: 0.08),
                    alignment: Alignment.center,
                    child: Icon(Icons.fastfood_outlined,
                        color: primary, size: 20.sp),
                  ),
          ),
          12.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  item.name,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  color: AppColors.textPrimaryColor.themeColor,
                ),
                4.height,
                AppText(
                  '${item.price.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondaryColor.themeColor,
                ),
              ],
            ),
          ),
          10.width,
          quantity > 0
              ? OrderStepper(
                  quantity: quantity,
                  onIncrement: onIncrement,
                  onDecrement: onDecrement,
                )
              : CustomTapEffect(
                  onTap: onIncrement,
                  child: Container(
                    width: 38.r,
                    height: 38.r,
                    decoration: BoxDecoration(
                      color: AppColors.successColor.themeColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.add_rounded,
                        color: Colors.white, size: 20.sp),
                  ),
                ),
        ],
      ),
    );
  }
}
