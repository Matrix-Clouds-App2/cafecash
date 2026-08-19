import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_empty.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/custom_loading_widget.dart';
import '../../../core/widgets/guest_lock_view.dart';
import '../../orders/data/models/order_entity.dart';
import '../../profile/logic/profile_cubit.dart';
import '../logic/treasury_cubit.dart';
import 'widgets/treasury_balance_card.dart';
import 'widgets/treasury_stat_card.dart';
import 'widgets/treasury_transaction_tile.dart';

class TreasuryScreen extends StatelessWidget {
  const TreasuryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return BlocSelector<ProfileCubit, ProfileState, bool>(
      selector: (state) => state is! ProfileSuccess,
      builder: (context, isGuest) {
        if (isGuest) {
          return Scaffold(
            backgroundColor: AppColors.surfaceColor.themeColor,
            body: Column(
              children: [
                AppTopBar(
                  title: LocaleKeys.nav_treasury.tr(),
                  onMenuTap: () => Scaffold.of(context).openDrawer(),
                ),
                const Expanded(child: GuestLockView()),
              ],
            ),
          );
        }

        return BlocProvider(
          create: (_) => getIt<TreasuryCubit>()..fetch(),
          child: Builder(
            builder: (context) {
              return Scaffold(
                backgroundColor: AppColors.surfaceColor.themeColor,
                body: Column(
                  children: [
                    AppTopBar(
                      title: LocaleKeys.nav_treasury.tr(),
                      onMenuTap: () => Scaffold.of(context).openDrawer(),
                    ),
                    Expanded(
                      child: BlocBuilder<TreasuryCubit, TreasuryState>(
                        builder: (context, state) {
                          if (state is TreasuryLoading ||
                              state is TreasuryInitial) {
                            return Center(
                              child:
                                  CustomLoadingWidget(color: primary, size: 40),
                            );
                          }

                          if (state is TreasuryError) {
                            return Center(child: Text(state.message));
                          }

                          final s = state as TreasurySuccess;

                          return SingleChildScrollView(
                            padding: 16.paddingAll,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TreasuryBalanceCard(
                                  balance: s.balance,
                                  openingBalance: s.openingBalance,
                                ),
                                if (kWalletPaymentEnabled) ...[
                                  12.height,
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TreasuryStatCard(
                                          icon: Icons.payments_outlined,
                                          color:
                                              AppColors.primaryColor.themeColor,
                                          label: LocaleKeys.treasury_totalCash
                                              .tr(),
                                          value: '${s.totalCash.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
                                          onTap: () => context.pushNamed(
                                            Routes.treasuryTransactionsScreen,
                                            arguments: {
                                              'paymentMethod':
                                                  PaymentMethod.cash,
                                            },
                                          ),
                                        ),
                                      ),
                                      12.width,
                                      Expanded(
                                        child: TreasuryStatCard(
                                          icon: Icons
                                              .account_balance_wallet_outlined,
                                          color: AppColors
                                              .secondaryColor.themeColor,
                                          label: LocaleKeys.treasury_totalWallet
                                              .tr(),
                                          value:
                                              '${s.totalWallet.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
                                          onTap: () => context.pushNamed(
                                            Routes.treasuryTransactionsScreen,
                                            arguments: {
                                              'paymentMethod':
                                                  PaymentMethod.wallet,
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                20.height,
                                Row(
                                  children: [
                                    Expanded(
                                      child: TreasuryStatCard(
                                        icon: Icons.arrow_upward_rounded,
                                        color: AppColors.errorColor.themeColor,
                                        label: LocaleKeys.treasury_totalExpense
                                            .tr(),
                                        value:
                                            '${s.totalExpense.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
                                        onTap: () => context.pushNamed(
                                          Routes.treasuryTransactionsScreen,
                                          arguments: {'isIncome': false},
                                        ),
                                      ),
                                    ),
                                    12.width,
                                    Expanded(
                                      child: TreasuryStatCard(
                                        icon: Icons.arrow_downward_rounded,
                                        color:
                                            AppColors.successColor.themeColor,
                                        label: LocaleKeys.treasury_totalIncome
                                            .tr(),
                                        value:
                                            '${s.totalIncome.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
                                        onTap: () => context.pushNamed(
                                          Routes.treasuryTransactionsScreen,
                                          arguments: {'isIncome': true},
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                12.height,
                                Row(
                                  children: [
                                    Expanded(
                                      child: TreasuryStatCard(
                                        icon: Icons.remove_rounded,
                                        color: AppColors.errorColor.themeColor,
                                        backgroundColor: AppColors
                                            .errorColor.themeColor
                                            .withValues(alpha: 0.06),
                                        label: LocaleKeys.treasury_withdrawCash
                                            .tr(),
                                        onTap: () => context.pushNamed(
                                          Routes.treasuryEntryScreen,
                                          arguments: {'isIncome': false},
                                        ),
                                      ),
                                    ),
                                    12.width,
                                    Expanded(
                                      child: TreasuryStatCard(
                                        icon: Icons.add_rounded,
                                        color:
                                            AppColors.successColor.themeColor,
                                        backgroundColor: AppColors
                                            .successColor.themeColor
                                            .withValues(alpha: 0.06),
                                        label: LocaleKeys.treasury_receiveCash
                                            .tr(),
                                        onTap: () => context.pushNamed(
                                          Routes.treasuryEntryScreen,
                                          arguments: {'isIncome': true},
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                24.height,
                                AppText(
                                  LocaleKeys.treasury_recentTransactions.tr(),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimaryColor.themeColor,
                                ),
                                14.height,
                                if (s.transactions.isEmpty)
                                  AppEmpty(
                                    message:
                                        LocaleKeys.treasury_noTransactions.tr(),
                                    icon: Icons.receipt_long_outlined,
                                  )
                                else
                                  ListView.separated(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: s.transactions.length,
                                    separatorBuilder: (_, __) => 10.height,
                                    itemBuilder: (_, i) =>
                                        TreasuryTransactionTile(
                                      transaction: s.transactions[i],
                                      onChangePaymentMethod: (method) {
                                        context
                                            .read<TreasuryCubit>()
                                            .updatePaymentMethod(
                                                s.transactions[i], method);
                                        AppOverlay.showSuccess(LocaleKeys
                                            .treasury_paymentMethodUpdated
                                            .tr());
                                      },
                                    ),
                                  ),
                                16.height,
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
