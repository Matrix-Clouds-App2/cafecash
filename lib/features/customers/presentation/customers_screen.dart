import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_empty.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/circle_add_button.dart';
import '../../../core/widgets/custom_loading_widget.dart';
import '../../../core/widgets/search_field.dart';
import '../../orders/data/orders_repo.dart';
import '../logic/customers_cubit.dart';
import 'widgets/customer_card.dart';
import 'widgets/customer_form_sheet.dart';
import 'widgets/customers_filter_sheet.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final _searchCtrl = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _toggleSearch(CustomersCubit cubit) {
    setState(() => _isSearching = !_isSearching);
    if (!_isSearching) {
      _searchCtrl.clear();
      cubit.search('');
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return BlocProvider(
      create: (_) => getIt<CustomersCubit>()..fetchCustomers(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<CustomersCubit>();

          return Scaffold(
            backgroundColor: AppColors.surfaceColor.themeColor,
            appBar: AppBar(
              title: _isSearching
                  ? CustomSearchField(
                      controller: _searchCtrl,
                      onChanged: cubit.search,
                      hintText: LocaleKeys.customers_searchHint.tr(),
                    )
                  : AppText(
                      LocaleKeys.drawer_customersManagement.tr(),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryColor.themeColor,
                    ),
              backgroundColor: primary,
              foregroundColor: AppColors.textPrimaryColor.themeColor,
              actions: [
                IconButton(
                  onPressed: () => _toggleSearch(cubit),
                  icon: Icon(_isSearching
                      ? Icons.close_rounded
                      : Icons.search_rounded),
                ),
                IconButton(
                  onPressed: () {
                    final state = cubit.state;
                    CustomersFilterSheet.show(
                      context,
                      initialSort: state is CustomersSuccess
                          ? state.sort
                          : CustomersSortOption.nameAsc,
                      onApply: cubit.sort,
                    );
                  },
                  icon: const Icon(Icons.filter_list_rounded),
                ),
              ],
            ),
            floatingActionButton: CircleAddButton(
              onTap: () => CustomerFormSheet.show(
                context,
                onSubmit: (name, phone) =>
                    cubit.addCustomer(name: name, phone: phone),
              ),
            ),
            body: BlocBuilder<CustomersCubit, CustomersState>(
              builder: (context, state) {
                if (state is CustomersLoading || state is CustomersInitial) {
                  return Center(
                    child: CustomLoadingWidget(color: primary, size: 40),
                  );
                }

                if (state is CustomersError) {
                  return Center(child: Text(state.message));
                }

                final customers = (state as CustomersSuccess).customers;
                if (customers.isEmpty) {
                  return AppEmpty(
                    message: LocaleKeys.customers_empty.tr(),
                    icon: Icons.people_alt_outlined,
                  );
                }

                return ListView.separated(
                  padding: 16.paddingAll + 50.paddingBottom,
                  itemCount: customers.length,
                  separatorBuilder: (_, __) => 10.height,
                  itemBuilder: (_, i) {
                    final customer = customers[i];
                    final ordersRepo = getIt<OrdersRepo>();
                    return CustomerCard(
                      customer: customer,
                      deferredOrdersCount: ordersRepo
                          .getDeferredOrdersForCustomer(customer.id)
                          .length,
                      deferredBalance: ordersRepo.deferredBalance(
                        customer.id,
                      ),
                      onEdit: () => CustomerFormSheet.show(
                        context,
                        customer: customer,
                        onSubmit: (name, phone) => cubit.updateCustomer(
                          customer,
                          name: name,
                          phone: phone,
                        ),
                      ),
                      onDelete: () => cubit.deleteCustomer(customer),
                      onViewDeferredOrders: () async {
                        await context.pushNamed(
                          Routes.customerDeferredOrdersScreen,
                          arguments: {'customer': customer},
                        );
                        cubit.fetchCustomers();
                      },
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
