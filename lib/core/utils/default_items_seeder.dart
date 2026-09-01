import '../../features/items/data/items_repo.dart';
import '../di/injection.dart';

class _SeedItem {
  const _SeedItem({
    required this.name,
    required this.nameEn,
    required this.price,
    required this.asset,
  });

  final String name;
  final String nameEn;
  final double price;
  final String asset;
}

class _SeedCategory {
  const _SeedCategory({
    required this.name,
    required this.nameEn,
    required this.asset,
    required this.items,
  });

  final String name;
  final String nameEn;
  final String asset;
  final List<_SeedItem> items;
}

class DefaultItemsSeeder {
  DefaultItemsSeeder._();

  static const _categories = [
    _SeedCategory(
      name: 'قهوة',
      nameEn: 'Coffee',
      asset: 'assets/images/seed_items/coffee_plain.png',
      items: [
        _SeedItem(
          name: 'قهوة',
          nameEn: 'Coffee',
          price: 20,
          asset: 'assets/images/seed_items/coffee_plain.png',
        ),
        _SeedItem(
          name: 'قهوة دبل',
          nameEn: 'Double Coffee',
          price: 30,
          asset: 'assets/images/seed_items/coffee_double.png',
        ),
        _SeedItem(
          name: 'قهوة فرنساوي',
          nameEn: 'French Coffee',
          price: 35,
          asset: 'assets/images/seed_items/coffee_french.png',
        ),
        _SeedItem(
          name: 'كابتشينو',
          nameEn: 'Cappuccino',
          price: 35,
          asset: 'assets/images/seed_items/cappuccino.png',
        ),
        _SeedItem(
          name: 'لاتيه',
          nameEn: 'Latte',
          price: 40,
          asset: 'assets/images/seed_items/latte.png',
        ),
        _SeedItem(
          name: 'نسكافيه بحليب',
          nameEn: 'Nescafe with Milk',
          price: 35,
          asset: 'assets/images/seed_items/nescafe_milk.png',
        ),
        _SeedItem(
          name: 'نسكافيه بلاك',
          nameEn: 'Black Nescafe',
          price: 25,
          asset: 'assets/images/seed_items/nescafe_black.png',
        ),
      ],
    ),
    _SeedCategory(
      name: 'مشروبات ساخنة',
      nameEn: 'Hot Drinks',
      asset: 'assets/images/seed_items/hot_tea_plain.png',
      items: [
        _SeedItem(
          name: 'شاي عادي',
          nameEn: 'Plain Tea',
          price: 15,
          asset: 'assets/images/seed_items/hot_tea_plain.png',
        ),
        _SeedItem(
          name: 'شاي فتلة',
          nameEn: 'Strong Tea',
          price: 20,
          asset: 'assets/images/seed_items/hot_tea_fatla.png',
        ),
        _SeedItem(
          name: 'ليمون',
          nameEn: 'Hot Lemon',
          price: 25,
          asset: 'assets/images/seed_items/hot_lemon.png',
        ),
        _SeedItem(
          name: 'حلبة',
          nameEn: 'Fenugreek',
          price: 15,
          asset: 'assets/images/seed_items/hot_helba.png',
        ),
        _SeedItem(
          name: 'زنجبيل',
          nameEn: 'Ginger',
          price: 25,
          asset: 'assets/images/seed_items/hot_ginger.png',
        ),
        _SeedItem(
          name: 'سحلب بالمكسرات',
          nameEn: 'Sahlab with Nuts',
          price: 45,
          asset: 'assets/images/seed_items/hot_sahlab_nuts.png',
        ),
        _SeedItem(
          name: 'سحلب سادة',
          nameEn: 'Plain Sahlab',
          price: 30,
          asset: 'assets/images/seed_items/hot_sahlab_plain.png',
        ),
        _SeedItem(
          name: 'شاي اخضر',
          nameEn: 'Green Tea',
          price: 15,
          asset: 'assets/images/seed_items/hot_tea_green.png',
        ),
        _SeedItem(
          name: 'شاي بحليب',
          nameEn: 'Tea with Milk',
          price: 30,
          asset: 'assets/images/seed_items/hot_tea_milk.png',
        ),
        _SeedItem(
          name: 'قرفة بحليب',
          nameEn: 'Cinnamon with Milk',
          price: 45,
          asset: 'assets/images/seed_items/hot_cinnamon_milk.png',
        ),
        _SeedItem(
          name: 'قرفة سادة',
          nameEn: 'Plain Cinnamon',
          price: 25,
          asset: 'assets/images/seed_items/hot_cinnamon_plain.png',
        ),
        _SeedItem(
          name: 'كركاديه',
          nameEn: 'Hibiscus',
          price: 25,
          asset: 'assets/images/seed_items/hot_karkade.png',
        ),
        _SeedItem(
          name: 'ينسون بليمون',
          nameEn: 'Anise with Lemon',
          price: 20,
          asset: 'assets/images/seed_items/hot_anise_lemon.png',
        ),
        _SeedItem(
          name: 'ينسون',
          nameEn: 'Anise',
          price: 15,
          asset: 'assets/images/seed_items/hot_anise.png',
        ),
      ],
    ),
    _SeedCategory(
      name: 'عصائر ومشروبات باردة',
      nameEn: 'Juices & Cold Drinks',
      asset: 'assets/images/seed_items/cold_water.png',
      items: [
        _SeedItem(
          name: 'مياه معدنية',
          nameEn: 'Mineral Water',
          price: 10,
          asset: 'assets/images/seed_items/cold_water.png',
        ),
        _SeedItem(
          name: 'جوافة باللبن',
          nameEn: 'Guava with Milk',
          price: 45,
          asset: 'assets/images/seed_items/cold_guava_milk.png',
        ),
        _SeedItem(
          name: 'عصير برتقال',
          nameEn: 'Orange Juice',
          price: 30,
          asset: 'assets/images/seed_items/cold_orange.png',
        ),
        _SeedItem(
          name: 'عصير جوافة',
          nameEn: 'Guava Juice',
          price: 30,
          asset: 'assets/images/seed_items/cold_guava.png',
        ),
        _SeedItem(
          name: 'عصير رمان',
          nameEn: 'Pomegranate Juice',
          price: 50,
          asset: 'assets/images/seed_items/cold_pomegranate.png',
        ),
        _SeedItem(
          name: 'عصير فراولة',
          nameEn: 'Strawberry Juice',
          price: 35,
          asset: 'assets/images/seed_items/cold_strawberry.png',
        ),
        _SeedItem(
          name: 'عصير مانجو',
          nameEn: 'Mango Juice',
          price: 40,
          asset: 'assets/images/seed_items/cold_mango.png',
        ),
        _SeedItem(
          name: 'عناب',
          nameEn: 'Enab',
          price: 35,
          asset: 'assets/images/seed_items/cold_enab.png',
        ),
        _SeedItem(
          name: 'ليمون نعناع',
          nameEn: 'Lemon Mint',
          price: 30,
          asset: 'assets/images/seed_items/cold_lemon_mint.png',
        ),
        _SeedItem(
          name: 'ليمونادا',
          nameEn: 'Lemonade',
          price: 35,
          asset: 'assets/images/seed_items/cold_lemonade.png',
        ),
        _SeedItem(
          name: 'مشروب بوريو',
          nameEn: 'Pureo Drink',
          price: 50,
          asset: 'assets/images/seed_items/cold_pureo.png',
        ),
        _SeedItem(
          name: 'موز باللبن',
          nameEn: 'Banana with Milk',
          price: 45,
          asset: 'assets/images/seed_items/cold_banana_milk.png',
        ),
      ],
    ),
    _SeedCategory(
      name: 'مشروبات غازية',
      nameEn: 'Soft Drinks',
      asset: 'assets/images/seed_items/soda_pepsi.png',
      items: [
        _SeedItem(
          name: 'بيبسي',
          nameEn: 'Pepsi',
          price: 30,
          asset: 'assets/images/seed_items/soda_pepsi.png',
        ),
        _SeedItem(
          name: 'سبرايت',
          nameEn: 'Sprite',
          price: 30,
          asset: 'assets/images/seed_items/soda_sprite.png',
        ),
        _SeedItem(
          name: 'سفن أب',
          nameEn: '7Up',
          price: 30,
          asset: 'assets/images/seed_items/soda_sevenup.png',
        ),
        _SeedItem(
          name: 'شويبس أناناس',
          nameEn: 'Schweppes Pineapple',
          price: 35,
          asset: 'assets/images/seed_items/soda_schweppes_pineapple.png',
        ),
        _SeedItem(
          name: 'شويبس خوخ',
          nameEn: 'Schweppes Peach',
          price: 35,
          asset: 'assets/images/seed_items/soda_schweppes_peach.png',
        ),
        _SeedItem(
          name: 'شويبس ليمون نعناع',
          nameEn: 'Schweppes Lemon Mint',
          price: 35,
          asset: 'assets/images/seed_items/soda_schweppes_lemonmint.png',
        ),
        _SeedItem(
          name: 'فانتا برتقال',
          nameEn: 'Fanta Orange',
          price: 30,
          asset: 'assets/images/seed_items/soda_fanta_orange.png',
        ),
        _SeedItem(
          name: 'فانتا تفاح',
          nameEn: 'Fanta Apple',
          price: 30,
          asset: 'assets/images/seed_items/soda_fanta_apple.png',
        ),
        _SeedItem(
          name: 'كوكاكولا',
          nameEn: 'Coca-Cola',
          price: 30,
          asset: 'assets/images/seed_items/soda_cola.png',
        ),
        _SeedItem(
          name: 'مشروب V',
          nameEn: 'V Energy Drink',
          price: 35,
          asset: 'assets/images/seed_items/soda_v.png',
        ),
        _SeedItem(
          name: 'ميرندا برتقال',
          nameEn: 'Mirinda Orange',
          price: 30,
          asset: 'assets/images/seed_items/soda_mirinda.png',
        ),
      ],
    ),
    _SeedCategory(
      name: 'مأكولات',
      nameEn: 'Food',
      asset: 'assets/images/seed_items/food_om_ali.png',
      items: [
        _SeedItem(
          name: 'أم علي',
          nameEn: 'Om Ali',
          price: 50,
          asset: 'assets/images/seed_items/food_om_ali.png',
        ),
        _SeedItem(
          name: 'حمص الشام',
          nameEn: 'Hummus Al-Sham',
          price: 40,
          asset: 'assets/images/seed_items/food_hummus.png',
        ),
        _SeedItem(
          name: 'زبادي بالعسل',
          nameEn: 'Yogurt with Honey',
          price: 45,
          asset: 'assets/images/seed_items/food_yogurt_honey.png',
        ),
        _SeedItem(
          name: 'زبادي فواكه',
          nameEn: 'Fruit Yogurt',
          price: 50,
          asset: 'assets/images/seed_items/food_yogurt_fruit.png',
        ),
        _SeedItem(
          name: 'كوكتيل فواكه',
          nameEn: 'Fruit Cocktail',
          price: 50,
          asset: 'assets/images/seed_items/food_fruit_cocktail.png',
        ),
      ],
    ),
    _SeedCategory(
      name: 'آيس كريم',
      nameEn: 'Ice Cream',
      asset: 'assets/images/seed_items/ice_chocolate.png',
      items: [
        _SeedItem(
          name: 'آيس كريم شيكولاتة',
          nameEn: 'Chocolate Ice Cream',
          price: 40,
          asset: 'assets/images/seed_items/ice_chocolate.png',
        ),
        _SeedItem(
          name: 'آيس كريم فانيليا',
          nameEn: 'Vanilla Ice Cream',
          price: 35,
          asset: 'assets/images/seed_items/ice_vanilla.png',
        ),
        _SeedItem(
          name: 'آيس كريم مانجو',
          nameEn: 'Mango Ice Cream',
          price: 40,
          asset: 'assets/images/seed_items/ice_mango.png',
        ),
      ],
    ),
  ];

  static void seedIfCatalogEmpty() {
    final itemsRepo = getIt<ItemsRepo>();
    if (itemsRepo.getCategories().isNotEmpty) return;

    for (final seedCategory in _categories) {
      final category = itemsRepo.addCategory(
        name: seedCategory.name,
        nameEn: seedCategory.nameEn,
        imagePath: seedCategory.asset,
        isDefault: true,
      );

      for (final seedItem in seedCategory.items) {
        itemsRepo.addItem(
          categoryId: category.id,
          name: seedItem.name,
          nameEn: seedItem.nameEn,
          price: seedItem.price,
          imagePath: seedItem.asset,
          isDefault: true,
        );
      }
    }
  }
}
