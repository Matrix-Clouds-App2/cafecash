import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/cancel_reason_sheet.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../data/models/match_seat_entity.dart';
import 'matches_seat_options_sheet.dart';

class MatchesSeatCard extends StatelessWidget {
  const MatchesSeatCard({
    super.key,
    required this.seat,
    required this.onDisable,
    required this.onReactivate,
    required this.onDelete,
    required this.canDelete,
    required this.onOpenOrder,
    required this.onCancelOrder,
  });

  final MatchSeatEntity seat;
  final VoidCallback onDisable;
  final VoidCallback onReactivate;
  final VoidCallback onDelete;

  final VoidCallback onOpenOrder;

  final ValueChanged<String> onCancelOrder;

  final bool canDelete;

  Color _statusColor() {
    switch (seat.statusEnum) {
      case MatchSeatStatus.available:
        return AppColors.successColor.themeColor;
      case MatchSeatStatus.occupied:
        return AppColors.accentGold.themeColor;
      case MatchSeatStatus.disabled:
        return AppColors.disabledColor.themeColor;
    }
  }

  String _statusLabel() {
    switch (seat.statusEnum) {
      case MatchSeatStatus.available:
        return LocaleKeys.matches_readyBadge.tr();
      case MatchSeatStatus.occupied:
        return LocaleKeys.matches_occupiedBadge.tr();
      case MatchSeatStatus.disabled:
        return LocaleKeys.matches_disabledBadge.tr();
    }
  }

  void _onTap(BuildContext context) {
    if (seat.statusEnum != MatchSeatStatus.disabled) {
      onOpenOrder();
      return;
    }
    AppConfirmDialog.show(
      context,
      icon: Icons.power_settings_new_rounded,
      iconColor: AppColors.primaryColor.themeColor,
      title: LocaleKeys.matches_reactivateTitle.tr(),
      message: LocaleKeys.matches_reactivateMessage.tr(),
      confirmLabel: LocaleKeys.matches_reactivateConfirm.tr(),
      onConfirm: () {
        Navigator.pop(context);
        onReactivate();
      },
    );
  }

  void _onLongPress(BuildContext context) {
    switch (seat.statusEnum) {
      case MatchSeatStatus.disabled:
        return;
      case MatchSeatStatus.occupied:
        _confirmCancelOrder(context);
        return;
      case MatchSeatStatus.available:
        MatchesSeatOptionsSheet.show(
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
      message: LocaleKeys.matches_cancelOrderMessage.tr(),
      confirmLabel: LocaleKeys.orders_cancelConfirm.tr(),
    );
    if (reason != null) onCancelOrder(reason);
  }

  void _confirmDelete(BuildContext context) {
    AppConfirmDialog.show(
      context,
      icon: Icons.delete_outline_rounded,
      iconColor: AppColors.errorColor.themeColor,
      title: LocaleKeys.matches_deleteTitle.tr(),
      message: LocaleKeys.matches_deleteMessage.tr(),
      confirmLabel: LocaleKeys.matches_deleteConfirm.tr(),
      confirmColor: AppColors.errorColor.themeColor,
      onConfirm: () {
        Navigator.pop(context);
        onDelete();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = seat.statusEnum == MatchSeatStatus.disabled;
    final color = _statusColor();

    return CustomTapEffect(
      onTap: () => _onTap(context),
      onLongPress: () => _onLongPress(context),
      child: Opacity(
        opacity: isDisabled ? 0.55 : 1,
        child: Container(
          decoration: BoxDecoration(
            color: Color.alphaBlend(
              AppColors.accentGold.themeColor.withValues(alpha: 0.12),
              AppColors.cardColor.themeColor,
            ),
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
              final chairSize = (w * 0.8).clamp(65.0, 150.0);
              final numberFont = (w * 0.15).clamp(20.0, 30.0);
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
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.event_seat_rounded,
                            size: chairSize,
                            color: color,
                          ),
                          Positioned(
                            top: 16,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: numberFont * 0.45,
                                vertical: (numberFont * 0.10),
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.cardColor.themeColor,
                                borderRadius: BorderRadius.circular(numberFont),
                                border: Border.all(color: color, width: 1.3),
                              ),
                              child: AppText(
                                '${seat.number}',
                                fontSize: numberFont,
                                fontWeight: FontWeight.w800,
                                color: color,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                                '${seat.drinkCount}',
                                fontSize: statFont,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textSecondaryColor.themeColor,
                              ),
                              SizedBox(width: gap * 2.4),
                              AppText(
                                seat.price.toStringAsFixed(0),
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
