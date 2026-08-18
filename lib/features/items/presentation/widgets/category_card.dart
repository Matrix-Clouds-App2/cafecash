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
import '../../../../core/widgets/manage_options_sheet.dart';
import '../../data/models/category_entity.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.itemsCount,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final CategoryEntity category;
  final int itemsCount;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  final VoidCallback onDelete;

  void _showOptions(BuildContext context) {
    ManageOptionsSheet.show(
      context,
      title: category.name,
      onEdit: onEdit,
      onDelete: () => _confirmDelete(context),
    );
  }

  void _confirmDelete(BuildContext context) {
    AppConfirmDialog.show(
      context,
      icon: Icons.delete_outline_rounded,
      iconColor: AppColors.errorColor.themeColor,
      title: LocaleKeys.items_deleteCategoryTitle.tr(),
      message: LocaleKeys.items_deleteCategoryMessage.tr(),
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
    final primary = AppColors.primaryColor.themeColor;
    final hasImage = (category.imagePath ?? '').isNotEmpty;

    return CustomTapEffect(
      onTap: onTap,
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
                      ? CustomImage(
                          image: category.imagePath!, fit: BoxFit.cover)
                      : Container(
                          color: primary.withValues(alpha: 0.08),
                          alignment: Alignment.center,
                          child: Icon(Icons.category_outlined,
                              color: primary, size: 36.sp),
                        ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        category.name,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        color: AppColors.textPrimaryColor.themeColor,
                      ),
                      3.height,
                      AppText(
                        LocaleKeys.items_itemsCount
                            .tr(namedArgs: {'count': '$itemsCount'}),
                        fontSize: 11,
                        color: AppColors.textSecondaryColor.themeColor,
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
                onTap: () => _showOptions(context),
                child: Container(
                  width: 28.r,
                  height: 28.r,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.more_vert_rounded,
                      color: Colors.white, size: 16.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
