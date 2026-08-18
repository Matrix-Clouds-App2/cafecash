import '../../../core/storage/object_box/local_box.dart';
import '../../../core/storage/object_box/object_box_storage.dart';
import '../../../core/utils/local_image_picker.dart';
import 'models/category_entity.dart';
import 'models/menu_item_entity.dart';

class ItemsRepo {
  ItemsRepo({required ObjectBoxStorage storage})
      : _categoryBox = storage.box<CategoryEntity>(),
        _itemBox = storage.box<MenuItemEntity>();

  final LocalBox<CategoryEntity> _categoryBox;
  final LocalBox<MenuItemEntity> _itemBox;

  List<CategoryEntity> getCategories() {
    final categories = _categoryBox.getAll();
    categories.sort(_compareCategories);
    return categories;
  }

  int _compareCategories(CategoryEntity a, CategoryEntity b) {
    final bySortOrder = a.sortOrder.compareTo(b.sortOrder);
    if (bySortOrder != 0) return bySortOrder;
    return (a.createdAt ?? DateTime(0)).compareTo(b.createdAt ?? DateTime(0));
  }

  CategoryEntity addCategory({required String name, String? imagePath}) {
    final existing = _categoryBox.getAll();
    final nextOrder = existing.isEmpty
        ? 0
        : existing.map((c) => c.sortOrder).reduce((a, b) => a > b ? a : b) + 1;
    final category = CategoryEntity(
      name: name,
      imagePath: imagePath,
      createdAt: DateTime.now(),
      sortOrder: nextOrder,
    );
    category.id = _categoryBox.put(category);
    return category;
  }

  void updateCategory(CategoryEntity category) => _categoryBox.put(category);

  void reorderCategories(List<CategoryEntity> orderedCategories) {
    for (var i = 0; i < orderedCategories.length; i++) {
      orderedCategories[i].sortOrder = i;
    }
    _categoryBox.putMany(orderedCategories);
  }

  Future<void> deleteCategory(CategoryEntity category) async {
    final items = getItemsByCategory(category.id);
    for (final item in items) {
      await LocalImagePicker.deleteIfExists(item.imagePath);
    }
    _itemBox.removeMany(items.map((item) => item.id).toList());
    await LocalImagePicker.deleteIfExists(category.imagePath);
    _categoryBox.remove(category.id);
  }

  int itemsCount(int categoryId) => getItemsByCategory(categoryId).length;

  List<MenuItemEntity> getItemsByCategory(int categoryId) {
    final items = _itemBox
        .getAll()
        .where((item) => item.categoryId == categoryId)
        .toList();
    items.sort(_compareItems);
    return items;
  }

  int _compareItems(MenuItemEntity a, MenuItemEntity b) {
    final bySortOrder = a.sortOrder.compareTo(b.sortOrder);
    if (bySortOrder != 0) return bySortOrder;
    return (a.createdAt ?? DateTime(0)).compareTo(b.createdAt ?? DateTime(0));
  }

  MenuItemEntity addItem({
    required int categoryId,
    required String name,
    required double price,
    String? imagePath,
  }) {
    final existing = getItemsByCategory(categoryId);
    final nextOrder = existing.isEmpty
        ? 0
        : existing.map((i) => i.sortOrder).reduce((a, b) => a > b ? a : b) + 1;
    final item = MenuItemEntity(
      categoryId: categoryId,
      name: name,
      price: price,
      imagePath: imagePath,
      createdAt: DateTime.now(),
      sortOrder: nextOrder,
    );
    item.id = _itemBox.put(item);
    return item;
  }

  void updateItem(MenuItemEntity item) => _itemBox.put(item);

  void reorderItems(List<MenuItemEntity> orderedItems) {
    for (var i = 0; i < orderedItems.length; i++) {
      orderedItems[i].sortOrder = i;
    }
    _itemBox.putMany(orderedItems);
  }

  Future<void> deleteItem(MenuItemEntity item) async {
    await LocalImagePicker.deleteIfExists(item.imagePath);
    _itemBox.remove(item.id);
  }
}
