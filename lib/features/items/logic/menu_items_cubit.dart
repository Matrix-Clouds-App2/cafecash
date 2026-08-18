import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/app_overlay.dart';
import '../data/items_repo.dart';
import '../data/models/menu_item_entity.dart';

part 'menu_items_state.dart';

class MenuItemsCubit extends Cubit<MenuItemsState> {
  MenuItemsCubit(this._repo) : super(const MenuItemsInitial());

  final ItemsRepo _repo;

  void fetchItems(int categoryId) {
    emit(const MenuItemsLoading());
    try {
      final items = _repo.getItemsByCategory(categoryId);
      emit(MenuItemsSuccess(items));
    } catch (e) {
      emit(MenuItemsError(e.toString()));
    }
  }

  void addItem({
    required int categoryId,
    required String name,
    required double price,
    String? imagePath,
  }) {
    try {
      _repo.addItem(
        categoryId: categoryId,
        name: name,
        price: price,
        imagePath: imagePath,
      );
      fetchItems(categoryId);
    } catch (e) {
      AppOverlay.showError(e.toString());
    }
  }

  void updateItem(
    MenuItemEntity item, {
    required String name,
    required double price,
    String? imagePath,
  }) {
    try {
      item
        ..name = name
        ..price = price
        ..imagePath = imagePath;
      _repo.updateItem(item);
      fetchItems(item.categoryId);
    } catch (e) {
      AppOverlay.showError(e.toString());
    }
  }

  Future<void> deleteItem(MenuItemEntity item) async {
    try {
      await _repo.deleteItem(item);
      fetchItems(item.categoryId);
    } catch (e) {
      AppOverlay.showError(e.toString());
    }
  }

  void reorderItems(int oldIndex, int newIndex) {
    final currentState = state;
    if (currentState is! MenuItemsSuccess) return;

    final items = List<MenuItemEntity>.from(currentState.items);
    final moved = items.removeAt(oldIndex);
    items.insert(newIndex, moved);
    emit(MenuItemsSuccess(items));

    try {
      _repo.reorderItems(items);
    } catch (e) {
      AppOverlay.showError(e.toString());
    }
  }
}
