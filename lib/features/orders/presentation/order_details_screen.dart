import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_empty.dart';
import '../../../core/widgets/cancel_reason_sheet.dart';
import '../../../core/widgets/custom_loading_widget.dart';
import '../../customers/presentation/widgets/customer_picker_sheet.dart';
import '../data/models/order_location_kind.dart';
import '../logic/order_cubit.dart';
import 'widgets/order_action_buttons.dart';
import 'widgets/order_details_item_row.dart';
import 'widgets/order_summary_bar.dart';
import 'widgets/payment_method_sheet.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({
    super.key,
    required this.locationId,
    required this.locationNumber,
    required this.kind,
    required this.locationLabel,
    required this.syncStatus,
  });

  final int locationId;
  final int locationNumber;
  final OrderLocationKind kind;
  final String locationLabel;
  final LocationStatusSync syncStatus;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return BlocProvider(
      create: (_) => getIt<OrderCubit>()
        ..load(
          locationId: locationId,
          locationNumber: locationNumber,
          kind: kind,
          locationLabel: locationLabel,
          syncStatus: syncStatus,
        ),
      child: Builder(
        builder: (context) {
          final cubit = context.read<OrderCubit>();

          return Scaffold(
            backgroundColor: AppColors.surfaceColor.themeColor,
            appBar: AppBar(
              title: Text('$locationLabel $locationNumber'),
              backgroundColor: primary,
              foregroundColor: AppColors.textPrimaryColor.themeColor,
            ),
            body: BlocConsumer<OrderCubit, OrderState>(
              listener: (context, state) {
                if (state is OrderClosed) Navigator.pop(context);
              },
              builder: (context, state) {
                if (state is OrderLoading ||
                    state is OrderInitial ||
                    state is OrderClosed) {
                  return Center(
                    child: CustomLoadingWidget(color: primary, size: 40),
                  );
                }

                if (state is OrderError) {
                  return Center(child: Text(state.message));
                }

                final s = state as OrderSuccess;

                if (s.orderItems.isEmpty) {
                  return AppEmpty(
                    message: LocaleKeys.orders_empty.tr(),
                    icon: Icons.receipt_long_outlined,
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: 16.paddingAll,
                        itemCount: s.orderItems.length,
                        itemBuilder: (_, i) {
                          final item = s.orderItems[i];
                          return OrderDetailsItemRow(
                            item: item,
                            onIncrement: () => cubit.incrementItem(item),
                            onDecrement: () => cubit.decrementItem(item),
                            onDelete: () => cubit.removeItem(item),
                          );
                        },
                      ),
                    ),
                    OrderSummaryBar(
                      total: s.total,
                      onBack: () => Navigator.pop(context),
                    ),
                    OrderActionButtons(
                      onPartialPay: () => _openPartialPay(context, cubit),
                      onDefer: () => _deferWholeOrder(context, cubit),
                      onPayFull: () => _payFull(context, cubit),
                      onCancel: () => _confirmCancel(context, cubit),
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

  Future<void> _payFull(BuildContext context, OrderCubit cubit) async {
    final method = await PaymentMethodSheet.show(context);
    if (method != null) cubit.payFull(method);
  }

  void _openPartialPay(BuildContext context, OrderCubit cubit) {
    context.pushNamed(Routes.partialPayScreen, arguments: {'cubit': cubit});
  }

  Future<void> _deferWholeOrder(BuildContext context, OrderCubit cubit) async {
    final customer = await CustomerPickerSheet.show(context);
    if (customer != null) cubit.deferOrder(customer);
  }

  Future<void> _confirmCancel(BuildContext context, OrderCubit cubit) async {
    final reason = await CancelReasonSheet.show(
      context,
      title: LocaleKeys.orders_cancelTitle.tr(),
      message: LocaleKeys.orders_cancelMessage.tr(),
      confirmLabel: LocaleKeys.orders_cancelConfirm.tr(),
    );
    if (reason != null) cubit.cancelOrder(reason);
  }
}
