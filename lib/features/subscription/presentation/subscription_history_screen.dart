import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_empty.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../logic/subscription_history_cubit.dart';
import 'widgets/subscription_history_card.dart';

class SubscriptionHistoryScreen extends StatelessWidget {
  const SubscriptionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return BlocProvider(
      create: (_) => getIt<SubscriptionHistoryCubit>()..load(),
      child: Scaffold(
        backgroundColor: AppColors.surfaceColor.themeColor,
        appBar: AppBar(
          title: AppText(
            LocaleKeys.subscription_historyTitle.tr(),
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryColor.themeColor,
          ),
          backgroundColor: primary,
          foregroundColor: AppColors.textPrimaryColor.themeColor,
        ),
        body: BlocBuilder<SubscriptionHistoryCubit, SubscriptionHistoryState>(
          builder: (context, state) {
            final cubit = context.read<SubscriptionHistoryCubit>();

            return CustomScreenStateLayout(
              isLoading: state is SubscriptionHistoryInitial ||
                  state is SubscriptionHistoryLoading,
              error: state is SubscriptionHistoryError
                  ? ErrorModel(
                      code: ErrorEnum.other,
                      errorMessage: state.message,
                    )
                  : null,
              isEmpty:
                  state is SubscriptionHistoryLoaded && state.entries.isEmpty,
              onRetry: cubit.load,
              onRefresh: cubit.load,
              noDataBuilder: (_) => AppEmpty(
                message: LocaleKeys.subscription_historyEmpty.tr(),
                icon: Icons.receipt_long_outlined,
              ),
              builder: (context) {
                final entries = (state as SubscriptionHistoryLoaded).entries;
                return ListView.separated(
                  padding: 16.paddingAll + 30.paddingBottom,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: entries.length,
                  separatorBuilder: (_, __) => 10.height,
                  itemBuilder: (_, i) =>
                      SubscriptionHistoryCard(entry: entries[i]),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
