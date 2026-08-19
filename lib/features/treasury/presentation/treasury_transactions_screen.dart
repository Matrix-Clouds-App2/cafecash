import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_empty.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/custom_loading_widget.dart';
import '../../../core/widgets/search_field.dart';
import '../../orders/data/models/order_entity.dart';
import '../../shift/data/models/shift_entity.dart';
import '../data/models/treasury_transaction_entity.dart';
import '../logic/treasury_cubit.dart';
import 'widgets/treasury_transaction_tile.dart';
import 'widgets/treasury_transactions_filter_sheet.dart';

class TreasuryTransactionsScreen extends StatefulWidget {
  const TreasuryTransactionsScreen(
      {super.key, this.isIncome, this.paymentMethod, this.shift})
      : assert(isIncome != null || paymentMethod != null);

  final bool? isIncome;
  final PaymentMethod? paymentMethod;
  final ShiftEntity? shift;

  @override
  State<TreasuryTransactionsScreen> createState() =>
      _TreasuryTransactionsScreenState();
}

class _TreasuryTransactionsScreenState
    extends State<TreasuryTransactionsScreen> {
  final _searchCtrl = TextEditingController();
  bool _isSearching = false;
  String _query = '';
  TreasuryTransactionsSortOption _sort = TreasuryTransactionsSortOption.newest;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() => _isSearching = !_isSearching);
    if (!_isSearching) {
      _searchCtrl.clear();
      setState(() => _query = '');
    }
  }

  bool _matchesPaymentMethod(TreasuryTransactionEntity t) {
    final effective = t.paymentMethodEnum ?? PaymentMethod.cash;
    return effective == widget.paymentMethod;
  }

  List<TreasuryTransactionEntity> _filtered(
      List<TreasuryTransactionEntity> all) {
    final query = _query.trim().toLowerCase();
    var transactions = widget.paymentMethod != null
        ? all.where(_matchesPaymentMethod)
        : all.where((t) => t.isIncome == widget.isIncome);
    if (query.isNotEmpty) {
      transactions = transactions.where((t) =>
          t.title.toLowerCase().contains(query) ||
          t.subtitle.toLowerCase().contains(query) ||
          (t.createdBy ?? '').toLowerCase().contains(query));
    }
    final result = transactions.toList();
    result.sort((a, b) {
      switch (_sort) {
        case TreasuryTransactionsSortOption.newest:
          return (b.createdAt ?? DateTime(0))
              .compareTo(a.createdAt ?? DateTime(0));
        case TreasuryTransactionsSortOption.oldest:
          return (a.createdAt ?? DateTime(0))
              .compareTo(b.createdAt ?? DateTime(0));
        case TreasuryTransactionsSortOption.amountHigh:
          return b.amount.compareTo(a.amount);
        case TreasuryTransactionsSortOption.amountLow:
          return a.amount.compareTo(b.amount);
      }
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final isWallet = widget.paymentMethod == PaymentMethod.wallet;
    final color = widget.paymentMethod != null
        ? (isWallet
            ? AppColors.secondaryColor.themeColor
            : AppColors.primaryColor.themeColor)
        : (widget.isIncome!
            ? AppColors.successColor.themeColor
            : AppColors.errorColor.themeColor);
    final title = widget.paymentMethod != null
        ? (isWallet
            ? LocaleKeys.treasury_totalWallet.tr()
            : LocaleKeys.treasury_totalCash.tr())
        : (widget.isIncome!
            ? LocaleKeys.treasury_totalIncome.tr()
            : LocaleKeys.treasury_totalExpense.tr());

    return BlocProvider(
      create: (_) {
        final cubit = getIt<TreasuryCubit>();
        final shift = widget.shift;
        if (shift != null) {
          cubit.fetchForShift(shift);
        } else {
          cubit.fetch();
        }
        return cubit;
      },
      child: Scaffold(
        backgroundColor: AppColors.surfaceColor.themeColor,
        appBar: AppBar(
          title: _isSearching
              ? CustomSearchField(
                  controller: _searchCtrl,
                  onChanged: (value) => setState(() => _query = value),
                  hintText: LocaleKeys.treasury_searchHint.tr(),
                )
              : Text(title),
          backgroundColor: primary,
          foregroundColor: AppColors.textPrimaryColor.themeColor,
          actions: [
            IconButton(
              onPressed: _toggleSearch,
              icon: Icon(
                  _isSearching ? Icons.close_rounded : Icons.search_rounded),
            ),
            IconButton(
              onPressed: () => TreasuryTransactionsFilterSheet.show(
                context,
                initialSort: _sort,
                onApply: (sort) => setState(() => _sort = sort),
              ),
              icon: const Icon(Icons.filter_list_rounded),
            ),
          ],
        ),
        body: BlocBuilder<TreasuryCubit, TreasuryState>(
          builder: (context, state) {
            if (state is TreasuryLoading || state is TreasuryInitial) {
              return Center(
                child: CustomLoadingWidget(color: primary, size: 40),
              );
            }

            if (state is TreasuryError) {
              return Center(child: Text(state.message));
            }

            final s = state as TreasurySuccess;
            final transactions = _filtered(s.transactions);
            final total = widget.paymentMethod != null
                ? transactions.fold<double>(
                    0, (sum, t) => sum + (t.isIncome ? t.amount : -t.amount))
                : transactions.fold<double>(0, (sum, t) => sum + t.amount);

            return Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: 16.paddingAll,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(AppConstants.cardBorderRadius.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        title,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondaryColor.themeColor,
                      ),
                      AppText(
                        '${total.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: transactions.isEmpty
                      ? AppEmpty(
                          message: _query.isEmpty
                              ? LocaleKeys.treasury_noTransactions.tr()
                              : LocaleKeys.treasury_noSearchResults.tr(),
                          icon: Icons.receipt_long_outlined,
                        )
                      : ListView.separated(
                          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                          itemCount: transactions.length,
                          separatorBuilder: (_, __) => 10.height,
                          itemBuilder: (_, i) => TreasuryTransactionTile(
                            transaction: transactions[i],
                            onChangePaymentMethod: (method) {
                              context
                                  .read<TreasuryCubit>()
                                  .updatePaymentMethod(transactions[i], method);
                              AppOverlay.showSuccess(LocaleKeys
                                  .treasury_paymentMethodUpdated
                                  .tr());
                            },
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
