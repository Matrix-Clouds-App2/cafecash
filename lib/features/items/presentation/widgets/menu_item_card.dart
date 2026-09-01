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
import '../../../../core/widgets/image/custom_image.dart';
import '../../data/models/menu_item_entity.dart';

class MenuItemCard extends StatelessWidget {
  const MenuItemCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  final MenuItemEntity item;
  final VoidCallback onEdit;

  /// Called only after the user confirms the delete dialog.
  final VoidCallback onDelete;

  void _confirmDelete(BuildContext context) {
    AppConfirmDialog.show(
      context,
      icon: Icons.delete_outline_rounded,
      iconColor: AppColors.errorColor.themeColor,
      title: LocaleKeys.items_deleteItemTitle.tr(),
      message: LocaleKeys.items_deleteItemMessage.tr(),
      confirmLabel: LocaleKeys.items_delete.tr(),
      confirmColor: AppColors.errorColor.themeColor,
      onConfirm: () {
        Navigator.pop(context);
        onDelete();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('MenuItemCard on screen → $item');
    final primary = AppColors.primaryColor.themeColor;
    final error = AppColors.errorColor.themeColor;
    final hasImage = (item.imagePath ?? '').isNotEmpty;

    return CustomTapEffect(
      onTap: onEdit,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardColor.themeColor,
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
          border: Border.all(color: primary.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: hasImage
                      ? CustomImage(image: item.imagePath!, fit: BoxFit.cover)
                      : Container(
                          color: primary.withValues(alpha: 0.08),
                          alignment: Alignment.center,
                          child: Icon(Icons.fastfood_outlined,
                              color: primary, size: 32.sp),
                        ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        item.displayName,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        color: AppColors.textPrimaryColor.themeColor,
                      ),
                      3.height,
                      AppText(
                        '${item.price.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            PositionedDirectional(
              top: 6,
              end: 6,
              child: CustomTapEffect(
                onTap: () => _confirmDelete(context),
                child: Container(
                  width: 28.r,
                  height: 28.r,
                  decoration:
                      BoxDecoration(color: error, shape: BoxShape.circle),
                  child: Icon(Icons.delete_outline_rounded,
                      color: Colors.white, size: 15.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
