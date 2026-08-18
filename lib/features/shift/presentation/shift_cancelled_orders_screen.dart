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
import '../../payments/presentation/widgets/payments_tab_bar.dart';
import '../data/models/shift_entity.dart';
import '../logic/shift_summary_cubit.dart';
import 'widgets/cancelled_order_card.dart';

class ShiftCancelledOrdersScreen extends StatefulWidget {
  const ShiftCancelledOrdersScreen({super.key, required this.shift});

  final ShiftEntity shift;

  @override
  State<ShiftCancelledOrdersScreen> createState() =>
      _ShiftCancelledOrdersScreenState();
}

class _ShiftCancelledOrdersScreenState
    extends State<ShiftCancelledOrdersScreen> {
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
          title: Text(LocaleKeys.drawer_cancelledOrders.tr()),
          backgroundColor: primary,
          foregroundColor: AppColors.textPrimaryColor.themeColor,
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
                      .cancelledOrders
                      .where((order) => order.locationKindEnum == _selectedTab)
                      .toList();

                  return SingleChildScrollView(
                    padding: 16.paddingAll,
                    child: Column(
                      children: [
                        if (orders.isEmpty)
                          AppEmpty(
                            message: LocaleKeys.shift_cancelledOrdersEmpty.tr(),
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
                              return CancelledOrderCard(
                                order: order,
                                amount: ordersRepo.orderTotal(order.id),
                                itemsCount:
                                    ordersRepo.orderItemsCount(order.id),
                                dateTime: ConvertHelper.formatDateTime(
                                  (order.closedAt ?? order.createdAt)
                                          ?.toIso8601String() ??
                                      '',
                                  includeDate: true,
                                  includeTime: true,
                                ),
                                onTap: () => context.pushNamed(
                                  Routes.cancelledOrderDetailsScreen,
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
