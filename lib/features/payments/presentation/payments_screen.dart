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
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/custom_loading_widget.dart';
import '../../../core/widgets/guest_lock_view.dart';
import '../../orders/data/models/order_location_kind.dart';
import '../../profile/logic/profile_cubit.dart';
import '../data/models/paid_invoice.dart';
import '../logic/payments_cubit.dart';
import 'widgets/payments_invoice_card.dart';
import 'widgets/payments_tab_bar.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  OrderLocationKind _selectedTab = OrderLocationKind.table;

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
                  title: LocaleKeys.nav_payments.tr(),
                  onMenuTap: () => Scaffold.of(context).openDrawer(),
                ),
                const Expanded(child: GuestLockView()),
              ],
            ),
          );
        }

        return BlocProvider(
          create: (_) => getIt<PaymentsCubit>()..fetch(),
          child: Builder(
            builder: (context) {
              final cubit = context.read<PaymentsCubit>();

              return Scaffold(
                backgroundColor: AppColors.surfaceColor.themeColor,
                body: Column(
                  children: [
                    AppTopBar(
                      title: LocaleKeys.nav_payments.tr(),
                      onMenuTap: () => Scaffold.of(context).openDrawer(),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                      child: PaymentsTabBar(
                        selected: _selectedTab,
                        onChanged: (kind) =>
                            setState(() => _selectedTab = kind),
                      ),
                    ),
                    Expanded(
                      child: BlocBuilder<PaymentsCubit, PaymentsState>(
                        builder: (context, state) {
                          if (state is PaymentsLoading ||
                              state is PaymentsInitial) {
                            return Center(
                              child:
                                  CustomLoadingWidget(color: primary, size: 40),
                            );
                          }

                          if (state is PaymentsError) {
                            return Center(child: Text(state.message));
                          }

                          final orders = (state as PaymentsSuccess)
                              .orders
                              .where((order) =>
                                  order.locationKindEnum == _selectedTab)
                              .toList();

                          return SingleChildScrollView(
                            padding: 16.paddingAll,
                            child: Column(
                              children: [
                                if (orders.isEmpty)
                                  AppEmpty(
                                    message: LocaleKeys.payments_empty.tr(),
                                    icon:
                                        _selectedTab == OrderLocationKind.table
                                            ? Icons.table_bar_rounded
                                            : Icons.event_seat_rounded,
                                  )
                                else
                                  ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: orders.length,
                                    separatorBuilder: (_, __) => 14.height,
                                    itemBuilder: (_, i) {
                                      final order = orders[i];
                                      final invoice = PaidInvoice(
                                        number: '${order.id}',
                                        amount: cubit.total(order),
                                        itemsCount: cubit.itemsCount(order),
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
              );
            },
          ),
        );
      },
    );
  }
}
