import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_confirm_dialog.dart';
import '../../../core/widgets/app_empty.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/custom_loading_widget.dart';
import '../../../core/widgets/payment_method_sheet.dart';
import '../../customers/presentation/widgets/customer_picker_sheet.dart';
import '../data/models/order_entity.dart';
import '../data/models/order_item_entity.dart';
import '../logic/order_cubit.dart';
import 'widgets/partial_pay_item_row.dart';
import 'widgets/partial_pay_result_sheet.dart';

class PartialPayScreen extends StatefulWidget {
  const PartialPayScreen({super.key, required this.cubit});

  final OrderCubit cubit;

  @override
  State<PartialPayScreen> createState() => _PartialPayScreenState();
}

class _PartialPayScreenState extends State<PartialPayScreen> {
  final Map<int, int> _selectedQuantities = {};

  void _setQuantity(OrderItemEntity item, int quantity) {
    setState(() {
      if (quantity <= 0) {
        _selectedQuantities.remove(item.id);
      } else {
        _selectedQuantities[item.id] = quantity;
      }
    });
  }

  Future<void> _pay(Map<OrderItemEntity, int> selections) async {
    if (selections.isEmpty) {
      AppOverlay.showError(LocaleKeys.orders_selectAtLeastOneItem.tr());
      return;
    }

    if (!kWalletPaymentEnabled) {
      AppConfirmDialog.show(
        context,
        icon: Icons.check_circle_outline_rounded,
        iconColor: AppColors.successColor.themeColor,
        title: LocaleKeys.orders_confirmPaymentTitle.tr(),
        message: LocaleKeys.orders_confirmPartialPaymentMessage.tr(),
        confirmLabel: LocaleKeys.orders_payButton.tr(),
        confirmColor: AppColors.successColor.themeColor,
        onConfirm: () {
          Navigator.pop(context);
          _completePayment(selections, PaymentMethod.cash);
        },
      );
      return;
    }

    final method = await PaymentMethodSheet.show(context);
    if (method == null) return;
    await _completePayment(selections, method);
  }

  Future<void> _completePayment(
    Map<OrderItemEntity, int> selections,
    PaymentMethod method,
  ) async {
    widget.cubit.collectPartialPayment(selections, method);
    setState(_selectedQuantities.clear);

    if (widget.cubit.state is OrderClosed) return;

    if (!mounted) return;
    final result = await PartialPayResultSheet.show(context);
    if (result == null) return;

    if (result == PartialPayResult.deferRemainder) {
      if (!mounted) return;
      final customer = await CustomerPickerSheet.show(context);
      if (customer == null) return;
      widget.cubit.deferOrder(customer);
      return;
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return BlocProvider.value(
      value: widget.cubit,
      child: Scaffold(
        backgroundColor: AppColors.surfaceColor.themeColor,
        appBar: AppBar(
          title: Text(LocaleKeys.orders_partialPay.tr()),
          backgroundColor: primary,
          foregroundColor: Colors.white,
        ),
        body: BlocConsumer<OrderCubit, OrderState>(
          listener: (context, state) {
            if (state is OrderClosed) Navigator.pop(context);
          },
          builder: (context, state) {
            if (state is! OrderSuccess) {
              return Center(
                child: CustomLoadingWidget(color: primary, size: 40),
              );
            }

            if (state.orderItems.isEmpty) {
              return AppEmpty(
                message: LocaleKeys.orders_empty.tr(),
                icon: Icons.receipt_long_outlined,
              );
            }

            final selections = <OrderItemEntity, int>{
              for (final item in state.orderItems)
                if ((_selectedQuantities[item.id] ?? 0) > 0)
                  item: _selectedQuantities[item.id]!,
            };
            final selectedTotal = selections.entries.fold<double>(
                0, (sum, entry) => sum + entry.key.price * entry.value);

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                  child: AppText(
                    LocaleKeys.orders_selectItemsHint.tr(),
                    fontSize: 13,
                    color: AppColors.textSecondaryColor.themeColor,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: 16.paddingHorizontal,
                    itemCount: state.orderItems.length,
                    itemBuilder: (_, i) {
                      final item = state.orderItems[i];
                      return PartialPayItemRow(
                        item: item,
                        selectedQuantity: _selectedQuantities[item.id] ?? 0,
                        onQuantityChanged: (quantity) =>
                            _setQuantity(item, quantity),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
                  decoration: BoxDecoration(
                    color: AppColors.cardColor.themeColor,
                    border: Border(
                      top: BorderSide(color: AppColors.dividerColor.themeColor),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        LocaleKeys.orders_selectedTotal.tr(),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondaryColor.themeColor,
                      ),
                      AppText(
                        '${selectedTotal.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.successColor.themeColor,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                  child: CustomButton(
                    color: AppColors.successColor.themeColor,
                    borderColor: Colors.transparent,
                    onTap: () => _pay(selections),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.payments_outlined,
                            color: Colors.white, size: 18.sp),
                        8.width,
                        AppText(
                          LocaleKeys.orders_payButton.tr(),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ],
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
