import 'package:path_provider/path_provider.dart';

import '../../../objectbox.g.dart';
import 'entities/cache_meta_entity.dart';
import 'local_box.dart';

class ObjectBoxStorage {
  ObjectBoxStorage._(this.store);

  final Store store;

  static Future<ObjectBoxStorage> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: '${docsDir.path}/objectbox');
    return ObjectBoxStorage._(store);
  }

  LocalBox<T> box<T>() => LocalBox<T>(store.box<T>());

  DateTime? lastSyncedAt(String boxName) {
    final query = store
        .box<CacheMetaEntity>()
        .query(CacheMetaEntity_.boxName.equals(boxName))
        .build();
    final meta = query.findFirst();
    query.close();
    return meta?.lastSyncedAt;
  }

  void markSynced(String boxName) {
    final metaBox = store.box<CacheMetaEntity>();
    final query =
        metaBox.query(CacheMetaEntity_.boxName.equals(boxName)).build();
    final existing = query.findFirst();
    query.close();
    metaBox.put(CacheMetaEntity(
      id: existing?.id ?? 0,
      boxName: boxName,
      lastSyncedAt: DateTime.now(),
    ));
  }

  void close() => store.close();
}
