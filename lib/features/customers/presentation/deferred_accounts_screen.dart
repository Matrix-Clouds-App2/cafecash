import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_empty.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/custom_tap_effect.dart';
import '../../orders/data/orders_repo.dart';
import '../data/customers_repo.dart';
import '../data/models/customer_entity.dart';

class DeferredAccountsScreen extends StatefulWidget {
  const DeferredAccountsScreen({super.key});

  @override
  State<DeferredAccountsScreen> createState() => _DeferredAccountsScreenState();
}

class _DeferredAccountsScreenState extends State<DeferredAccountsScreen> {
  final _ordersRepo = getIt<OrdersRepo>();
  final _customersRepo = getIt<CustomersRepo>();

  Future<void> _openCustomer(CustomerEntity customer) async {
    await context.pushNamed(
      Routes.customerDeferredOrdersScreen,
      arguments: {'customer': customer},
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final accent = AppColors.accentGold.themeColor;
    final ordersRepo = _ordersRepo;
    final customersRepo = _customersRepo;

    final owingCustomerIds = ordersRepo
        .getDeferredOrders()
        .map((order) => order.customerId)
        .whereType<int>()
        .toSet();
    final customers = customersRepo
        .getAll()
        .where((customer) => owingCustomerIds.contains(customer.id))
        .toList()
      ..sort((a, b) => ordersRepo
          .deferredBalance(b.id)
          .compareTo(ordersRepo.deferredBalance(a.id)));

    return Scaffold(
      backgroundColor: AppColors.surfaceColor.themeColor,
      appBar: AppBar(
          title: Text(LocaleKeys.drawer_deferredAccounts.tr()),
          backgroundColor: primary,
          foregroundColor: AppColors.textPrimaryColor.themeColor),
      body: customers.isEmpty
          ? AppEmpty(
              message: LocaleKeys.customers_noDeferredAccounts.tr(),
              icon: Icons.account_balance_outlined,
            )
          : ListView.separated(
              padding: 16.paddingAll,
              itemCount: customers.length,
              separatorBuilder: (_, __) => 10.height,
              itemBuilder: (_, i) {
                final customer = customers[i];
                final count =
                    ordersRepo.getDeferredOrdersForCustomer(customer.id).length;
                final balance = ordersRepo.deferredBalance(customer.id);

                return CustomTapEffect(
                  onTap: () => _openCustomer(customer),
                  child: Container(
                    width: double.infinity,
                    padding: 14.paddingAll,
                    decoration: BoxDecoration(
                      color: AppColors.cardColor.themeColor,
                      borderRadius: BorderRadius.circular(
                          AppConstants.cardBorderRadius.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44.w,
                          height: 44.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: AppText(
                            customer.name.trim().isNotEmpty
                                ? customer.name.trim()[0].toUpperCase()
                                : '?',
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: primary,
                          ),
                        ),
                        12.width,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                customer.name,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                color: AppColors.textPrimaryColor.themeColor,
                              ),
                              4.height,
                              AppText(
                                LocaleKeys.customers_deferredOrdersCount
                                    .tr(namedArgs: {'count': '$count'}),
                                fontSize: 12,
                                color: AppColors.textSecondaryColor.themeColor,
                              ),
                            ],
                          ),
                        ),
                        AppText(
                          '${balance.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: accent,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
