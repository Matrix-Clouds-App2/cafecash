import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_empty.dart';
import '../../../core/widgets/circle_add_button.dart';
import '../../../core/widgets/custom_loading_widget.dart';
import '../../../core/widgets/reorderable_grid_view.dart';
import '../data/models/category_entity.dart';
import '../logic/menu_items_cubit.dart';
import 'widgets/menu_item_card.dart';
import 'widgets/menu_item_form_sheet.dart';

class MenuItemsScreen extends StatelessWidget {
  const MenuItemsScreen({super.key, required this.category});

  final CategoryEntity category;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return BlocProvider(
      create: (_) => getIt<MenuItemsCubit>()..fetchItems(category.id),
      child: Builder(
        builder: (context) {
          final cubit = context.read<MenuItemsCubit>();

          return Scaffold(
            backgroundColor: AppColors.surfaceColor.themeColor,
            appBar: AppBar(
              title: Text(category.displayName),
              backgroundColor: primary,
              foregroundColor: AppColors.textPrimaryColor.themeColor,
            ),
            floatingActionButton: CircleAddButton(
              onTap: () => MenuItemFormSheet.show(
                context,
                onSubmit: (name, price, imagePath) => cubit.addItem(
                  categoryId: category.id,
                  name: name,
                  price: price,
                  imagePath: imagePath,
                ),
              ),
            ),
            body: BlocBuilder<MenuItemsCubit, MenuItemsState>(
              builder: (context, state) {
                if (state is MenuItemsLoading || state is MenuItemsInitial) {
                  return Center(
                    child: CustomLoadingWidget(color: primary, size: 40),
                  );
                }

                if (state is MenuItemsError) {
                  return Center(child: Text(state.message));
                }

                final items = (state as MenuItemsSuccess).items;
                if (items.isEmpty) {
                  return AppEmpty(
                    message: LocaleKeys.items_itemsEmpty.tr(),
                    icon: Icons.fastfood_outlined,
                  );
                }

                return CustomReorderableGridView(
                  padding: 16.paddingAll,
                  itemCount: items.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                    childAspectRatio: 0.85,
                  ),
                  onReorder: cubit.reorderItems,
                  itemBuilder: (_, i) {
                    final item = items[i];
                    return MenuItemCard(
                      item: item,
                      onEdit: () => MenuItemFormSheet.show(
                        context,
                        item: item,
                        onSubmit: (name, price, imagePath) => cubit.updateItem(
                          item,
                          name: name,
                          price: price,
                          imagePath: imagePath,
                        ),
                      ),
                      onDelete: () => cubit.deleteItem(item),
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
