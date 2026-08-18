import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_empty.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../data/customers_repo.dart';
import '../../data/models/customer_entity.dart';
import 'customer_form_sheet.dart';

class CustomerPickerSheet extends StatefulWidget {
  const CustomerPickerSheet({super.key});

  static Future<CustomerEntity?> show(BuildContext context) {
    return AppBottomSheet.show<CustomerEntity>(
      context,
      title: LocaleKeys.customers_pickerTitle.tr(),
      child: const CustomerPickerSheet(),
    );
  }

  @override
  State<CustomerPickerSheet> createState() => _CustomerPickerSheetState();
}

class _CustomerPickerSheetState extends State<CustomerPickerSheet> {
  final _searchCtrl = TextEditingController();
  late List<CustomerEntity> _customers;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _customers = getIt<CustomersRepo>().getAll();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _addNew() async {
    await CustomerFormSheet.show(
      context,
      onSubmit: (name, phone) {
        final customer = getIt<CustomersRepo>().add(name: name, phone: phone);
        if (mounted) Navigator.pop(context, customer);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final query = _query.trim().toLowerCase();
    final filtered = query.isEmpty
        ? _customers
        : _customers
            .where((c) =>
                c.name.toLowerCase().contains(query) || c.phone.contains(query))
            .toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextField(
          controller: _searchCtrl,
          hint: LocaleKeys.customers_searchHint.tr(),
          prefixIcon: const Icon(Icons.search_rounded),
          onChanged: (value) => setState(() => _query = value),
        ),
        14.height,
        CustomTapEffect(
          onTap: _addNew,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: primary.withValues(alpha: 0.25)),
            ),
            child: Row(
              children: [
                Icon(Icons.person_add_alt_1_rounded,
                    color: primary, size: 20.sp),
                10.width,
                AppText(
                  LocaleKeys.customers_addCustomer.tr(),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: primary,
                ),
              ],
            ),
          ),
        ),
        14.height,
        if (filtered.isEmpty)
          Padding(
            padding: 12.paddingVert,
            child: AppEmpty(
              message: LocaleKeys.customers_empty.tr(),
              icon: Icons.people_alt_outlined,
            ),
          )
        else
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 320.h),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: filtered.length,
              separatorBuilder: (_, __) => 8.height,
              itemBuilder: (_, i) {
                final customer = filtered[i];
                return CustomTapEffect(
                  onTap: () => Navigator.pop(context, customer),
                  child: Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceColor.themeColor,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36.w,
                          height: 36.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: AppText(
                            customer.name.trim().isNotEmpty
                                ? customer.name.trim()[0].toUpperCase()
                                : '?',
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: primary,
                          ),
                        ),
                        10.width,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                customer.name,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                color: AppColors.textPrimaryColor.themeColor,
                              ),
                              AppText(
                                customer.phone,
                                fontSize: 12,
                                color: AppColors.textSecondaryColor.themeColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
