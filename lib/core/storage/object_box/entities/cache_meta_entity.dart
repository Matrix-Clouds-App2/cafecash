import 'package:objectbox/objectbox.dart';

@Entity()
class CacheMetaEntity {
  CacheMetaEntity({
    this.id = 0,
    required this.boxName,
    required this.lastSyncedAt,
  });

  int id;

  @Unique()
  String boxName;

  @Property(type: PropertyType.date)
  DateTime lastSyncedAt;
}
