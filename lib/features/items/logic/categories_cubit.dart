import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/app_overlay.dart';
import '../data/items_repo.dart';
import '../data/models/category_entity.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit(this._repo) : super(const CategoriesInitial());

  final ItemsRepo _repo;

  void fetchCategories() {
    emit(const CategoriesLoading());
    try {
      final categories = _repo.getCategories();
      emit(CategoriesSuccess(categories));
    } catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }

  void addCategory({required String name, String? imagePath}) {
    try {
      _repo.addCategory(name: name, imagePath: imagePath);
      fetchCategories();
    } catch (e) {
      AppOverlay.showError(e.toString());
    }
  }

  void updateCategory(
    CategoryEntity category, {
    required String name,
    String? imagePath,
  }) {
    try {
      category
        ..name = name
        ..imagePath = imagePath;
      _repo.updateCategory(category);
      fetchCategories();
    } catch (e) {
      AppOverlay.showError(e.toString());
    }
  }

  Future<void> deleteCategory(CategoryEntity category) async {
    try {
      await _repo.deleteCategory(category);
      fetchCategories();
    } catch (e) {
      AppOverlay.showError(e.toString());
    }
  }

  int itemsCount(int categoryId) => _repo.itemsCount(categoryId);

  void reorderCategories(int oldIndex, int newIndex) {
    final currentState = state;
    if (currentState is! CategoriesSuccess) return;

    final categories = List<CategoryEntity>.from(currentState.categories);
    final moved = categories.removeAt(oldIndex);
    categories.insert(newIndex, moved);
    emit(CategoriesSuccess(categories));

    try {
      _repo.reorderCategories(categories);
    } catch (e) {
      AppOverlay.showError(e.toString());
    }
  }
}
