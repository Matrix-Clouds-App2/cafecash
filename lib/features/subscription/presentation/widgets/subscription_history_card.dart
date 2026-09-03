import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/subscription_model.dart';
import '../subscription_labels.dart';

class SubscriptionHistoryCard extends StatelessWidget {
  const SubscriptionHistoryCard({super.key, required this.entry});

  final SubscriptionModel entry;

  @override
  Widget build(BuildContext context) {
    final accent = _accent(context);

    return Container(
      width: double.infinity,
      padding: 14.paddingAll,
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius.r),
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
              Expanded(
                child: AppText(
                  SubscriptionLabels.planName(entry.planCode,
                      fallback: entry.plan ?? ''),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryColor.themeColor,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: AppText(
                  SubscriptionLabels.status(entry.uiState),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: accent,
                ),
              ),
            ],
          ),
          8.height,
          Wrap(
            spacing: 8.w,
            runSpacing: 6.h,
            children: [
              _Tag(
                icon: Icons.sell_outlined,
                label: SubscriptionLabels.typeChip(entry),
              ),
              _Tag(
                icon: Icons.payments_outlined,
                label: SubscriptionLabels.price(entry.planPrice),
              ),
            ],
          ),
          if (entry.startsAt != null || entry.endsAt != null) ...[
            8.height,
            _Line(
              icon: Icons.date_range_rounded,
              text:
                  '${SubscriptionLabels.date(entry.startsAt)} — ${SubscriptionLabels.date(entry.endsAt)}',
            ),
          ],
          if (entry.cancelledAt != null) ...[
            6.height,
            _Line(
              icon: Icons.cancel_outlined,
              text: LocaleKeys.subscription_historyCancelledAt.tr(namedArgs: {
                'date': SubscriptionLabels.date(entry.cancelledAt)
              }),
              color: AppColors.errorColor.themeColor,
            ),
          ],
          if (entry.notes != null && entry.notes!.trim().isNotEmpty) ...[
            6.height,
            _Line(icon: Icons.notes_rounded, text: entry.notes!.trim()),
          ],
          if (entry.createdAt != null) ...[
            6.height,
            _Line(
              icon: Icons.schedule_rounded,
              text: LocaleKeys.subscription_historyCreatedAt.tr(namedArgs: {
                'date': SubscriptionLabels.date(entry.createdAt)
              }),
            ),
          ],
        ],
      ),
    );
  }

  Color _accent(BuildContext context) {
    switch (entry.uiState) {
      case SubscriptionUiState.active:
        return AppColors.successColor.themeColor;
      case SubscriptionUiState.expired:
        return AppColors.errorColor.themeColor;
      case SubscriptionUiState.pending:
        return AppColors.warningColor.themeColor;
      case SubscriptionUiState.none:
        return AppColors.textSecondaryColor.themeColor;
    }
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor.themeColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 12.sp, color: AppColors.textSecondaryColor.themeColor),
          4.width,
          AppText(
            label,
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondaryColor.themeColor,
          ),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.icon, required this.text, this.color});

  final IconData icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.textSecondaryColor.themeColor;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 13.sp, color: c),
        6.width,
        Expanded(
          child: AppText(text, fontSize: 11.5, color: c, height: 1.4),
        ),
      ],
    );
  }
}
