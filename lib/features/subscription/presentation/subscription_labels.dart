import 'package:easy_localization/easy_localization.dart';

import '../../../core/utils/convert_helper.dart';
import '../../../core/utils/locale_keys.dart';
import '../data/models/subscription_model.dart';
import '../data/models/subscription_plan_model.dart';

class SubscriptionLabels {
  SubscriptionLabels._();

  static String planName(String? code, {String? fallback}) {
    switch (code) {
      case 'daily':
        return LocaleKeys.subscription_planDaily.tr();
      case 'monthly':
        return LocaleKeys.subscription_planMonthly.tr();
      case 'semi_annual':
        return LocaleKeys.subscription_planSemiAnnual.tr();
      case 'annual':
        return LocaleKeys.subscription_planAnnual.tr();
      default:
        return (fallback == null || fallback.isEmpty)
            ? LocaleKeys.subscription_planUnknown.tr()
            : fallback;
    }
  }

  static String planNameFor(SubscriptionPlanModel plan) =>
      planName(plan.code, fallback: plan.name);

  static String price(String? value) {
    final amount = double.tryParse(value ?? '') ?? 0;
    if (amount <= 0) return LocaleKeys.subscription_free.tr();
    final trimmed = amount == amount.roundToDouble()
        ? amount.toStringAsFixed(0)
        : amount.toStringAsFixed(2);
    return '$trimmed ${LocaleKeys.common_currency.tr()}';
  }

  static String duration(SubscriptionPlanModel plan) {
    switch (plan.code) {
      case 'daily':
        return LocaleKeys.subscription_durationDaily.tr();
      case 'monthly':
        return LocaleKeys.subscription_durationMonthly.tr();
      case 'semi_annual':
        return LocaleKeys.subscription_durationSemiAnnual.tr();
      case 'annual':
        return LocaleKeys.subscription_durationAnnual.tr();
      default:
        return '${plan.durationValue} ${plan.durationUnit}';
    }
  }

  static String typeChip(SubscriptionModel subscription) {
    if (subscription.isTrial || subscription.type == 'trial') {
      return LocaleKeys.subscription_trialChip.tr();
    }
    if (subscription.type == 'manual') {
      return LocaleKeys.subscription_manualChip.tr();
    }
    return LocaleKeys.subscription_paidChip.tr();
  }

  static String status(SubscriptionUiState state) {
    switch (state) {
      case SubscriptionUiState.active:
        return LocaleKeys.subscription_statusActive.tr();
      case SubscriptionUiState.expired:
        return LocaleKeys.subscription_statusExpired.tr();
      case SubscriptionUiState.pending:
        return LocaleKeys.subscription_statusPending.tr();
      case SubscriptionUiState.none:
        return LocaleKeys.subscription_statusNone.tr();
    }
  }

  static String date(DateTime? value) {
    if (value == null) return '';
    return ConvertHelper.formatDateTime(value.toIso8601String());
  }
}
