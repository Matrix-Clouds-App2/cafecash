import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/convert_helper.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_empty.dart';
import '../../../core/widgets/custom_loading_widget.dart';
import '../../orders/data/models/order_location_kind.dart';
import '../../orders/data/orders_repo.dart';
import '../../payments/data/models/paid_invoice.dart';
import '../../payments/presentation/widgets/payments_invoice_card.dart';
import '../../payments/presentation/widgets/payments_tab_bar.dart';
import '../data/models/shift_entity.dart';
import '../logic/shift_summary_cubit.dart';

class ShiftOrdersScreen extends StatefulWidget {
  const ShiftOrdersScreen({super.key, required this.shift});

  final ShiftEntity shift;

  @override
  State<ShiftOrdersScreen> createState() => _ShiftOrdersScreenState();
}

class _ShiftOrdersScreenState extends State<ShiftOrdersScreen> {
  OrderLocationKind _selectedTab = OrderLocationKind.table;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final ordersRepo = getIt<OrdersRepo>();

    return BlocProvider(
      create: (_) => getIt<ShiftSummaryCubit>()..load(widget.shift),
      child: Scaffold(
        backgroundColor: AppColors.surfaceColor.themeColor,
        appBar: AppBar(
          title: Text(LocaleKeys.shift_myOrders.tr()),
          backgroundColor: primary,
          foregroundColor: Colors.white,
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
              child: PaymentsTabBar(
                selected: _selectedTab,
                onChanged: (kind) => setState(() => _selectedTab = kind),
              ),
            ),
            Expanded(
              child: BlocBuilder<ShiftSummaryCubit, ShiftSummaryState>(
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

                  final orders = (state as ShiftSummarySuccess)
                      .summary
                      .paidOrders
                      .where((order) => order.locationKindEnum == _selectedTab)
                      .toList();

                  return SingleChildScrollView(
                    padding: 16.paddingAll,
                    child: Column(
                      children: [
                        if (orders.isEmpty)
                          AppEmpty(
                            message: LocaleKeys.payments_empty.tr(),
                            icon: _selectedTab == OrderLocationKind.table
                                ? Icons.table_bar_rounded
                                : Icons.event_seat_rounded,
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: orders.length,
                            separatorBuilder: (_, __) => 14.height,
                            itemBuilder: (_, i) {
                              final order = orders[i];
                              final invoice = PaidInvoice(
                                number: '${order.id}',
                                amount: ordersRepo.orderTotal(order.id),
                                itemsCount:
                                    ordersRepo.orderItemsCount(order.id),
                                locationNumber: order.tableNumber,
                                kind: order.locationKindEnum,
                                dateTime: ConvertHelper.formatDateTime(
                                  (order.closedAt ?? order.createdAt)
                                          ?.toIso8601String() ??
                                      '',
                                  includeDate: true,
                                  includeTime: true,
                                ),
                                paymentMethod: order.paymentMethodEnum,
                              );
                              return PaymentsInvoiceCard(
                                invoice: invoice,
                                onTap: () => context.pushNamed(
                                  Routes.paidOrderDetailsScreen,
                                  arguments: {'order': order},
                                ),
                              );
                            },
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
      ),
    );
  }
}
