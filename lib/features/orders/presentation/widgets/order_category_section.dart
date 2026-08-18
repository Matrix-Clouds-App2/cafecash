import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../../../core/widgets/image/custom_image.dart';
import '../../../items/data/models/category_entity.dart';
import '../../../items/data/models/menu_item_entity.dart';
import 'order_item_row.dart';

/// A collapsible category header + its item rows, inside the order-builder
/// sheet.
class OrderCategorySection extends StatelessWidget {
  const OrderCategorySection({
    super.key,
    required this.category,
    required this.items,
    required this.expanded,
    required this.onToggle,
    required this.quantities,
    required this.onIncrement,
    required this.onDecrement,
  });

  final CategoryEntity category;
  final List<MenuItemEntity> items;
  final bool expanded;
  final VoidCallback onToggle;
  final Map<int, int> quantities;
  final ValueChanged<MenuItemEntity> onIncrement;
  final ValueChanged<MenuItemEntity> onDecrement;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final hasImage = (category.imagePath ?? '').isNotEmpty;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        border: Border.all(color: primary.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          CustomTapEffect(
            onTap: onToggle,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              child: Row(
                children: [
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textSecondaryColor.themeColor,
                  ),
                  Expanded(
                    child: AppText(
                      category.name,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.center,
                      color: AppColors.textPrimaryColor.themeColor,
                    ),
                  ),
                  Container(
                    width: 34.r,
                    height: 34.r,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: primary.withValues(alpha: 0.1),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: hasImage
                        ? CustomImage(
                            image: category.imagePath!, fit: BoxFit.cover)
                        : Icon(Icons.category_outlined,
                            color: primary, size: 18.sp),
                  ),
                ],
              ),
            ),
          ),
          if (expanded)
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.h),
              child: Column(
                children: [
                  for (final item in items)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: OrderItemRow(
                        item: item,
                        quantity: quantities[item.id] ?? 0,
                        onIncrement: () => onIncrement(item),
                        onDecrement: () => onDecrement(item),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
