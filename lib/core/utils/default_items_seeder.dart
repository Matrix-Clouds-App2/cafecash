import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

import '../../features/items/data/items_repo.dart';
import '../di/injection.dart';
import '../storage/local_storage.dart';

class _SeedItem {
  const _SeedItem({
    required this.name,
    required this.price,
    required this.asset,
  });

  final String name;
  final double price;
  final String asset;
}

class _SeedCategory {
  const _SeedCategory({
    required this.name,
    required this.asset,
    required this.items,
  });

  final String name;
  final String asset;
  final List<_SeedItem> items;
}

class DefaultItemsSeeder {
  DefaultItemsSeeder._();

  static const _seedFolder = 'default_items';

  static const _categories = [
    _SeedCategory(
      name: 'مشروبات ساخنة',
      asset: 'assets/images/seed_items/hot_drink.png',
      items: [
        _SeedItem(
          name: 'شاي',
          price: 10,
          asset: 'assets/images/seed_items/tea.png',
        ),
        _SeedItem(
          name: 'شاي كشري',
          price: 10,
          asset: 'assets/images/seed_items/tea_plain.png',
        ),
        _SeedItem(
          name: 'شاي بالنعناع',
          price: 12,
          asset: 'assets/images/seed_items/tea_mint.png',
        ),
        _SeedItem(
          name: 'شاي بالحليب',
          price: 20,
          asset: 'assets/images/seed_items/tea_milk.png',
        ),
        _SeedItem(
          name: 'شاي ليبتون',
          price: 12,
          asset: 'assets/images/seed_items/tea_lipton.png',
        ),
        _SeedItem(
          name: 'نعناع',
          price: 12,
          asset: 'assets/images/seed_items/nianaa.png',
        ),
        _SeedItem(
          name: 'ينسون',
          price: 12,
          asset: 'assets/images/seed_items/yanson.png',
        ),
        _SeedItem(
          name: 'حلبة',
          price: 12,
          asset: 'assets/images/seed_items/helba.png',
        ),
        _SeedItem(
          name: 'كركدية',
          price: 12,
          asset: 'assets/images/seed_items/karkara.png',
        ),
      ],
    ),
    _SeedCategory(
      name: 'قهوة',
      asset: 'assets/images/seed_items/coffe.png',
      items: [
        _SeedItem(
          name: 'قهوة سادة',
          price: 20,
          asset: 'assets/images/seed_items/coffee_cup.png',
        ),
        _SeedItem(
          name: 'قهوة ع الريحة',
          price: 20,
          asset: 'assets/images/seed_items/coffee_cup2.png',
        ),
        _SeedItem(
          name: 'قهوة فرنساوي',
          price: 30,
          asset: 'assets/images/seed_items/coffee_cup3.png',
        ),
        _SeedItem(
          name: 'قهوة مظبوط',
          price: 20,
          asset: 'assets/images/seed_items/coffee_cup2.png',
        ),
        _SeedItem(
          name: 'قهوة زيادة',
          price: 25,
          asset: 'assets/images/seed_items/coffee_cup2.png',
        ),
        _SeedItem(
          name: 'نسكافيه',
          price: 15,
          asset: 'assets/images/seed_items/nescafe_cup.svg',
        ),
      ],
    ),
    _SeedCategory(
      name: 'عصائر',
      asset: 'assets/images/seed_items/drinks.jpeg',
      items: [
        _SeedItem(
          name: 'فرولة',
          price: 30,
          asset: 'assets/images/seed_items/straw.jpeg',
        ),
        _SeedItem(
          name: 'منجو',
          price: 50,
          asset: 'assets/images/seed_items/mango.jpg',
        ),
        _SeedItem(
          name: 'لمون نعناع',
          price: 25,
          asset: 'assets/images/seed_items/lemo.jpg',
        ),
        _SeedItem(
          name: 'برتقال',
          price: 25,
          asset: 'assets/images/seed_items/orange.jpg',
        ),
      ],
    ),
    _SeedCategory(
      name: 'ايس كريم',
      asset: 'assets/images/seed_items/ic.jpeg',
      items: [
        _SeedItem(
          name: 'منجو',
          price: 35,
          asset: 'assets/images/seed_items/ic_mango.jpg',
        ),
        _SeedItem(
          name: 'توت',
          price: 30,
          asset: 'assets/images/seed_items/blueberry.png',
        ),
        _SeedItem(
          name: 'فروله بالبيستاشيو',
          price: 60,
          asset: 'assets/images/seed_items/straw.webp',
        ),
      ],
    ),
    _SeedCategory(
      name: 'مشروبات غازية',
      asset: 'assets/images/seed_items/gas_drink.png',
      items: [
        _SeedItem(
          name: 'بيبسي',
          price: 25,
          asset: 'assets/images/seed_items/pepsi.jpeg',
        ),
        _SeedItem(
          name: 'برتقال',
          price: 25,
          asset: 'assets/images/seed_items/Mirinda.webp',
        ),
        _SeedItem(
          name: 'تفاح',
          price: 25,
          asset: 'assets/images/seed_items/apple.jpg',
        ),
        _SeedItem(
          name: 'رمان',
          price: 30,
          asset: 'assets/images/seed_items/rom.jpg',
        ),
      ],
    ),
  ];

  static Future<void> seedIfNeeded() async {
    final storage = getIt<LocalStorage>();
    if (storage.isDefaultItemsSeeded) return;

    final itemsRepo = getIt<ItemsRepo>();

    for (final seedCategory in _categories) {
      try {
        final categoryImagePath = await _copyAsset(seedCategory.asset);
        final category = itemsRepo.addCategory(
          name: seedCategory.name,
          imagePath: categoryImagePath,
        );

        for (final seedItem in seedCategory.items) {
          try {
            final itemImagePath = await _copyAsset(seedItem.asset);
            itemsRepo.addItem(
              categoryId: category.id,
              name: seedItem.name,
              price: seedItem.price,
              imagePath: itemImagePath,
            );
          } catch (_) {}
        }
      } catch (_) {}
    }

    await storage.setDefaultItemsSeeded();
  }

  static Future<String> _copyAsset(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final docsDir = await getApplicationDocumentsDirectory();
    final targetDir = Directory('${docsDir.path}/$_seedFolder');
    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }

    final fileName =
        '${DateTime.now().microsecondsSinceEpoch}_${assetPath.split('/').last}';
    final file = File('${targetDir.path}/$fileName');
    await file.writeAsBytes(
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
    );
    return file.path;
  }
}
