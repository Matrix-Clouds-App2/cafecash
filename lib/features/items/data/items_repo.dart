import 'package:uuid/uuid.dart';

import '../../../core/storage/object_box/entities/pending_deletion_entity.dart';
import '../../../core/storage/object_box/local_box.dart';
import '../../../core/storage/object_box/object_box_storage.dart';
import '../../../core/storage/pending_deletion_repo.dart';
import '../../../core/utils/local_image_picker.dart';
import 'models/category_entity.dart';
import 'models/menu_item_entity.dart';

class ItemsRepo {
  ItemsRepo({
    required ObjectBoxStorage storage,
    required PendingDeletionRepo pendingDeletionRepo,
  })  : _categoryBox = storage.box<CategoryEntity>(),
        _itemBox = storage.box<MenuItemEntity>(),
        _pendingDeletionRepo = pendingDeletionRepo;

  final LocalBox<CategoryEntity> _categoryBox;
  final LocalBox<MenuItemEntity> _itemBox;
  final PendingDeletionRepo _pendingDeletionRepo;

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

  CategoryEntity addCategory({
    required String name,
    String? nameEn,
    String? imagePath,
    bool isDefault = false,
  }) {
    final existing = _categoryBox.getAll();
    final nextOrder = existing.isEmpty
        ? 0
        : existing.map((c) => c.sortOrder).reduce((a, b) => a > b ? a : b) + 1;
    final category = CategoryEntity(
      name: name,
      nameEn: nameEn,
      imagePath: imagePath,
      createdAt: DateTime.now(),
      sortOrder: nextOrder,
      uuid: const Uuid().v4(),
      isDefault: isDefault,
    );
    category.id = _categoryBox.put(category);
    return category;
  }

  void updateCategory(CategoryEntity category) {
    category.synced = false;
    _categoryBox.put(category);
  }

  void reorderCategories(List<CategoryEntity> orderedCategories) {
    for (var i = 0; i < orderedCategories.length; i++) {
      orderedCategories[i]
        ..sortOrder = i
        ..synced = false;
    }
    _categoryBox.putMany(orderedCategories);
  }

  Future<void> deleteCategory(CategoryEntity category) async {
    final items = getItemsByCategory(category.id);
    for (final item in items) {
      if (item.synced) {
        _pendingDeletionRepo.add(item.uuid, PendingDeletionType.menuItem);
      }
      await LocalImagePicker.deleteIfExists(item.imagePath);
    }
    _itemBox.removeMany(items.map((item) => item.id).toList());
    if (category.synced) {
      _pendingDeletionRepo.add(category.uuid, PendingDeletionType.category);
    }
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
    String? nameEn,
    required double price,
    String? imagePath,
    bool isDefault = false,
  }) {
    final existing = getItemsByCategory(categoryId);
    final nextOrder = existing.isEmpty
        ? 0
        : existing.map((i) => i.sortOrder).reduce((a, b) => a > b ? a : b) + 1;
    final item = MenuItemEntity(
      categoryId: categoryId,
      name: name,
      nameEn: nameEn,
      price: price,
      imagePath: imagePath,
      createdAt: DateTime.now(),
      sortOrder: nextOrder,
      uuid: const Uuid().v4(),
      isDefault: isDefault,
    );
    item.id = _itemBox.put(item);
    return item;
  }

  void updateItem(MenuItemEntity item) {
    item.synced = false;
    _itemBox.put(item);
  }

  void reorderItems(List<MenuItemEntity> orderedItems) {
    for (var i = 0; i < orderedItems.length; i++) {
      orderedItems[i]
        ..sortOrder = i
        ..synced = false;
    }
    _itemBox.putMany(orderedItems);
  }

  Future<void> deleteItem(MenuItemEntity item) async {
    if (item.synced) {
      _pendingDeletionRepo.add(item.uuid, PendingDeletionType.menuItem);
    }
    await LocalImagePicker.deleteIfExists(item.imagePath);
    _itemBox.remove(item.id);
  }

  List<MenuItemEntity> getAllItems() => _itemBox.getAll();

  void markCategoriesSynced(List<CategoryEntity> categories) {
    if (categories.isEmpty) return;
    for (final category in categories) {
      category.synced = true;
    }
    _categoryBox.putMany(categories);
  }

  void markItemsSynced(List<MenuItemEntity> items) {
    if (items.isEmpty) return;
    for (final item in items) {
      item.synced = true;
    }
    _itemBox.putMany(items);
  }
}
