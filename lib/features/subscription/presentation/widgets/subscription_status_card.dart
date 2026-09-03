import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/subscription_model.dart';
import '../subscription_labels.dart';

class SubscriptionStatusCard extends StatelessWidget {
  const SubscriptionStatusCard({
    super.key,
    required this.subscription,
    this.mutating = false,
    this.onActivate,
    this.onRenew,
    this.onChange,
  });

  final SubscriptionModel? subscription;
  final bool mutating;
  final VoidCallback? onActivate;
  final VoidCallback? onRenew;
  final VoidCallback? onChange;

  @override
  Widget build(BuildContext context) {
    final sub = subscription;
    final state = sub?.uiState ?? SubscriptionUiState.none;
    final accent = _accent(state);

    return Container(
      width: double.infinity,
      padding: 18.paddingAll,
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius.r),
        border: Border.all(color: accent.withValues(alpha: 0.35), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(_icon(state, sub), color: accent, size: 22.sp),
              ),
              12.width,
              Expanded(
                child: AppText(
                  _title(state, sub),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryColor.themeColor,
                ),
              ),
              _StatusChip(
                  label: SubscriptionLabels.status(state), color: accent),
            ],
          ),
          10.height,
          AppText(
            _message(state),
            fontSize: 12.5,
            height: 1.5,
            color: AppColors.textSecondaryColor.themeColor,
          ),
          if (sub != null) ...[
            14.height,
            Container(
              padding: 12.paddingAll,
              decoration: BoxDecoration(
                color: AppColors.surfaceColor.themeColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  _InfoRow(
                    icon: Icons.workspace_premium_outlined,
                    label: LocaleKeys.subscription_planLabel.tr(),
                    value: sub.isTrial
                        ? SubscriptionLabels.typeChip(sub)
                        : SubscriptionLabels.planName(sub.planCode,
                            fallback: sub.plan ?? ''),
                  ),
                  if (state == SubscriptionUiState.active) ...[
                    8.height,
                    _InfoRow(
                      icon: Icons.hourglass_bottom_rounded,
                      label: LocaleKeys.subscription_remainingLabel.tr(),
                      value: LocaleKeys.subscription_daysValue
                          .tr(namedArgs: {'days': '${sub.daysRemaining}'}),
                    ),
                  ],
                  if (state == SubscriptionUiState.pending &&
                      sub.startsAt != null) ...[
                    8.height,
                    _InfoRow(
                      icon: Icons.event_available_rounded,
                      label: LocaleKeys.subscription_startsLabel.tr(),
                      value: SubscriptionLabels.date(sub.startsAt),
                    ),
                  ],
                  if (sub.endsAt != null) ...[
                    8.height,
                    _InfoRow(
                      icon: Icons.event_busy_rounded,
                      label: LocaleKeys.subscription_endsLabel.tr(),
                      value: SubscriptionLabels.date(sub.endsAt),
                    ),
                  ],
                ],
              ),
            ),
          ],
          if (_hasActions) ...[
            16.height,
            _actions(),
          ],
        ],
      ),
    );
  }

  bool get _hasActions =>
      onActivate != null || onRenew != null || onChange != null;

  Widget _actions() {
    final buttons = <Widget>[
      if (onActivate != null)
        CustomButton(
          title: LocaleKeys.subscription_actionActivate.tr(),
          loading: mutating,
          onTap: onActivate!,
        ),
      if (onRenew != null)
        CustomButton(
          title: LocaleKeys.subscription_actionRenew.tr(),
          loading: mutating,
          onTap: onRenew!,
        ),
      if (onChange != null)
        CustomButton(
          title: LocaleKeys.subscription_actionChange.tr(),
          isOutlined: true,
          loading: mutating,
          onTap: onChange!,
        ),
    ];

    if (buttons.length == 1) return buttons.first;

    return Column(
      children: [
        for (var i = 0; i < buttons.length; i++) ...[
          if (i > 0) 10.height,
          buttons[i],
        ],
      ],
    );
  }

  Color _accent(SubscriptionUiState state) {
    switch (state) {
      case SubscriptionUiState.active:
        return AppColors.successColor.themeColor;
      case SubscriptionUiState.expired:
        return AppColors.errorColor.themeColor;
      case SubscriptionUiState.pending:
        return AppColors.warningColor.themeColor;
      case SubscriptionUiState.none:
        return AppColors.accentGold.themeColor;
    }
  }

  IconData _icon(SubscriptionUiState state, SubscriptionModel? sub) {
    if (state == SubscriptionUiState.active && (sub?.isTrial ?? false)) {
      return Icons.card_giftcard_rounded;
    }
    switch (state) {
      case SubscriptionUiState.active:
        return Icons.verified_rounded;
      case SubscriptionUiState.expired:
        return Icons.error_outline_rounded;
      case SubscriptionUiState.pending:
        return Icons.schedule_rounded;
      case SubscriptionUiState.none:
        return Icons.workspace_premium_outlined;
    }
  }

  String _title(SubscriptionUiState state, SubscriptionModel? sub) {
    if (state == SubscriptionUiState.active && (sub?.isTrial ?? false)) {
      return LocaleKeys.subscription_trialTitle.tr();
    }
    switch (state) {
      case SubscriptionUiState.active:
        return LocaleKeys.subscription_activeTitle.tr();
      case SubscriptionUiState.expired:
        return LocaleKeys.subscription_expiredTitle.tr();
      case SubscriptionUiState.pending:
        return LocaleKeys.subscription_pendingTitle.tr();
      case SubscriptionUiState.none:
        return LocaleKeys.subscription_noneTitle.tr();
    }
  }

  String _message(SubscriptionUiState state) {
    switch (state) {
      case SubscriptionUiState.active:
        return LocaleKeys.subscription_activeMessage.tr();
      case SubscriptionUiState.expired:
        return LocaleKeys.subscription_expiredMessage.tr();
      case SubscriptionUiState.pending:
        return LocaleKeys.subscription_pendingMessage.tr();
      case SubscriptionUiState.none:
        return LocaleKeys.subscription_noneMessage.tr();
    }
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: AppText(
        label,
        fontSize: 10.5,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15.sp, color: AppColors.textSecondaryColor.themeColor),
        8.width,
        AppText(
          label,
          fontSize: 12,
          color: AppColors.textSecondaryColor.themeColor,
        ),
        const Spacer(),
        Flexible(
          child: AppText(
            value,
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryColor.themeColor,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
