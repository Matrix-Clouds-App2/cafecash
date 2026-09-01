import 'package:objectbox/objectbox.dart';

enum PendingDeletionType { customer, category, menuItem }

@Entity()
class PendingDeletionEntity {
  PendingDeletionEntity({
    this.id = 0,
    required this.entityUuid,
    this.entityType = 0,
    this.createdAt,
  });

  int id;

  @Index()
  String entityUuid;

  int entityType;

  @Property(type: PropertyType.date)
  DateTime? createdAt;

  @Transient()
  PendingDeletionType get entityTypeEnum =>
      PendingDeletionType.values[entityType];

  set entityTypeEnum(PendingDeletionType value) => entityType = value.index;
}
