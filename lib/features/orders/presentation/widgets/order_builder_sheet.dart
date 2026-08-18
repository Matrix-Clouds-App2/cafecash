import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_empty.dart';
import '../../../../core/widgets/custom_loading_widget.dart';
import '../../data/models/order_location_kind.dart';
import '../../logic/order_cubit.dart';
import 'order_category_section.dart';
import 'order_item_row.dart';
import 'order_search_field.dart';
import 'order_sheet_header.dart';

class OrderBuilderSheet extends StatefulWidget {
  const OrderBuilderSheet({
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

  static Future<void> show(
    BuildContext context, {
    required int locationId,
    required int locationNumber,
    required OrderLocationKind kind,
    required String locationLabel,
    required LocationStatusSync syncStatus,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => OrderBuilderSheet(
        locationId: locationId,
        locationNumber: locationNumber,
        kind: kind,
        locationLabel: locationLabel,
        syncStatus: syncStatus,
      ),
    );
  }

  @override
  State<OrderBuilderSheet> createState() => _OrderBuilderSheetState();
}

class _OrderBuilderSheetState extends State<OrderBuilderSheet> {
  final _searchCtrl = TextEditingController();
  final Set<int> _expandedCategoryIds = {};

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _toggleCategory(int categoryId) {
    setState(() {
      if (!_expandedCategoryIds.remove(categoryId)) {
        _expandedCategoryIds.add(categoryId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OrderCubit>()
        ..load(
          locationId: widget.locationId,
          locationNumber: widget.locationNumber,
          kind: widget.kind,
          locationLabel: widget.locationLabel,
          syncStatus: widget.syncStatus,
        ),
      child: Builder(
        builder: (context) {
          final cubit = context.read<OrderCubit>();
          final keyboardInset = MediaQuery.of(context).viewInsets.bottom;

          return Container(
            constraints: BoxConstraints(maxHeight: context.appHeight * 0.88),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor.themeColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            child: SafeArea(
              top: false,
              child: BlocBuilder<OrderCubit, OrderState>(
                builder: (context, state) {
                  if (state is OrderLoading || state is OrderInitial) {
                    return SizedBox(
                      height: 280.h,
                      child: Center(
                        child: CustomLoadingWidget(
                          color: AppColors.primaryColor.themeColor,
                          size: 40,
                        ),
                      ),
                    );
                  }

                  if (state is OrderError) {
                    return SizedBox(
                      height: 200.h,
                      child: Center(child: Text(state.message)),
                    );
                  }

                  final s = state as OrderSuccess;
                  final detailsLabel = widget.kind == OrderLocationKind.table
                      ? LocaleKeys.orders_tableDetails.tr()
                      : LocaleKeys.matches_seatDetails.tr();

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 10.h),
                          width: 40.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.themeColor,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ),
                      OrderSheetHeader(
                        total: s.total,
                        label: s.locationLabel,
                        number: s.locationNumber,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 10.h),
                        child: OrderSearchField(
                          controller: _searchCtrl,
                          onChanged: cubit.search,
                        ),
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(
                              16.w, 0, 16.w, keyboardInset + 8.h),
                          child: _buildContent(context, s, cubit),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                        child: CustomButton(
                          color: AppColors.successColor.themeColor,
                          borderColor: AppColors.successColor.themeColor,
                          onTap: () {
                            Navigator.pop(context);
                            context.pushNamed(
                              Routes.orderDetailsScreen,
                              arguments: {
                                'locationId': widget.locationId,
                                'locationNumber': widget.locationNumber,
                                'kind': widget.kind,
                                'locationLabel': widget.locationLabel,
                                'syncStatus': widget.syncStatus,
                              },
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.receipt_long_outlined,
                                  color: Colors.white, size: 18.sp),
                              8.width,
                              Text(
                                detailsLabel,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
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
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, OrderSuccess s, OrderCubit cubit) {
    if (s.categories.isEmpty) {
      return Padding(
        padding: 24.paddingVert,
        child: Column(
          children: [
            AppEmpty(
              message: LocaleKeys.items_categoriesEmpty.tr(),
              icon: Icons.category_outlined,
            ),
            Padding(
              padding: 30.paddingHorizontal,
              child: CustomButton(
                height: 40,
                color: AppColors.textPrimaryColor.themeColor.withOpacity(0.09),
                borderColor:
                    AppColors.textPrimaryColor.themeColor.withOpacity(0.6),
                textColor:
                    AppColors.textPrimaryColor.themeColor.withOpacity(0.8),
                onTap: () {
                  Navigator.pop(context);
                  context.pushNamed(Routes.categoriesScreen);
                },
                title: LocaleKeys.drawer_itemsManagement.tr(),
              ),
            ),
          ],
        ),
      );
    }

    if (s.filteredItems != null) {
      if (s.filteredItems!.isEmpty) {
        return Padding(
          padding: 24.paddingVert,
          child: AppEmpty(
            message: LocaleKeys.orders_noSearchResults.tr(),
            icon: Icons.search_off_rounded,
          ),
        );
      }
      return Column(
        children: [
          for (final item in s.filteredItems!)
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: OrderItemRow(
                item: item,
                quantity: s.quantities[item.id] ?? 0,
                onIncrement: () => cubit.increment(item),
                onDecrement: () => cubit.decrement(item),
              ),
            ),
        ],
      );
    }

    return Column(
      children: [
        for (final category in s.categories)
          OrderCategorySection(
            category: category,
            items: s.allItems
                .where((item) => item.categoryId == category.id)
                .toList(),
            expanded: _expandedCategoryIds.contains(category.id),
            onToggle: () => _toggleCategory(category.id),
            quantities: s.quantities,
            onIncrement: cubit.increment,
            onDecrement: cubit.decrement,
          ),
      ],
    );
  }
}
