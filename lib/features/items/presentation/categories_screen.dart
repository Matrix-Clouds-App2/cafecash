import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_empty.dart';
import '../../../core/widgets/circle_add_button.dart';
import '../../../core/widgets/custom_loading_widget.dart';
import '../../../core/widgets/reorderable_grid_view.dart';
import '../data/models/category_entity.dart';
import '../logic/categories_cubit.dart';
import 'widgets/category_card.dart';
import 'widgets/category_form_sheet.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return BlocProvider(
      create: (_) => getIt<CategoriesCubit>()..fetchCategories(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<CategoriesCubit>();

          return Scaffold(
            backgroundColor: AppColors.surfaceColor.themeColor,
            appBar: AppBar(
              title: Text(LocaleKeys.drawer_itemsManagement.tr()),
              backgroundColor: primary,
              foregroundColor: AppColors.textPrimaryColor.themeColor,
            ),
            floatingActionButton: CircleAddButton(
              onTap: () => CategoryFormSheet.show(
                context,
                onSubmit: (name, imagePath) =>
                    cubit.addCategory(name: name, imagePath: imagePath),
              ),
            ),
            body: BlocBuilder<CategoriesCubit, CategoriesState>(
              builder: (context, state) {
                if (state is CategoriesLoading || state is CategoriesInitial) {
                  return Center(
                    child: CustomLoadingWidget(color: primary, size: 40),
                  );
                }

                if (state is CategoriesError) {
                  return Center(child: Text(state.message));
                }

                final categories = (state as CategoriesSuccess).categories;
                if (categories.isEmpty) {
                  return AppEmpty(
                    message: LocaleKeys.items_categoriesEmpty.tr(),
                    icon: Icons.category_outlined,
                  );
                }

                return CustomReorderableGridView(
                  padding: 16.paddingAll,
                  itemCount: categories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                    childAspectRatio: 0.85,
                  ),
                  onReorder: cubit.reorderCategories,
                  itemBuilder: (_, i) {
                    final category = categories[i];
                    return CategoryCard(
                      category: category,
                      itemsCount: cubit.itemsCount(category.id),
                      onTap: () => _openCategory(context, cubit, category),
                      onEdit: () => CategoryFormSheet.show(
                        context,
                        category: category,
                        onSubmit: (name, imagePath) => cubit.updateCategory(
                          category,
                          name: name,
                          imagePath: imagePath,
                        ),
                      ),
                      onDelete: () => cubit.deleteCategory(category),
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

  Future<void> _openCategory(
    BuildContext context,
    CategoriesCubit cubit,
    CategoryEntity category,
  ) async {
    await context.pushNamed(
      Routes.menuItemsScreen,
      arguments: {'category': category},
    );
    cubit.fetchCategories();
  }
}
