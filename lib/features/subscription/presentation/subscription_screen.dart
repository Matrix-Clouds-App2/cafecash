import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../data/models/subscription_model.dart';
import '../logic/subscription_cubit.dart';
import 'widgets/owner_only_hint.dart';
import 'widgets/plan_picker_sheet.dart';
import 'widgets/subscription_plan_card.dart';
import 'widgets/subscription_status_card.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return BlocProvider(
      create: (_) => getIt<SubscriptionCubit>()..load(),
      child: Scaffold(
        backgroundColor: AppColors.surfaceColor.themeColor,
        appBar: AppBar(
          title: AppText(
            LocaleKeys.subscription_title.tr(),
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryColor.themeColor,
          ),
          backgroundColor: primary,
          foregroundColor: AppColors.textPrimaryColor.themeColor,
          actions: [
            if (kIsOwner)
              IconButton(
                onPressed: () =>
                    context.pushNamed(Routes.subscriptionHistoryScreen),
                icon: const Icon(Icons.history_rounded),
                tooltip: LocaleKeys.subscription_historyTitle.tr(),
              ),
          ],
        ),
        body: BlocBuilder<SubscriptionCubit, SubscriptionState>(
          builder: (context, state) {
            final cubit = context.read<SubscriptionCubit>();

            return CustomScreenStateLayout(
              isLoading:
                  state is SubscriptionInitial || state is SubscriptionLoading,
              error: state is SubscriptionError
                  ? ErrorModel(
                      code: ErrorEnum.other,
                      errorMessage: state.message,
                    )
                  : null,
              onRetry: cubit.load,
              onRefresh: cubit.refresh,
              builder: (context) {
                final loaded = state as SubscriptionLoaded;
                return _content(context, cubit, loaded);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _content(
    BuildContext context,
    SubscriptionCubit cubit,
    SubscriptionLoaded loaded,
  ) {
    final sub = loaded.subscription;
    final isOwner = kIsOwner;
    final hasPlans = loaded.plans.isNotEmpty;
    final canManage = isOwner && hasPlans;

    return ListView(
      padding: 16.paddingAll + 40.paddingBottom,
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SubscriptionStatusCard(
          subscription: sub,
          mutating: loaded.mutating,
          onActivate: canManage && _showActivate(sub)
              ? () =>
                  _openPicker(context, cubit, loaded, PlanPickerMode.activate)
              : null,
          onRenew: canManage && _showRenew(sub)
              ? () => _openPicker(context, cubit, loaded, PlanPickerMode.renew)
              : null,
          onChange: canManage && _showChange(sub)
              ? () => _openPicker(context, cubit, loaded, PlanPickerMode.change)
              : null,
        ),
        if (hasPlans) ...[
          24.height,
          AppText(
            LocaleKeys.subscription_availablePlans.tr(),
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryColor.themeColor,
          ),
          12.height,
          for (final plan in loaded.plans) ...[
            SubscriptionPlanCard(
              plan: plan,
              isCurrent: sub != null &&
                  sub.isActive &&
                  sub.planCode != null &&
                  sub.planCode == plan.code,
            ),
            10.height,
          ],
        ],
        if (!isOwner) ...[
          16.height,
          const OwnerOnlyHint(),
        ],
      ],
    );
  }

  bool _showActivate(SubscriptionModel? s) => s == null;

  bool _showRenew(SubscriptionModel? s) =>
      s != null && (s.isActive || s.isExpired);

  bool _showChange(SubscriptionModel? s) =>
      s != null && (s.isActive || s.isPending);

  void _openPicker(
    BuildContext context,
    SubscriptionCubit cubit,
    SubscriptionLoaded loaded,
    PlanPickerMode mode,
  ) {
    PlanPickerSheet.show(
      context,
      plans: loaded.plans,
      mode: mode,
      currentPlanCode: loaded.subscription?.planCode,
      onSubmit: (planCode, effectiveMode, notes) {
        switch (mode) {
          case PlanPickerMode.activate:
            cubit.activate(planCode: planCode, notes: notes);
          case PlanPickerMode.renew:
            cubit.renew(planCode: planCode, notes: notes);
          case PlanPickerMode.change:
            cubit.changePlan(
              planCode: planCode,
              effectiveMode: effectiveMode ?? 'after_current',
              notes: notes,
            );
        }
      },
    );
  }
}
