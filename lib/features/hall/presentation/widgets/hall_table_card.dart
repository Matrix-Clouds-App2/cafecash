import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/cancel_reason_sheet.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../data/models/hall_table_entity.dart';
import 'hall_table_options_sheet.dart';

class HallTableCard extends StatelessWidget {
  const HallTableCard({
    super.key,
    required this.table,
    required this.onDisable,
    required this.onReactivate,
    required this.onDelete,
    required this.canDelete,
    required this.onOpenOrder,
    required this.onCancelOrder,
  });

  final HallTableEntity table;
  final VoidCallback onDisable;
  final VoidCallback onReactivate;
  final VoidCallback onDelete;

  final VoidCallback onOpenOrder;

  final ValueChanged<String> onCancelOrder;

  final bool canDelete;

  Color _statusColor() {
    switch (table.statusEnum) {
      case HallTableStatus.available:
        return AppColors.successColor.themeColor;
      case HallTableStatus.occupied:
        return AppColors.accentGold.themeColor;
      case HallTableStatus.disabled:
        return AppColors.disabledColor.themeColor;
    }
  }

  String _statusLabel() {
    switch (table.statusEnum) {
      case HallTableStatus.available:
        return LocaleKeys.hall_readyBadge.tr();
      case HallTableStatus.occupied:
        return LocaleKeys.hall_occupiedBadge.tr();
      case HallTableStatus.disabled:
        return LocaleKeys.hall_disabledBadge.tr();
    }
  }

  void _onTap(BuildContext context) {
    if (table.statusEnum != HallTableStatus.disabled) {
      onOpenOrder();
      return;
    }
    AppConfirmDialog.show(
      context,
      icon: Icons.power_settings_new_rounded,
      iconColor: AppColors.primaryColor.themeColor,
      title: LocaleKeys.hall_reactivateTitle.tr(),
      message: LocaleKeys.hall_reactivateMessage.tr(),
      confirmLabel: LocaleKeys.hall_reactivateConfirm.tr(),
      onConfirm: () {
        Navigator.pop(context);
        onReactivate();
      },
    );
  }

  void _onLongPress(BuildContext context) {
    switch (table.statusEnum) {
      case HallTableStatus.disabled:
        return;
      case HallTableStatus.occupied:
        _confirmCancelOrder(context);
        return;
      case HallTableStatus.available:
        HallTableOptionsSheet.show(
          context,
          onDisable: onDisable,
          onDelete: () => _confirmDelete(context),
          canDelete: canDelete,
        );
    }
  }

  Future<void> _confirmCancelOrder(BuildContext context) async {
    final reason = await CancelReasonSheet.show(
      context,
      title: LocaleKeys.orders_cancelTitle.tr(),
      message: LocaleKeys.hall_cancelOrderMessage.tr(),
      confirmLabel: LocaleKeys.orders_cancelConfirm.tr(),
    );
    if (reason != null) onCancelOrder(reason);
  }

  void _confirmDelete(BuildContext context) {
    AppConfirmDialog.show(
      context,
      icon: Icons.delete_outline_rounded,
      iconColor: AppColors.errorColor.themeColor,
      title: LocaleKeys.hall_deleteTitle.tr(),
      message: LocaleKeys.hall_deleteMessage.tr(),
      confirmLabel: LocaleKeys.hall_deleteConfirm.tr(),
      confirmColor: AppColors.errorColor.themeColor,
      onConfirm: () {
        Navigator.pop(context);
        onDelete();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = table.statusEnum == HallTableStatus.disabled;
    final color = _statusColor();

    return CustomTapEffect(
      onTap: () => _onTap(context),
      onLongPress: () => _onLongPress(context),
      child: Opacity(
        opacity: isDisabled ? 0.55 : 1,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardColor.themeColor,
            borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
            border: Border.all(color: color.withValues(alpha: 0.35)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 18,
                offset: const Offset(0, 10),
                spreadRadius: -6,
              ),
              BoxShadow(
                color: color.withValues(alpha: 0.18),
                blurRadius: 24,
                offset: const Offset(0, 12),
                spreadRadius: -10,
              ),
              BoxShadow(
                color: color,
                blurRadius: 0.5,
                offset: const Offset(3, 3),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final circleSize = (w * 0.56).clamp(32.0, 72.0);
              final numberFont = (w * 0.24).clamp(14.0, 28.0);
              final badgeIconSize = (circleSize * 0.34).clamp(12.0, 20.0);
              final statFont = (w * 0.13).clamp(7.5, 16.0);
              final badgeFont = (w * 0.09).clamp(7.0, 9.5);
              final padding = (w * 0.06).clamp(3.0, 7.0);
              final gap = (w * 0.06).clamp(3.0, 9.0);

              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: padding, vertical: padding),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: padding, vertical: padding * 0.3),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: AppText(
                          _statusLabel(),
                          fontSize: badgeFont,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: gap),
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: circleSize,
                            height: circleSize,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  color.withValues(alpha: 0.24),
                                  color.withValues(alpha: 0.08),
                                ],
                              ),
                              border: Border.all(
                                color: color.withValues(alpha: 0.45),
                                width: 1.4,
                              ),
                            ),
                            child: AppText(
                              '${table.number}',
                              fontSize: numberFont,
                              fontWeight: FontWeight.w800,
                              color: color,
                            ),
                          ),
                          Positioned(
                            bottom: -badgeIconSize * 0.40,
                            right: -badgeIconSize * 0.50,
                            child: Container(
                              width: badgeIconSize + 10,
                              height: badgeIconSize + 10,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.cardColor.themeColor,
                                  width: 1.5,
                                ),
                              ),
                              child: Icon(Icons.table_restaurant_rounded,
                                  size: badgeIconSize * 0.8,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: gap + 10),
                      SizedBox(
                        width: w - (padding * 2),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.local_cafe_rounded,
                                  size: statFont + 2,
                                  color:
                                      AppColors.textSecondaryColor.themeColor),
                              SizedBox(width: gap * 0.3),
                              AppText(
                                '${table.drinkCount}',
                                fontSize: statFont,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textSecondaryColor.themeColor,
                              ),
                              SizedBox(width: gap * 2.4),
                              AppText(
                                table.price.toStringAsFixed(0),
                                fontSize: statFont,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimaryColor.themeColor,
                              ),
                              SizedBox(width: gap * 0.3),
                              Icon(Icons.payments_rounded,
                                  size: statFont + 2,
                                  color: AppColors.accentGold.themeColor),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
