import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_confirm_dialog.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/custom_loading_widget.dart';
import '../../hall/data/hall_repo.dart';
import '../../hall/data/models/hall_table_entity.dart';
import '../../matches/data/matches_repo.dart';
import '../../matches/data/models/match_seat_entity.dart';
import '../../orders/data/models/order_entity.dart';
import '../../treasury/presentation/widgets/treasury_stat_card.dart';
import '../data/models/shift_entity.dart';
import '../data/models/shift_summary.dart';
import '../logic/shift_cubit.dart';
import '../logic/shift_summary_cubit.dart';
import 'widgets/shift_occupied_locations_sheet.dart';
import 'widgets/shift_period_card.dart';

class ShiftSummaryScreen extends StatelessWidget {
  const ShiftSummaryScreen({super.key, required this.shift});

  final ShiftEntity shift;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final shiftState = context.watch<ShiftCubit>().state;
    final isOpen =
        shiftState is ShiftReady && shiftState.active?.id == shift.id;

    return BlocProvider(
      create: (_) => getIt<ShiftSummaryCubit>()..load(shift),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.surfaceColor.themeColor,
            appBar: AppBar(
                title: Text(LocaleKeys.shift_summaryTitle.tr()),
                backgroundColor: primary,
                foregroundColor: AppColors.textPrimaryColor.themeColor),
            body: BlocBuilder<ShiftSummaryCubit, ShiftSummaryState>(
              builder: (context, state) {
                if (state is ShiftSummaryLoading ||
                    state is ShiftSummaryInitial) {
                  return Center(
                    child: CustomLoadingWidget(color: primary, size: 40),
                  );
                }

                if (state is ShiftSummaryError) {
                  return Center(child: Text(state.message));
                }

                final summary = (state as ShiftSummarySuccess).summary;

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: 16.paddingAll,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShiftPeriodCard(shift: shift),
                            18.height,
                            Row(
                              children: [
                                Expanded(
                                  child: TreasuryStatCard(
                                    icon: Icons.savings_outlined,
                                    color: AppColors.secondaryColor.themeColor,
                                    label: LocaleKeys.shift_openingBalance.tr(),
                                    value:
                                        '${shift.openingBalance.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
                                  ),
                                ),
                                12.width,
                                Expanded(
                                  child: TreasuryStatCard(
                                    icon: Icons.arrow_downward_rounded,
                                    color: AppColors.successColor.themeColor,
                                    label: LocaleKeys.treasury_totalIncome.tr(),
                                    value:
                                        '${summary.totalIncome.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
                                    onTap: () => context.pushNamed(
                                      Routes.treasuryTransactionsScreen,
                                      arguments: {
                                        'isIncome': true,
                                        'shift': shift,
                                      },
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
                                    icon: Icons.arrow_upward_rounded,
                                    color: AppColors.errorColor.themeColor,
                                    label:
                                        LocaleKeys.treasury_totalExpense.tr(),
                                    value:
                                        '${summary.totalExpense.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
                                    onTap: () => context.pushNamed(
                                      Routes.treasuryTransactionsScreen,
                                      arguments: {
                                        'isIncome': false,
                                        'shift': shift,
                                      },
                                    ),
                                  ),
                                ),
                                12.width,
                                Expanded(
                                  child: TreasuryStatCard(
                                    icon: Icons.account_balance_wallet_rounded,
                                    color: primary,
                                    label: LocaleKeys.shift_closingBalance.tr(),
                                    value:
                                        '${summary.closingBalance.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
                                  ),
                                ),
                              ],
                            ),
                            10.height,
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                color: AppColors.infoColor.themeColor
                                    .withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: AppColors.infoColor.themeColor
                                      .withValues(alpha: 0.25),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.info_outline_rounded,
                                      size: 16.sp,
                                      color: AppColors.infoColor.themeColor),
                                  8.width,
                                  Expanded(
                                    child: AppText(
                                      LocaleKeys.shift_closingBalanceNote.tr(),
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.infoColor.themeColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            24.height,
                            AppText(
                              LocaleKeys.shift_ordersSummary.tr(),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimaryColor.themeColor,
                            ),
                            14.height,
                            Row(
                              children: [
                                Expanded(
                                  child: TreasuryStatCard(
                                    icon: Icons.receipt_long_outlined,
                                    color: AppColors.secondaryColor.themeColor,
                                    label: LocaleKeys.shift_ordersCount.tr(),
                                    value: '${summary.paidOrders.length}',
                                  ),
                                ),
                                12.width,
                                Expanded(
                                  child: TreasuryStatCard(
                                    icon: Icons.local_cafe_outlined,
                                    color:
                                        AppColors.textPrimaryColor.themeColor,
                                    label: LocaleKeys.shift_itemsSold.tr(),
                                    value: '${summary.itemsCount}',
                                  ),
                                ),
                              ],
                            ),
                            12.height,
                            Row(
                              children: [
                                Expanded(
                                  child: TreasuryStatCard(
                                    icon: Icons.payments_outlined,
                                    color: AppColors.successColor.themeColor,
                                    label: LocaleKeys.orders_cash.tr(),
                                    value:
                                        '${summary.cashTotal.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
                                    onTap: () => context.pushNamed(
                                      Routes.treasuryTransactionsScreen,
                                      arguments: {
                                        'paymentMethod': PaymentMethod.cash,
                                        'shift': shift,
                                      },
                                    ),
                                  ),
                                ),
                                12.width,
                                Expanded(
                                  child: TreasuryStatCard(
                                    icon: Icons.account_balance_wallet_outlined,
                                    color: AppColors.secondaryColor.themeColor,
                                    label: LocaleKeys.orders_wallet.tr(),
                                    value:
                                        '${summary.walletTotal.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
                                    onTap: () => context.pushNamed(
                                      Routes.treasuryTransactionsScreen,
                                      arguments: {
                                        'paymentMethod': PaymentMethod.wallet,
                                        'shift': shift,
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            20.height,
                            CustomButton(
                              // isOutlined: true,
                              color: Colors.white,
                              borderColor: Colors.white,
                              textColor: AppColors.textPrimaryColor.themeColor,
                              onTap: () => context.pushNamed(
                                Routes.shiftOrdersScreen,
                                arguments: {'shift': shift},
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.receipt_long_rounded,
                                      color:
                                          AppColors.textPrimaryColor.themeColor,
                                      size: 18.sp),
                                  8.width,
                                  AppText(
                                    LocaleKeys.shift_myOrders.tr(),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        AppColors.textPrimaryColor.themeColor,
                                  ),
                                ],
                              ),
                            ),
                            10.height,
                            CustomButton(
                              isOutlined: true,
                              borderColor: AppColors.errorColor.themeColor,
                              onTap: () => context.pushNamed(
                                Routes.shiftCancelledOrdersScreen,
                                arguments: {'shift': shift},
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.cancel_outlined,
                                      color: AppColors.errorColor.themeColor,
                                      size: 18.sp),
                                  8.width,
                                  AppText(
                                    '${LocaleKeys.drawer_cancelledOrders.tr()} '
                                    '(${summary.cancelledOrders.length})',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.errorColor.themeColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                      child: isOpen
                          ? CustomButton(
                              color: AppColors.errorColor.themeColor,
                              borderColor: AppColors.errorColor.themeColor,
                              onTap: () => _handleClose(context, summary),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.task_alt_rounded,
                                      color: Colors.white, size: 18.sp),
                                  8.width,
                                  AppText(
                                    LocaleKeys.shift_closeButton.tr(),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              decoration: BoxDecoration(
                                color: AppColors.dividerColor.themeColor,
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              alignment: Alignment.center,
                              child: AppText(
                                LocaleKeys.shift_closedBadge.tr(),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textSecondaryColor.themeColor,
                              ),
                            ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _handleClose(BuildContext context, ShiftSummary summary) {
    final occupiedTables = getIt<HallRepo>()
        .getTables()
        .where((table) => table.statusEnum == HallTableStatus.occupied)
        .toList();
    final occupiedSeats = getIt<MatchesRepo>()
        .getSeats()
        .where((seat) => seat.statusEnum == MatchSeatStatus.occupied)
        .toList();

    if (occupiedTables.isNotEmpty || occupiedSeats.isNotEmpty) {
      ShiftOccupiedLocationsSheet.show(
        context,
        tables: occupiedTables,
        seats: occupiedSeats,
      );
      return;
    }

    final shiftCubit = context.read<ShiftCubit>();
    AppConfirmDialog.show(
      context,
      icon: Icons.task_alt_rounded,
      iconColor: AppColors.errorColor.themeColor,
      title: LocaleKeys.shift_closeConfirmTitle.tr(),
      message: LocaleKeys.shift_closeConfirmMessage.tr(),
      confirmLabel: LocaleKeys.shift_closeButton.tr(),
      confirmColor: AppColors.errorColor.themeColor,
      onConfirm: () {
        Navigator.pop(context);
        shiftCubit.closeShift(summary.shift, summary.closingBalance);
      },
    );
  }
}
